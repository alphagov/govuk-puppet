/*
 * Flush stats to a downstream statsd server.
 *
 * To enable this backend, include 'smart_repeater' in the backends
 * configuration array:
 *
 *   backends: ['smart_repeater']
 */

var util = require('util'),
    dgram = require('dgram'),
    net = require('net'),
    logger = require('../lib/logger');

var l;
var debug;

function SmartRepeater(startupTime, config, emitter){
	var self = this;

	this.config = config.smartRepeater || {};

	this.prefix = this.config.prefix || '';
	this.prefix = (this.prefix.length == 0) ? "" : (this.prefix + ".");
	this.checkExistingPrefix = this.config.checkExistingPrefix || false;
	this.batchSize = this.config.batchSize || 1024;
	this.blacklist = this.config.blacklist || [];

	this.hostinfo = [];
	for (var i = 0; i < this.config.hosts.length; i++) {
		var host = this.config.hosts[i];
		this.hostinfo.push({
			config: host,
			errors: 0,
			flushTime: 0,
			flushes: 0,
		});
	}

	emitter.on('flush', function(time_stamp, metrics) { self.process(time_stamp, metrics); });
};

SmartRepeater.prototype.prefixedKey = function(key) {
	if (this.checkExistingPrefix && key.indexOf(this.prefix) === 0) {
		return key;
	}

	return this.prefix + key;
}

SmartRepeater.prototype.blacklisted = function(key) {
	var i;

	for (i = 0; i < this.blacklist.length; i++) {
		if (this.blacklist[i].test(key)) {
			return true;
		}
	}

	return false;
}

SmartRepeater.prototype.sampleRateToString = function(number) {
	var string = number.toFixed(3);
	var index = string.length - 1;

	if (string[index] == "0") {
		while (index >= 0 && (string[index] == "0" || string[index] == ".")) { index--; }
		if (index < 0) {
			string = '0';
		}
		else {
			string = string.substring(0, index + 1);
		}
	}

	return string;
};

SmartRepeater.prototype.reconstituteMessages = function(metrics) {
	var key, i;
	var outgoing = [];

	for (key in metrics.gauges) {
		if (this.blacklisted(key)) { continue; }
		outgoing.push(this.prefixedKey(key) + ":" + metrics.gauges[key] + "|g");
	}

	for (key in metrics.counters) {
		if (this.blacklisted(key)) { continue; }
		outgoing.push(this.prefixedKey(key) + ":" + metrics.counters[key] + "|c");
	}

	for (key in metrics.timers) {
		if (this.blacklisted(key)) { continue; }
		var values = metrics.timers[key];
		var sampleRate = values.length / metrics.timer_counters[key];
		var sampleRateString = (sampleRate >= 1) ? "" : ("|@" + this.sampleRateToString(sampleRate));

		var rebuiltValues = [];
		for (i = 0; i < values.length; i++) {
			rebuiltValues.push(values[i] + "|ms" + sampleRateString);
		}

		outgoing.push(this.prefixedKey(key) + ":" + rebuiltValues.join(":"));
	}

	for (key in metrics.sets) {
		if (this.blacklisted(key)) { continue; }
		var values = metrics.sets[key].values();

		var rebuiltValues = [];
		for (i = 0; i < values.length; i++) {
			rebuiltValues.push(values[i] + "|s");
		}

		outgoing.push(this.prefixedKey(key) + ":" + rebuiltValues.join(":"));
	}

	return outgoing;
};

SmartRepeater.prototype.sendToHost = function(host, metrics) {
	var i;

	var starttime = Date.now();

	var data = this.splitStats([
		this.prefix + "statsd-smart-repeater.errors:" + host.errors + "|g",
		this.prefix + "statsd-smart-repeater.flushTime:" + host.flushTime + "|g",
		this.prefix + "statsd-smart-repeater.flushes:" + host.flushes + "|g",
	]).concat(metrics);

	try {
		if (host.config.protocol == "udp4" || host.config.protocol == "udp6") {
			var sent = 0;
			var sock = dgram.createSocket(host.config.protocol);
			try {
				for (i = 0; i < data.length; i++) {
					var single = data[i];
					var buffer = new Buffer(single);
					sock.send(buffer, 0, single.length, host.config.port, host.config.hostname, function(err, bytes) {
						sent++;
						if (err && debug) {
							l.log(err);
						}

						if (sent == data.length) {
							sock.close();
						}
					});
				}
			}
			catch(e) {
				if (debug) {
					l.log(e);
					host.errors++;
				}
			}
		}
		else {
			var sock = net.createConnection(host.config.port, host.config.hostname);
			sock.setEncoding('utf8');
			sock.setKeepAlive(false);
			sock.setTimeout(5000, function() {
				if (debug) {
					l.log("Socket timed out");
				}
				host.errors++;
				sock.end();
			});
			sock.addListener('error', function(connectionException) {
				if (debug) {
					l.log(connectionException);
				}
				host.errors++;
				sock.end();
			});
			sock.on('connect', function() {
				try {
					for (i = 0; i < data.length; i++) {
						var single = data[i];
						if (i != 0) {
							sock.write("\n");
						}
						sock.write(single);
					}
				}
				catch(e) {
					if (debug) {
						l.log(e);
					}
					host.errors++;
				}
				finally {
					sock.end();
				}
			});
		}
	}
	catch(e) {
		if (debug) {
			l.log(e);
		}
		host.errors++;
	}

	host.flushTime = (Date.now() - starttime);
	host.flushes++;
};

SmartRepeater.prototype.splitStats = function(stats) {
	var i;

	var buffers = [];
	var buffer = [];
	var bufferLength = 0;

	for (i = 0; i < stats.length; i++) {
		var line = stats[i];
		var lineLength = line.length;

		if (bufferLength != 0 && (bufferLength + lineLength) > this.batchSize) {
			buffers.push(buffer);
			buffer = [];
			bufferLength = 0;
		}

		buffer.push(line);
		bufferLength += lineLength;
	}

	if (bufferLength > 0) {
		buffers.push(buffer);
	}

	var lines = [];
	for (i = 0; i < buffers.length; i++) {
		lines.push(buffers[i].join("\n"));
	}

	return lines;
}

SmartRepeater.prototype.distribute = function(reconstituted) {
	var i;

	var lines = this.splitStats(reconstituted);

	for (i = 0; i < this.hostinfo.length; i++) {
		var host = this.hostinfo[i];
		this.sendToHost(host, lines);
	}
};

SmartRepeater.prototype.process = function(time_stamp, metrics) {
	this.distribute(this.reconstituteMessages(metrics));
};

exports.init = function(startupTime, config, events) {
	var instance = new SmartRepeater(startupTime, config, events);
	l = new logger.Logger(config.log || {});
	debug = config.debug;
	return true;
};

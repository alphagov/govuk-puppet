class hosts::ertp_staging {
  host { 'ertp-ems-api':       ip => '10.32.5.251' }
  host { 'ertp-citizen-api':   ip => '10.241.67.78' }
  host { 'ertp-dwp-api':       ip => '10.32.1.112' }
  host { 'ertp-mongo-1':       ip => '10.234.119.78' }
  host { 'ertp-mongo-2':       ip => '10.229.123.95' }
  host { 'ertp-mongo-3':       ip => '10.234.43.20' }
  host { 'places-api':         ip => '10.235.75.123' }
  host { 'monitoring.cluster': ip => '10.51.62.202' }
  host { 'graylog.cluster':    ip => '10.32.31.104' }
}

# Data replication

Dumps are generated from production data in the early hours each day, and are then downloaded from integration.

If you have integration access, you can download and import the latest data by running:

```
./replicate-data-local.sh -u $USERNAME -F ../ssh_config
```

If you don't have integration access, ask someone to give you a copy of their dump. Then, from this directory, run:

```
./replicate-data-local.sh -d path/to/dir -s
```

For more information, see the guide in the developer docs on [replicating application data locally for development](https://docs.publishing.service.gov.uk/manual/replicate-app-data-locally.html).

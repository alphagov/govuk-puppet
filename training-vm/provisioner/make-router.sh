#!/bin/bash

# Move `router` to $GOPATH
org_path="/var/govuk/gopath/src/github.com/alphagov"
mkdir -p $org_path
mv /var/govuk/router $org_path
ln -s "$org_path/router" /var/govuk/router

# Build `router` and `draft-router`
cd "$org_path/router"
GOPATH=/var/govuk/gopath make
GOPATH=/var/govuk/gopath BINARY=draft-router make

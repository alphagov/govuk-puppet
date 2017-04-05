#!/bin/bash

# Ensure that the source of a Go app is within the $GOPATH workspace, and then
# run it.

app_name=$1
gopath_dir=$(basename $GOPATH)
org_path="$gopath_dir/src/github.com/alphagov"
repo_path="$org_path/$app_name"

if [ -d "../../$app_name" ] && [ ! -d "../../$repo_path" ]; then
  (
    cd ../..
    mkdir -p "$org_path"
    mv "$app_name" "$org_path"
    ln -s "$repo_path" "$app_name"

    full_path="$GOPATH/src/github.com/alphagov/$app_name"
    echo "Note: $app_name has been moved to $full_path"
    echo "Go apps need to be built from within the \$GOPATH ($GOPATH)"
    echo "A symlink has been created from the original location ($(pwd)/$app_name)"
  )
fi

shift
./run_in.sh "../../$repo_path" "$@"

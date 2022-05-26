#!/bin/sh

VERSION=$1

if [ "$VERSION" == "" ]
then
    echo "Usage: s3-upload.sh VERSION"
    echo
    echo "Upload VERSION sdist to s3. Must run `python setup.py sdist` first."
    exit 1
fi

file_tmpl="amazon-dax-client-XYZ.tar.gz"
version_file="${file_tmpl/XYZ/$VERSION}"
latest_file="${file_tmpl/XYZ/latest}"

if [ -e "dist/$version_file" ]
then
    aws s3 cp "dist/$version_file" s3://dax-sdk/python/$version_file
    aws s3 cp "dist/$version_file" s3://dax-sdk/python/$latest_file
else
    echo "Could not find 'dist/$version_file'. Did you run 'python setup.py sdist'?".
    exit 1
fi


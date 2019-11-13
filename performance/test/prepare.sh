#!/bin/sh

# Create 1GB file to be compressed and decompressed.
dd if=/dev/urandom of=1gb bs=1M count=1024
gzip -d db.sq.gz

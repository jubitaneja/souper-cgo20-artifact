#!/bin/bash

echo "Processing range results ..."

for i in range/range_* ; do cat ${i} >> range-raw ; done
python range.py range-raw

echo "------ Range analysis done! -------"

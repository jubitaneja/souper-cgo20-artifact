#!/bin/bash

BZIP2_DIR=/usr/src/artifact-cgo/performance/test/bzip2
BASELINE_BZIP2=$BZIP2_DIR/baseline
PRECISE_BZIP2=$BZIP2_DIR/precise

RESULT_DIR=/usr/src/artifact-cgo/performance/test/

for i in {1..3}; do
	echo "Iteration #$i: computing baseline compression time";
	echo "baseline-compression time" >> $RESULT_DIR/result-bzip.txt;
	(time -p $BASELINE_BZIP2/bzip2 -k -f $RESULT_DIR/1gb) 2>> $RESULT_DIR/result-bzip.txt;
	echo
	echo "Iteration #$i: computing precise compression time";
	echo "precise-compression time" >> $RESULT_DIR/result-bzip.txt;
	(time -p $PRECISE_BZIP2/bzip2 -k -f $RESULT_DIR/1gb) 2>> $RESULT_DIR/result-bzip.txt;
	echo
	echo
	echo "Iteration #$i: computing baseline decompression time";
	echo "baseline-decompression time" >> $RESULT_DIR/result-bzip.txt;
	(time -p $BASELINE_BZIP2/bzip2 -k -d -f $RESULT_DIR/1gb.bz2) 2>> $RESULT_DIR/result-bzip.txt;
	echo
	echo "Iteration #$i: computing precise compression time";
	echo "precise-decompression time" >> $RESULT_DIR/result-bzip.txt;
	(time -p $PRECISE_BZIP2/bzip2 -k -d -f $RESULT_DIR/1gb.bz2) 2>> $RESULT_DIR/result-bzip.txt;
	echo
	echo
done

echo
echo "The results are saved in result-bzip.txt file"
echo

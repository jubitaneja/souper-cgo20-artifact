#!/bin/sh

BZIP2_DIR=/usr/src/artifact-cgo/performance/test/bzip2
BASELINE_BZIP2=$BZIP2_DIR/baseline
PRECISE_BZIP2=$BZIP2_DIR/precise

RESULT_DIR=/usr/src/artifact-cgo/performance/test/

for i in 0 .. 3; do
	echo "baseline-compression time" >> $RESULT_DIR/result-bzip.txt;
	(time -p $BASELINE_BZIP2/bzip2 -k -f $RESULT_DIR/1gb) 2>> $RESULT_DIR/result-bzip.txt;
	echo
	echo "precise-compression time" >> $RESULT_DIR/result-bzip.txt;
	(time -p $PRECISE_BZIP2/bzip2 -k -f $RESULT_DIR/1gb) 2>> $RESULT_DIR/result-bzip.txt;
	echo
	echo
	echo "baseline-decompression time" >> $RESULT_DIR/result-bzip.txt;
	(time -p $BASELINE_BZIP2/bzip2 -k -d -f $RESULT_DIR/1gb.bz2) 2>> $RESULT_DIR/result-bzip.txt;
	echo
	echo "precise-decompression time" >> $RESULT_DIR/result-bzip.txt;
	(time -p $PRECISE_BZIP2/bzip2 -k -d -f $RESULT_DIR/1gb.bz2) 2>> $RESULT_DIR/result-bzip.txt;
	echo
	echo
done

echo
echo

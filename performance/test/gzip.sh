#!/bin/sh

GZIP_DIR=/usr/src/artifact-cgo/performance/test/gzip
BASELINE_GZIP=$GZIP_DIR/baseline
PRECISE_GZIP=$GZIP_DIR/precise

RESULT_DIR=/usr/src/artifact-cgo/performance/test/

for i in {1..3}; do
    echo "Iteration #$i: computing baseline compression time"
	echo "baseline-compression time" >> $RESULT_DIR/result-gzip.txt;
	(time -p $BASELINE_GZIP/gzip -k -f ${RESULT_DIR}/1gb) 2>> $RESULT_DIR/result-gzip.txt;
	echo
    echo "Iteration #$i: computing precise compression time"
	echo "precise-compression time" >> $RESULT_DIR/result-gzip.txt;
	(time -p $PRECISE_GZIP/gzip -k -f ${RESULT_DIR}/1gb) 2>> $RESULT_DIR/result-gzip.txt;
	echo
	echo
    echo "Iteration #$i: computing baseline decompression time"
	echo "baseline-decompression time" >> $RESULT_DIR/result-gzip.txt;
	(time -p $BASELINE_GZIP/gzip -k -d -f ${RESULT_DIR}/1gb.gz) 2>> $RESULT_DIR/result-gzip.txt;
	echo
    echo "Iteration #$i: computing precise decompression time"
	echo "precise-decompression time" >> $RESULT_DIR/result-gzip.txt;
	(time -p $PRECISE_GZIP/gzip -k -d -f ${RESULT_DIR}/1gb.gz) 2>> $RESULT_DIR/result-gzip.txt;
	echo
	echo
done

echo
echo "The results are saved in result-gzip.txt file"
echo

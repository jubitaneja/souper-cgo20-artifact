#!/bin/bash

SQLITE_DIR=/usr/src/artifact-cgo/performance/test/sqlite
BASELINE_SQLITE=$SQLITE_DIR/baseline
PRECISE_SQLITE=$SQLITE_DIR/precise

RESULT_DIR=/usr/src/artifact-cgo/performance/test/

for i in {1..3}; do
    echo "Iteration #$i: Baseline SQLite run"
	echo "baseline" >> ${RESULT_DIR}/result-sqlite.txt;
	cat ${RESULT_DIR}/test4.sql | (time -p ${BASELINE_SQLITE}/sqlite3-baseline db.sq > /dev/null) 2>> ${RESULT_DIR}/result-sqlite.txt
	echo
	echo
    echo "Iteration #$i: Precise SQLite run"
	echo "precise" >> ${RESULT_DIR}/result-sqlite.txt;
	cat ${RESULT_DIR}/test4.sql | (time -p ${PRECISE_SQLITE}/sqlite3-soupered db.sq > /dev/null) 2>> ${RESULT_DIR}/result-sqlite.txt
	echo
	echo
done

echo
echo "The results are saved in result-sqlite.txt file."
echo

#!/bin/bash

RESULT_DIR=/usr/src/artifact-cgo/performance/test/

echo "============================";
echo "   Performance Evaluation   ";
echo "============================";
echo

echo "Preparing file ..."
${RESULT_DIR}/prepare.sh
echo "Created a file: 1gb"
echo

echo "***************************"; 
echo "Testing #1: bzip2";
echo "***************************"; 
echo

${RESULT_DIR}/bzip2.sh

# compute avg time for bzip compression, decompression

echo "Preparing file ..."
${RESULT_DIR}/prepare.sh
echo "Created a file: 1gb"
echo

echo "***************************"; 
echo "Testing #2: gzip";
echo "***************************"; 
echo

${RESULT_DIR}/gzip.sh

# compute avg time

echo "***************************"; 
echo "Testing #3: Sqlite";
echo "***************************"; 
echo

${RESULT_DIR}/sqlite.sh

echo "***************************"; 
echo "Testing #4: stockfish";
echo "***************************"; 
echo

${RESULT_DIR}/stockfish.sh

echo
echo
echo "All results are saved in individual result
files."
echo
ls result-*.txt
echo
echo "Now, we will quickly get the final numbers to compare performance of baseline with precise version."
echo
echo "==================================="; 
echo "Final result of bzip2";
echo "==================================="; 
echo
python time-zip.py result-bzip*.txt
echo

echo "==================================="; 
echo "Final result of gzip";
echo "==================================="; 
echo
python time-zip.py result-gzip.txt
echo

echo "==================================="; 
echo "Final result of SQLite";
echo "==================================="; 
echo
python time-sqlite.py result-sqlite.txt
echo

echo "==================================="; 
echo "Final result of Stockfish";
echo "==================================="; 
echo
python time-stockfish.py result-stockfish.txt
echo

echo "Performance evaluation is all done!!!"

#!/bin/sh

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


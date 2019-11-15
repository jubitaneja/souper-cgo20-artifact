#!/bin/sh

STOCKFISH_DIR=/usr/src/artifact-cgo/performance/test/stockfish
BASELINE_STOCKFISH=$STOCKFISH_DIR/baseline/src
PRECISE_STOCKFISH=$STOCKFISH_DIR/precise/src

RESULT_DIR=/usr/src/artifact-cgo/performance/test/

for i in {1..3}; do
    echo "Iteration #$i: Baseline stockfish run"
	echo "baseline" >> ${RESULT_DIR}/result-stockfish.txt;
	(time $BASELINE_STOCKFISH/stockfish bench 1024 1 26) 2>> $RESULT_DIR/result-stockfish.txt;
	echo
	echo
    echo "Iteration #$i: Precise stockfish run"
	echo "precise" >> ${RESULT_DIR}/result-stockfish.txt;
	(time $PRECISE_STOCKFISH/stockfish bench 1024 1 26) 2>> $RESULT_DIR/result-stockfish.txt;
	echo
	echo
done

echo
echo "The results are saved in result-stockfish.txt file."
echo

#!/bin/bash

# We assume the following paths are set:
# export CGO_HOME=$(pwd)/artifact-cgo
# cd ${CGO_HOME}

echo "Processing known bits results ..."

echo "Souper is stronger = "
grep -r "souper is stronger" known/knownbits_* | wc -l

echo "LLVM is stronger = "
grep -r "llvm is stronger" known/knownbits_* | wc -l

echo "Solver timeouts = "
grep -r "timeout: Souper" known/knownbits_* | wc -l

echo "---------- Known bits analysis done! -------"

#####################

echo "Processing negative DFA results ..."

echo "Souper is stronger = "
grep -r "souper is stronger" neg/neg_* | wc -l

echo "LLVM is stronger = "
grep -r "llvm is stronger" neg/neg_* | wc -l

echo "Solver timeouts = "
grep -r "timeout: Souper" neg/neg_* | wc -l

echo "---------- Negative analysis done! -------"

#####################

echo "Processing non-negative DFA results ..."

echo "Souper is stronger = "
grep -r "souper is stronger" non-neg/nonneg_* | wc -l

echo "LLVM is stronger = "
grep -r "llvm is stronger" non-neg/nonneg_* | wc -l

echo "Solver timeouts = "
grep -r "timeout: Souper" non-neg/nonneg_* | wc -l

echo "---------- Non-Negative analysis done! -------"

#####################

echo "Processing non-negative DFA results ..."

echo "Souper is stronger = "
grep -r "souper is stronger" non-zero/nonzero_* | wc -l

echo "LLVM is stronger = "
grep -r "llvm is stronger" non-zero/nonzero_* | wc -l

echo "Solver timeouts = "
grep -r "timeout: Souper" non-zero/nonzero_* | wc -l

echo "---------- Non-zero analysis done! -------"

#####################

echo "Processing sign bits DFA results ..."

echo "Souper is stronger = "
grep -r "souper is stronger" signbits/signbits_* | wc -l

echo "LLVM is stronger = "
grep -r "llvm is stronger" signbits/signbits_* | wc -l

echo "Solver timeouts = "
grep -r "timeout: Souper" signbits/signbits_* | wc -l

echo "---------- sign bits analysis done! -------"

#####################

echo "Processing power of two DFA results ..."

echo "Souper is stronger = "
grep -r "souper is stronger" power/power_* | wc -l

echo "LLVM is stronger = "
grep -r "llvm is stronger" power/power_* | wc -l

echo "Solver timeouts = "
grep -r "timeout: Souper" power/power_* | wc -l

echo "---------- power two analysis done! -------"

#####################

sh section-4.1/extra-scripts/process-range.sh

sh section-4.1/extra-scripts/process-demanded-bits.sh


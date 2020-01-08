#!/bin/bash

echo "Processing demanded bits results ..."

for i in db/demanded* ; do cat ${i} >> demanded-raw ; done
sed -i '' 's/var_/%/g' demanded-raw
python demanded.py drmaned-raw demandedbits-final-result.txt

echo "Souper is stronger = "
grep -r "Souper is stronger" demandedbits-final-result.txt | wc -l

echo "LLVM is stronger = "
grep -r "LLVM is stronger" demandedbits-final-result.txt | wc -l

echo "Same precision = "
grep -r "Same precision" demandedbits-final-result.txt | wc -l

echo "Solver timeouts = "
grep -r "Error: Souper timeout" demandedbits-final-result.txt | wc -l

echo "---------- Demanded bits analysis done! -------"

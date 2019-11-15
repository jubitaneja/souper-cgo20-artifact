SOUPER_PREC=/usr/src/artifact-cgo/precision
SOUPER_BUILD=$SOUPER_PREC/souper-build
SOUPER=$SOUPER_BUILD/souper
SOUPER_CHECK=$SOUPER_BUILD/souper-check
SOUPER2LLVM=$SOUPER_BUILD/souper2llvm-precision-test
SOUPER2LLVM_DB=$SOUPER_BUILD/souper2llvm-db

LLVM_BUILD=$SOUPER_PREC/souper/third_party/llvm/Release/bin
LLVM_AS=$LLVM_BUILD/llvm-as

KB_TEST_CASES=$SOUPER_PREC/test/section-4.2
SOUPER_KB_ARGS="-infer-known-bits"
LLVM_KB_ARG="-print-known-at-return"

POWER_TEST_CASES=$SOUPER_PREC/test/section-4.3
SOUPER_POWER_ARGS="-infer-power-two"
LLVM_POWER_ARG="-print-power-two-at-return"

DEMANDED_TEST_CASES=$SOUPER_PREC/test/section-4.4
SOUPER_DEMANDED_ARGS="-infer-demanded-bits"
LLVM_DEMANDED_ARG="-print-demanded-bits-from-harvester"

RANGE_TEST_CASES=$SOUPER_PREC/test/section-4.5
SOUPER_RANGE_ARGS="-infer-range -souper-range-max-precise "
LLVM_RANGE_ARG="-print-range-at-return -souper-range-max-tries=300"


echo "===========================================";
echo " Evaluation: (Known bits) Section 4.2 ";
echo "===========================================";

for i in `ls $KB_TEST_CASES/known*.opt`; do
    echo "-------------------------------";
    echo " Test: $i ";
    echo "-------------------------------";
    cat "$i";
    $SOUPER_CHECK $SOUPER_SOLVER $SOUPER_KB_ARGS $i;
    $SOUPER2LLVM < $i | $LLVM_AS | $SOUPER $SOUPER_SOLVER $LLVM_KB_ARG;
    echo;
    echo;
done

echo "===========================================";
echo " Evaluation: (Power of two) Section 4.3 ";
echo "===========================================";

for i in `ls $POWER_TEST_CASES/power*.opt`; do
    echo "-------------------------------";
    echo " Test: $i ";
    echo "-------------------------------";
    cat "$i";
    $SOUPER_CHECK $SOUPER_SOLVER $SOUPER_POWER_ARGS $i;
    $SOUPER2LLVM < $i | $LLVM_AS | $SOUPER $SOUPER_SOLVER $LLVM_POWER_ARG;
    echo;
    echo;
done

echo "===========================================";
echo " Evaluation: (Demanded bits) Section 4.4 ";
echo "===========================================";

for i in `ls $DEMANDED_TEST_CASES/demanded*.opt`; do
    echo "-------------------------------";
    echo " Test: $i ";
    echo "-------------------------------";
    cat "$i";
    $SOUPER_CHECK $SOUPER_SOLVER $SOUPER_DEMANDED_ARGS $i;
    $SOUPER2LLVM_DB < $i | $LLVM_AS | $SOUPER $SOUPER_SOLVER $LLVM_DEMANDED_ARG;
    echo;
    echo;
done

echo "===========================================";
echo " Evaluation: (Range) Section 4.5 ";
echo "===========================================";

for i in `ls $RANGE_TEST_CASES/range*.opt`; do
    echo "-------------------------------";
    echo " Test: $i ";
    echo "-------------------------------";
    cat "$i";
    $SOUPER_CHECK $SOUPER_SOLVER $SOUPER_RANGE_ARGS $i;
    $SOUPER2LLVM < $i | $LLVM_AS | $SOUPER $SOUPER_SOLVER $LLVM_RANGE_ARG;
    echo;
    echo;
done

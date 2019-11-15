SOUPER_SOUND=/usr/src/artifact-cgo/soundness
SOUPER_BUILD=$SOUPER_SOUND/souper/build
SOUPER=$SOUPER_BUILD/souper
SOUPER_CHECK=$SOUPER_BUILD/souper-check
SOUPER2LLVM=$SOUPER_BUILD/souper2llvm-precision-test

LLVM_BUILD=$SOUPER_SOUND/souper/third_party/llvm/Release/bin
LLVM_AS=$LLVM_BUILD/llvm-as

TEST_CASE=$SOUPER_SOUND/test/section-4.7

echo "===========================================";
echo " Evaluation: (Soundness bugs) Section 4.7 ";
echo "===========================================";

echo
echo
echo "----------------------------------------------------------"
echo "Testing Soundness Bug #1 in non-zero dataflow analysis";
echo "----------------------------------------------------------"
echo

cat $TEST_CASE/sound1.opt
echo
$SOUPER_CHECK $SOUPER_SOLVER -infer-non-zero $TEST_CASE/sound1.opt
echo
$SOUPER2LLVM < $TEST_CASE/sound1.opt | $LLVM_AS | $SOUPER $SOUPER_SOLVER -print-non-zero-at-return
echo
echo


echo "----------------------------------------------------------"
echo "Testing Soundness Bug #2 in sign bits dataflow analysis";
echo "----------------------------------------------------------"
echo

cat $TEST_CASE/sound2.opt
echo
$SOUPER_CHECK $SOUPER_SOLVER -infer-sign-bits $TEST_CASE/sound2.opt
echo
$SOUPER2LLVM < $TEST_CASE/sound2.opt | $LLVM_AS | $SOUPER $SOUPER_SOLVER -print-sign-bits-at-return
echo
echo


echo "----------------------------------------------------------"
echo "Testing Soundness Bug #3 in known bits dataflow analysis";
echo "----------------------------------------------------------"
echo

cat $TEST_CASE/sound3.opt
echo
$SOUPER_CHECK $SOUPER_SOLVER -infer-known-bits $TEST_CASE/sound3.opt
echo
$SOUPER2LLVM < $TEST_CASE/sound3.opt | $LLVM_AS | $SOUPER $SOUPER_SOLVER -print-known-at-return
echo
echo

echo "********************************************"
echo "NOTE for reviewers: You will notice that dataflow facts computed by
LLVM compiler are more precise than computed by our tool, Souper. That's
where we detect unsoundness in LLVM's analysis with these examples."

echo "Soundness Testing is all done !!!"
echo "********************************************"
echo

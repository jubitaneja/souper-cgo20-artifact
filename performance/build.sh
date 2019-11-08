#!/bin/bash
# dependencies: subversion cmake ninja-build re2c

mkdir using-souper-as-lib
cd using-souper-as-lib

# Building Souper

git clone git@github.com:zhengyangl/souper
cd souper && git checkout cgo #hack-llvm2
./build_deps.sh

mkdir build
cd build

export SOUPER_BUILD=`pwd` # it seems cmake only accepts abs path

cmake .. -G Ninja 
ninja 

cd ../..


# Building LLVM
git clone git@github.com:zhengyangl/llvm-with-calls-to-souper.git
cd llvm-with-calls-to-souper && git checkout cgo
cd ..
mkdir build
cd build 



cmake ../llvm-with-calls-to-souper -G Ninja -DLLVM_FORCE_ENABLE_STATS=On -DCMAKE_BUILD_TYPE=Release -DSOUPER_INCLUDE="$SOUPER_BUILD/../include" -DCLANG_ANALYZER_ENABLE_Z3_SOLVER=Off -DSOUPER_LIBRARIES="$SOUPER_BUILD/libsouperExtractor.a;$SOUPER_BUILD/libsouperInst.a;$SOUPER_BUILD/libkleeExpr.a;$SOUPER_BUILD/libsouperKVStore.a;$SOUPER_BUILD/libsouperInfer.a;$SOUPER_BUILD/libsouperClangTool.a;$SOUPER_BUILD/libsouperSMTLIB2.a;$SOUPER_BUILD/libsouperParser.a;$SOUPER_BUILD/libsouperTool.a;$SOUPER_BUILD/../third_party/alive2/build/libalive2.so;$SOUPER_BUILD/../third_party/hiredis/install/lib/libhiredis.a" 


ninja

cd ..
git clone git@github.com:zhengyangl/llvm-with-calls-to-souper.git llvm-baseline
cd llvm-baseline
git checkout baseline
cd ..

mkdir build-baseline
cd build-baseline

cmake ../llvm-baseline -G Ninja -DLLVM_FORCE_ENABLE_STATS=On -DCLANG_ANALYZER_ENABLE_Z3_SOLVER=Off -DCMAKE_BUILD_TYPE=Release

ninja

cd ..


# make CC=/home/liuz/jubi/using-souper-as-lib/build/bin/clang CFLAGS="-mllvm -stats -Wall -Winline -O2 -g -D_FILE_OFFSET_BITS=64" 2> stat

# make CC=/home/liuz/jubi/using-souper-as-lib/build-baseline/bin/clang CFLAGS="-mllvm -stats -Wall -Winline -O2 -g -D_FILE_OFFSET_BITS=64" 2> stat



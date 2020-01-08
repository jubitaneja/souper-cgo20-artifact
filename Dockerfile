from ubuntu:18.04

run set -x; \
        apt-get update -qq \
        && apt-get dist-upgrade -qq \
        && apt-get autoremove -qq \
        && apt-get remove -y -qq clang llvm llvm-runtime \
	&& apt-get install libgmp10 \
	&& echo 'ca-certificates vim libc6-dev libgmp-dev cmake time patch ninja-build make autoconf automake libtool golang-go python subversion re2c git gcc g++ libredis-perl' > /usr/src/build-deps \
	&& apt-get install -y $(cat /usr/src/build-deps) --no-install-recommends \
	&& git clone https://github.com/antirez/redis /usr/src/redis

run export CC=cc CXX=c++ \
        && cd /usr/src/redis \
	&& git checkout 5.0.3 \
	&& make -j10 \
	&& make install

run export GOPATH=/usr/src/go \
	&& go get github.com/gomodule/redigo/redis

add precision/souper/build_deps.sh /usr/src/artifact-cgo/precision/souper/build_deps.sh
add precision/souper/patches /usr/src/artifact-cgo/precision/souper/patches
run export CC=cc CXX=c++ \
	&& cd /usr/src/artifact-cgo/precision/souper \
	&& ./build_deps.sh Release \
        && rm -rf third_party/llvm/Release-build \
	&& rm -rf third_party/hiredis/install/lib/libhiredis.so*

add precision/souper/clone_and_test.sh /usr/src/artifact-cgo/precision/souper/clone_and_test.sh
add precision/souper/CMakeLists.txt /usr/src/artifact-cgo/precision/souper/CMakeLists.txt
add precision/souper/docs /usr/src/artifact-cgo/precision/souper/docs
add precision/souper/include /usr/src/artifact-cgo/precision/souper/include
add precision/souper/lib /usr/src/artifact-cgo/precision/souper/lib
add precision/souper/test /usr/src/artifact-cgo/precision/souper/test
add precision/souper/tools /usr/src/artifact-cgo/precision/souper/tools
add precision/souper/utils /usr/src/artifact-cgo/precision/souper/utils
add precision/souper/runtime /usr/src/artifact-cgo/precision/souper/runtime
add precision/souper/unittests /usr/src/artifact-cgo/precision/souper/unittests
add precision/spec/dump.rdb.gz /usr/src/artifact-cgo/precision/dump.rdb.gz

run service redis-server stop
    && gzip -d -c /usr/src/artifact-cgo/precision/dump.rdb > /var/lib/redis/dump.rdb
    && chown redis: /var/lib/redis/dump.rdb
    && service redis-server start

run export GOPATH=/usr/src/go \
	&& mkdir -p /usr/src/artifact-cgo/precision/souper-build \
	&& cd /usr/src/artifact-cgo/precision/souper-build \
	&& CC=/usr/src/artifact-cgo/precision/souper/third_party/llvm/Release/bin/clang CXX=/usr/src/artifact-cgo/precision/souper/third_party/llvm/Release/bin/clang++ cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DTEST_SYNTHESIS=ON ../souper \
	&& ninja \
	&& ninja check

env SOUPER_SOLVER -z3-path=/usr/src/artifact-cgo/precision/souper/third_party/z3-install/bin/z3

# Performance setup
add performance/souper /usr/src/artifact-cgo/performance/souper

run export CC=cc CXX=c++ \
	&& export GOPATH=/usr/src/go \
	&& cd /usr/src/artifact-cgo/performance/souper \
	&& ./build_deps.sh Release \
	&& rm -rf third_party/llvm/Release-build

run export CC=cc CXX=c++ \
	&& export GOPATH=/usr/src/go \
	&& mkdir -p /usr/src/artifact-cgo/performance/souper/build \
	&& cd /usr/src/artifact-cgo/performance/souper/build \
	&& cmake -DCMAKE_BUILD_TYPE=Release -G Ninja ../ \
	&& ninja

env SOUPER_BUILD /usr/src/artifact-cgo/performance/souper/build

# LLVM-with-calls-to-souper-repo

add performance/llvm-with-calls-to-souper /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper

run export CC=cc CXX=c++ \
	&& export GOPATH=/usr/src/go \
	&& mkdir -p /usr/src/artifact-cgo/performance/llvm-build \
	&& cd /usr/src/artifact-cgo/performance/llvm-build \
	&& cmake ../llvm-with-calls-to-souper -G Ninja -DCMAKE_BUILD_TYPE=Release -DSOUPER_INCLUDE="$SOUPER_BUILD/../include" -DCLANG_ANALYZER_ENABLE_Z3_SOLVER=Off -DSOUPER_LIBRARIES="$SOUPER_BUILD/libsouperExtractor.a;$SOUPER_BUILD/libsouperInst.a;$SOUPER_BUILD/libkleeExpr.a;$SOUPER_BUILD/libsouperKVStore.a;$SOUPER_BUILD/libsouperInfer.a;$SOUPER_BUILD/libsouperClangTool.a;$SOUPER_BUILD/libsouperSMTLIB2.a;$SOUPER_BUILD/libsouperParser.a;$SOUPER_BUILD/libsouperTool.a;$SOUPER_BUILD/../third_party/alive2/build/libalive2.so;$SOUPER_BUILD/../third_party/hiredis/install/lib/libhiredis.a"

run cd /usr/src/artifact-cgo/performance/llvm-build \
	&& ninja

add precision/test /usr/src/artifact-cgo/precision/test
env SOUPER_PREC /usr/src/artifact-cgo/precision
env SOUPER_SOLVER -z3-path=/usr/src/artifact-cgo/precision/souper/third_party/z3-install/bin/z3

add performance/test /usr/src/artifact-cgo/performance/test

# Soundness bugs repro repo.
add soundness/souper /usr/src/artifact-cgo/soundness/souper
add soundness/test /usr/src/artifact-cgo/soundness/test

run export CC=cc CXX=c++ \
	&& export GOPATH=/usr/src/go \
	&& cd /usr/src/artifact-cgo/soundness/souper \
	&& ./build_deps.sh Release \
	&& rm -rf third_party/llvm/Release-build

run export CC=cc CXX=c++ \
	&& export GOPATH=/usr/src/go \
	&& mkdir -p /usr/src/artifact-cgo/soundness/souper/build \
	&& cd /usr/src/artifact-cgo/soundness/souper/build \
	&& cmake -DCMAKE_BUILD_TYPE=Release -G Ninja ../ \
	&& ninja



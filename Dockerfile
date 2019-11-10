from ubuntu:18.04

run set -x; \
        apt-get update -qq \
        && apt-get dist-upgrade -qq \
        && apt-get autoremove -qq \
        && apt-get remove -y -qq clang llvm llvm-runtime \
	&& apt-get install libgmp10 \
	&& echo 'ca-certificates valgrind libc6-dev libgmp-dev cmake patch ninja-build make autoconf automake libtool golang-go python subversion re2c git clang libredis-perl' > /usr/src/build-deps \
	&& apt-get install -y $(cat /usr/src/build-deps) --no-install-recommends \
	&& git clone https://github.com/antirez/redis /usr/src/redis
#	&& git clone https://github.com/Z3Prover/z3.git /usr/src/z3

run export CC=clang CXX=clang++ \
        && cd /usr/src/redis \
	&& git checkout 5.0.3 \
	&& make -j10 \
	&& make install

run export GOPATH=/usr/src/go \
	&& go get github.com/gomodule/redigo/redis

add precision/souper/build_deps.sh /usr/src/artifact-cgo/precision/souper/build_deps.sh
add precision/souper/clone_and_test.sh /usr/src/artifact-cgo/precision/souper/clone_and_test.sh
add precision/souper/patches /usr/src/artifact-cgo/precision/souper/patches

run export CC=clang CXX=clang++ \
	&& cd /usr/src/artifact-cgo/precision/souper \
#	&& ./build_deps.sh Debug \
#       && rm -rf third_party/llvm/Debug-build \
	&& ./build_deps.sh Release \
        && rm -rf third_party/llvm/Release-build \
	&& rm -rf third_party/hiredis/install/lib/libhiredis.so*

add precision/souper/CMakeLists.txt /usr/src/artifact-cgo/precision/souper/CMakeLists.txt
add precision/souper/docs /usr/src/artifact-cgo/precision/souper/docs
add precision/souper/include /usr/src/artifact-cgo/precision/souper/include
add precision/souper/lib /usr/src/artifact-cgo/precision/souper/lib
add precision/souper/test /usr/src/artifact-cgo/precision/souper/test
add precision/souper/tools /usr/src/artifact-cgo/precision/souper/tools
add precision/souper/utils /usr/src/artifact-cgo/precision/souper/utils
add precision/souper/runtime /usr/src/artifact-cgo/precision/souper/runtime
add precision/souper/unittests /usr/src/artifact-cgo/precision/souper/unittests

run export GOPATH=/usr/src/go \
	&& mkdir -p /usr/src/artifact-cgo/precision/souper-build \
	&& cd /usr/src/artifact-cgo/precision/souper-build \
	&& CC=/usr/src/artifact-cgo/precision/souper/third_party/llvm/Release/bin/clang CXX=/usr/src/artifact-cgo/precision/souper/third_party/llvm/Release/bin/clang++ cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DTEST_SYNTHESIS=ON ../souper \
    && ninja \
#	&& ninja souperweb souperweb-backend \
    && ninja check
#	&& cp souperweb souperweb-backend /usr/local/bin \
#        && cd .. \
#        && rm -rf /usr/src/artifact-cgo/souper-build \
#	&& strip /usr/local/bin/* \
#	&& groupadd -r souper \
#	&& useradd -m -r -g souper souper \
#	&& mkdir /data \
#	&& chown souper:souper /data \
#	&& rm -rf /usr/local/include /usr/local/lib/*.a /usr/local/lib/*.la

env SOUPER_SOLVER -z3-path=/usr/src/artifact-cgo/precision/souper/third_party/z3-install/bin/z3

# Performance setup
add performance/souper/build_deps.sh /usr/src/artifact-cgo/performance/souper/build_deps.sh
add performance/souper/clone_and_test.sh /usr/src/artifact-cgo/performance/souper/clone_and_test.sh
add performance/souper/patches /usr/src/artifact-cgo/performance/souper/patches

run export CC=clang CXX=clang++ \
	&& cd /usr/src/artifact-cgo/performance/souper \
	&& ./build_deps.sh Release \
        && rm -rf third_party/llvm/Release-build

add performance/souper/CMakeLists.txt /usr/src/artifact-cgo/performance/souper/CMakeLists.txt
add performance/souper/docs /usr/src/artifact-cgo/performance/souper/docs
add performance/souper/include /usr/src/artifact-cgo/performance/souper/include
add performance/souper/lib /usr/src/artifact-cgo/performance/souper/lib
add performance/souper/test /usr/src/artifact-cgo/performance/souper/test
add performance/souper/tools /usr/src/artifact-cgo/performance/souper/tools
add performance/souper/utils /usr/src/artifact-cgo/performance/souper/utils
add performance/souper/runtime /usr/src/artifact-cgo/performance/souper/runtime
add performance/souper/unittests /usr/src/artifact-cgo/performance/souper/unittests

run export GOPATH=/usr/src/go \
	&& mkdir -p /usr/src/artifact-cgo/performance/souper/build \
	&& export CC=/usr/src/artifact-cgo/performance/souper/third_party/llvm/Release/bin/clang CXX=/usr/src/artifact-cgo/performance/souper/third_party/llvm/Release/bin/clang++ \
	&& cd /usr/src/artifact-cgo/performance/souper/build \
	&& cmake -DCMAKE_BUILD_TYPE=Release -G Ninja ../ \
	&& ninja

env SOUPER_BUILD /usr/src/artifact-cgo/performance/souper/build

# LLVM-with0calls-to-souper-repo

add performance/llvm-with-calls-to-souper/benchmarks /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper/benchmarks
add performance/llvm-with-calls-to-souper/bindings /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper/bindings
add performance/llvm-with-calls-to-souper/cmake /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper/cmake
add performance/llvm-with-calls-to-souper/CMakeLists.txt /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper/CMakeLists.txt
add performance/llvm-with-calls-to-souper/configure /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper/configure
add performance/llvm-with-calls-to-souper/docs /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper/docs
add performance/llvm-with-calls-to-souper/examples /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper/examples
add performance/llvm-with-calls-to-souper/include /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper/include
add performance/llvm-with-calls-to-souper/lib /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper/lib
add performance/llvm-with-calls-to-souper/LICENSE.TXT /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper/LICENSE.TXT
add performance/llvm-with-calls-to-souper/LLVMBuild.txt /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper/LLVMBuild.txt
add performance/llvm-with-calls-to-souper/llvm.spec.in /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper/llvm.spec.in
add performance/llvm-with-calls-to-souper/projects /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper/projects
add performance/llvm-with-calls-to-souper/README.txt /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper/README.txt
add performance/llvm-with-calls-to-souper/RELEASE_TESTERS.TXT /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper/RELEASE_TESTERS.TXT
add performance/llvm-with-calls-to-souper/resources /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper/resources
add performance/llvm-with-calls-to-souper/runtimes /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper/runtimes
add performance/llvm-with-calls-to-souper/test /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper/test
add performance/llvm-with-calls-to-souper/tools /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper/tools
add performance/llvm-with-calls-to-souper/unittests /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper/unittests
add performance/llvm-with-calls-to-souper/utils /usr/src/artifact-cgo/performance/llvm-with-calls-to-souper/utils

run export CC=clang CXX=clang++ \
	&& mkdir -p /usr/src/artifact-cgo/performance/llvm-build \
	&& cd /usr/src/artifact-cgo/performance/llvm-build \
	#&& cmake ../llvm-with-calls-to-souper -G Ninja -DCMAKE_BUILD_TYPE=Release -DSOUPER_INCLUDE="$SOUPER_BUILD/../include" -DCLANG_ANALYZER_ENABLE_Z3_SOLVER=Off -DSOUPER_LIBRARIES="$SOUPER_BUILD/libsouperExtractor.a;$SOUPER_BUILD/libsouperInst.a;$SOUPER_BUILD/libkleeExpr.a;$SOUPER_BUILD/libsouperKVStore.a;$SOUPER_BUILD/libsouperInfer.a;$SOUPER_BUILD/libsouperClangTool.a;$SOUPER_BUILD/libsouperSMTLIB2.a;$SOUPER_BUILD/libsouperParser.a;$SOUPER_BUILD/libsouperTool.a;$SOUPER_BUILD/../third_party/alive2/build/libalive2.so;$SOUPER_BUILD/../third_party/hiredis/install/lib/libhiredis.a"
	&& cmake ../llvm-with-calls-to-souper -G Ninja -DCMAKE_BUILD_TYPE=Release -DSOUPER_INCLUDE="$SOUPER_BUILD/../include" -DCLANG_ANALYZER_ENABLE_Z3_SOLVER=Off -DSOUPER_LIBRARIES="$SOUPER_BUILD/libsouperExtractor.a;$SOUPER_BUILD/libsouperInst.a;$SOUPER_BUILD/libkleeExpr.a;$SOUPER_BUILD/libsouperKVStore.a;$SOUPER_BUILD/libsouperInfer.a;$SOUPER_BUILD/libsouperClangTool.a;$SOUPER_BUILD/libsouperSMTLIB2.a;$SOUPER_BUILD/libsouperParser.a;$SOUPER_BUILD/libsouperTool.a;$SOUPER_BUILD/../third_party/alive2/build/libalive2.so;$SOUPER_BUILD/../third_party/hiredis/install/lib/libhiredis.a"
	#&& ninja

run cd /usr/src/artifact-cgo/performance/llvm-build \
	&& ninja


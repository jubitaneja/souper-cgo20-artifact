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

#run export CC=clang CXX=clang++ \
#        && cd /usr/src/z3 \
#	&& git checkout tags/z3-4.8.6 \
#	&& python scripts/mk_make.py \
#	&& make -j \
#	&& make install

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

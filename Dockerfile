from ubuntu:18.04

run set -x; \
        apt-get update -qq \
        && apt-get dist-upgrade -qq \
        && apt-get autoremove -qq \
        && apt-get remove -y -qq clang llvm llvm-runtime \
	&& apt-get install libgmp10 \
	&& echo 'ca-certificates valgrind libc6-dev libgmp-dev cmake patch ninja-build make autoconf automake libtool golang-go python subversion re2c git clang' > /usr/src/build-deps \
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

add souper/build_deps.sh /usr/src/artifact-cgo/souper/build_deps.sh
add souper/clone_and_test.sh /usr/src/artifact-cgo/souper/clone_and_test.sh
add souper/patches /usr/src/artifact-cgo/souper/patches

run export CC=clang CXX=clang++ \
	&& cd /usr/src/artifact-cgo/souper \
#	&& ./build_deps.sh Debug \
#       && rm -rf third_party/llvm/Debug-build \
	&& ./build_deps.sh Release \
        && rm -rf third_party/llvm/Release-build \
	&& rm -rf third_party/hiredis/install/lib/libhiredis.so*

add souper/CMakeLists.txt /usr/src/artifact-cgo/souper/CMakeLists.txt
add souper/docs /usr/src/artifact-cgo/souper/docs
add souper/include /usr/src/artifact-cgo/souper/include
add souper/lib /usr/src/artifact-cgo/souper/lib
add souper/test /usr/src/artifact-cgo/souper/test
add souper/tools /usr/src/artifact-cgo/souper/tools
add souper/utils /usr/src/artifact-cgo/souper/utils
add souper/runtime /usr/src/artifact-cgo/souper/runtime
add souper/unittests /usr/src/artifact-cgo/souper/unittests

run export GOPATH=/usr/src/go \
	&& mkdir -p /usr/src/artifact-cgo/souper-build \
	&& cd /usr/src/artifact-cgo/souper-build \
	&& CC=/usr/src/artifact-cgo/souper/third_party/llvm/Release/bin/clang CXX=/usr/src/artifact-cgo/souper/third_party/llvm/Release/bin/clang++ cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DTEST_SYNTHESIS=ON ../souper \
	&& ninja souperweb souperweb-backend \
        && ninja check \
	&& cp souperweb souperweb-backend /usr/local/bin \
        && cd .. \
        && rm -rf /usr/src/artifact-cgo/souper-build \
	&& strip /usr/local/bin/* \
	&& groupadd -r souper \
	&& useradd -m -r -g souper souper \
	&& mkdir /data \
	&& chown souper:souper /data \
	&& rm -rf /usr/local/include /usr/local/lib/*.a /usr/local/lib/*.la

## Preparation

Make sure you have already evaluated the script `prepare_req.sh` in `${CGO_HOME}`.

```bash
cd ${CGO_HOME}
./build_souper_performance.sh
export Z3_PATH=${CGO_HOME}/scratch/performance/souper/third_party/z3-install/bin/z3
redis-cli flushdb

mkdir -p ${CGO_HOME}/scratch/performance/test
dd if=/dev/urandom bs=1M count=1024 of=${CGO_HOME}/scratch/performance/test/1gb
wget -O ${CGO_HOME}/scratch/performance/test/db.sq.gz https://github.com/jubitaneja/artifact-cgo/blob/master/section-4.6/db.sq.gz?raw=true
wget -O ${CGO_HOME}/scratch/performance/test/test4.sql https://github.com/jubitaneja/artifact-cgo/blob/master/section-4.6/test4.sql?raw=true
gzip -d -f ${CGO_HOME}/scratch/performance/test/db.sq.gz > ${CGO_HOME}/scratch/performance/test/db.sq

```


## Evaluation: gzip

```bash
mkdir -p ${CGO_HOME}/scratch/performance/test/gzip
cd ${CGO_HOME}/scratch/performance/test/gzip
wget http://ftp.gnu.org/gnu/gzip/gzip-1.10.tar.gz
tar xvf gzip-1.10.tar.gz
cp -r gzip-1.10 baseline
mv gzip-1.10 precise

# build gzip with our algorithm
# estimated build time: 2-3 hours
cd ${CGO_HOME}/scratch/performance/test/gzip/precise
./configure CC=${CGO_HOME}/scratch/performance/build-baseline/bin/clang
time make CC=${CGO_HOME}/scratch/performance/build/bin/clang CFLAGS="-O3 -mllvm -z3-path=${Z3_PATH}"

# build baseline
cd ${CGO_HOME}/scratch/performance/test/gzip/baseline
./configure CC=${CGO_HOME}/scratch/performance/build-baseline/bin/clang
time make CC=${CGO_HOME}/scratch/performance/build-baseline/bin/clang CFLAGS="-O3"

# measure execution time
for i in {1..3}; do time ${CGO_HOME}/scratch/performance/test/gzip/precise/gzip -f -k
    ${CGO_HOME}/scratch/performance/test/1gb ; done
for i in {1..3}; do time ${CGO_HOME}/scratch/performance/test/gzip/baseline/gzip -f -k
    ${CGO_HOME}/scratch/performance/test/1gb ; done

```

## Evaluation: bzip2
```bash
mkdir -p ${CGO_HOME}/scratch/performance/test/bz2
cd ${CGO_HOME}/scratch/performance/test/bz2
wget https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz
tar xvf bzip2-1.0.8.tar.gz
cp -r bzip2-1.0.8 baseline
mv bzip2-1.0.8 precise

# build bzip2 with our algorithm
# estimated build time: 2 hours
cd ${CGO_HOME}/scratch/performance/test/bz2/precise
time make CC=${CGO_HOME}/scratch/performance/build/bin/clang CFLAGS="-Wall -Winline -O3 -g -D_FILE_OFFSET_BITS=64 -mllvm -z3-path=${Z3_PATH}"

# build baseline
cd ${CGO_HOME}/scratch/performance/test/bz2/baseline
time make CC=${CGO_HOME}/scratch/performance/build-baseline/bin/clang CFLAGS="-Wall -Winline -O3 -g -D_FILE_OFFSET_BITS=64"

# measure execution time
for i in {1..3}; do time ${CGO_HOME}/scratch/performance/test/bz2/precise/bzip2 -f -k
    ${CGO_HOME}/scratch/performance/test/1gb ; done
for i in {1..3}; do time ${CGO_HOME}/scratch/performance/test/bz2/baseline/bzip2 -f -k
    ${CGO_HOME}/scratch/performance/test/1gb ; done
```

# Evaluation: stockfish
```bash
mkdir -p ${CGO_HOME}/scratch/performance/test/stockfish/precise
mkdir -p ${CGO_HOME}/scratch/performance/test/stockfish/baseline

cd ${CGO_HOME}/scratch/performance/test/stockfish
wget https://stockfishchess.org/files/stockfish-10-src.zip
cp stockfish-10-src.zip precise
cp stockfish-10-src.zip baseline
cd ${CGO_HOME}/scratch/performance/test/stockfish/precise && unzip stockfish-10-src.zip
cd ${CGO_HOME}/scratch/performance/test/stockfish/baseline && unzip stockfish-10-src.zip

# build stockfish with our algorithm
# estimated build time: 24 hours
cd ${CGO_HOME}/scratch/performance/test/stockfish/precise/src
time make build ARCH=x86-64-modern COMPCXX=${CGO_HOME}/scratch/performance/build/bin/clang++ CXXFLAGS="-Wall -Wcast-qual -fno-exceptions -std=c++11  -pedantic -Wextra -Wshadow -m64 -DNDEBUG -O3 -DIS_64BIT -msse -msse3 -mpopcnt -DUSE_POPCNT -flto -mllvm -z3-path=${Z3_PATH}"

# build baseline
cd ${CGO_HOME}/scratch/performance/test/stockfish/baseline/src
time make build ARCH=x86-64-modern COMPCXX=${CGO_HOME}/scratch/performance/build-baseline/bin/clang++ CXXFLAGS="-Wall -Wcast-qual -fno-exceptions -std=c++11  -pedantic -Wextra -Wshadow -m64 -DNDEBUG -O3 -DIS_64BIT -msse -msse3 -mpopcnt -DUSE_POPCNT"

# measure execution time
for i in {1..3}; do time ${CGO_HOME}/scratch/performance/test/stockfish/precise/src/stockfish bench 1024 1 26 >/dev/null ; done
for i in {1..3}; do time ${CGO_HOME}/scratch/performance/test/stockfish/baseline/src/stockfish bench 1024 1 26 >/dev/null ; done
```

# Evaluation: sqlite3
```bash

mkdir -p ${CGO_HOME}/scratch/performance/test/sqlite3

cd ${CGO_HOME}/scratch/performance/test/sqlite3
wget https://www.sqlite.org/2019/sqlite-amalgamation-3290000.zip
unzip sqlite-amalgamation-3290000.zip
cp -r sqlite-amalgamation-3290000 baseline
mv sqlite-amalgamation-3290000 precise

# build sqlite3 with our algorithm
# estimated build time: 70 hours
cd ${CGO_HOME}/scratch/performance/test/sqlite3/precise
time ${CGO_HOME}/scratch/performance/build/bin/clang -lpthread -ldl -O3 -o sqlite3 sqlite3.c shell.c -mllvm -z3-path=${Z3_PATH}

# build baseline
cd ${CGO_HOME}/scratch/performance/test/sqlite3/baseline
time ${CGO_HOME}/scratch/performance/build-baseline/bin/clang -lpthread -ldl -O3 -o sqlite3 sqlite3.c shell.c

# measure execution time
for i in {1..3}; do cat ${CGO_HOME}/scratch/performance/test/test4.sql | time ${CGO_HOME}/scratch/performance/test/sqlite3/precise/sqlite3 ${CGO_HOME}/scratch/performance/test/db.sq > /dev/null ; done
for i in {1..3}; do cat ${CGO_HOME}/scratch/performance/test/test4.sql | time ${CGO_HOME}/scratch/performance/test/sqlite3/baseline/sqlite3 ${CGO_HOME}/scratch/performance/test/db.sq > /dev/null ; done
```

**Main Idea:** For the evaluation of Section 4.1, we compile
SPEC CPU 2017 benchmark with Souper. We cache
the Souper expressions in Redis. For each expression
harvested by Souper, we compare the dataflow
facts computed by precise algorithms written by
us against what an LLVM compiler computes.

# Build and Install SPEC CPU 2017

As mentioned earlier that we cannot share the SPEC ISO image directly. We are assuming that you have the SPEC CPU 2017 benchmarks installed in the directory /usr/src/cpu2017.

- Copy `souper-cache.cfg` from https://gist.github.com/zhengyangl/9d6c79beded94584f35292ee00c964e9
..to `$souper_prec/cpu2017/config`

- You can update `sclang` binary path ($souper_prec/souper/build/sclang)
in `$souper_prec/cpu2017/config/souper-cache.cfg`
at [line 191](https://gist.github.com/zhengyangl/9d6c79beded94584f35292ee00c964e9#file-souper-cache-cfg-L191).

# Setup Redis

First, let us make sure there are no keys
in any existing redis. You can check the keyspace by:
```
$ redis-cli dbsize
```
This should return `0`.

If not, you can flush the keys, and shutdown the existing redis. Also, in this case locate a file named `dump.rdb` and delete it.
```
$ redis-cli flushall
$ redis-cli shutdown
$ rm /path/to/dump.rdb
```
If you shutdown the redis-server, invoke it again for this experiment.

# Set Souper environment variables

```
$ export SOUPER_STATIC_PROFILE=1
$ export SOUPER_IGNORE_SOLVER_ERRORS=1
$ export SOUPER_NO_INFER=1
$ export SOUPER_SOLVER="-z3-path=/path/to/z3"
```

# Run SPEC benchmark

In another shell, follow these steps:
```
$ export CGO_HOME=$(pwd)/artifact-cgo
$ export souper_prec=$CGO_HOME/scratch/precision
$ cd $souper_prec/cpu2017
$ . shrc
$ runcpu -D --config=souper-cache --action=build --tune=base intspeed fpspeed
```
After the SPEC build finishes, you can check the redis dbsize to find
out that there should be `269,113` keys. Check by running `redis-cli dbsize`

# Evaluation: Table 1 (Precision Testing of each DFA)

We are now finally ready to test precision of each dataflow fact
evaluated in Table 1.

### Set Memory Limit
We recommend setting memory limit, so that your machine does not hang
by using the entire swap space. The precision testing experiment
consumes a lot of memory. For instance, we set the memory limit to
2GB in our experiments.
```
$ ulimit -Sv 2000000
```
### Set Execution Time
We also limit execution time of `souper-check` and `Z3` in `crontab`
to keep running these experiments at a faster pace.
Insert your user name in the following command.
```
$ crontab -e
*/5 * * * *  killall -u YourUserName -older-than 5m souper-check
*/5 * * * *  killall -u YourUserName -older-than 15m z3
```

### Run Precision Testing Script

When you run each script (recommend, one at a time only),
it generates thousands of small files containing the results
computed by Souper and LLVM. So, for clean usage and
understanding later on, create separate directories and run
scripts in that so that you can always have separate results.

Make sure you set and move to the path:
```
$ export CGO_HOME=$(pwd)/artifact-cgo
$ cd $CGO_HOME
```
- For known bits dataflow fact:
```
$ mkdir $CGO_HOME/known && cd $CGO_HOME/known
$ $souper_prec/souper/build/cache_dfa --knownbits
```
You will see filenames starting with `knownbits_*`
This may take upto 22 hours to finish on a machine
with 16-cores.

- For negative dataflow fact:
```
$ mkdir $CGO_HOME/neg && cd $CGO_HOME/neg
$ $souper_prec/souper/build/cache_dfa --neg
```
Estimated time: 5 hours

- For non-negative dataflow fact:
```
$ mkdir $CGO_HOME/non-neg && cd $CGO_HOME/non-neg
$ $souper_prec/souper/build/cache_dfa --nonneg
```
Estimated time: 9 hours

- For non-zero dataflow fact:
```
$ mkdir $CGO_HOME/non-zero && cd $CGO_HOME/non-zero
$ $souper_prec/souper/build/cache_dfa --nonzero
```
Estimated time: 18 hours

- For power of two dataflow fact:
```
$ mkdir $CGO_HOME/power && cd $CGO_HOME/power
$ $souper_prec/souper/build/cache_dfa --power
```
Estimated time: 5 hours

- For number of sign bits dataflow fact:
```
$ mkdir $CGO_HOME/signbits && cd $CGO_HOME/signbits
$ $souper_prec/souper/build/cache_dfa --signBits
```
Estimated time: 21 hours

- For range dataflow fact:
```
$ mkdir $CGO_HOME/range && cd $CGO_HOME/range
$ $souper_prec/souper/build/cache_range
```
Estimated time: 25 hours

- For demanded bits dataflow fact:
```
$ mkdir $CGO_HOME/db && cd $CGO_HOME/db
$ $souper_prec/souper/build/cache_demandedbits
```
Estimated time: 25 hours

To understand the results, you can check
[this](https://github.com/jubitaneja/artifact-cgo#section-41).


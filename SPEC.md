# Precision Testing of SPEC CPU 2017 Benchmark

**Main Idea:** For the evaluation of Section 4.1, we compiled
SPEC CPU 2017 benchmark with Souper and cached
the Souper expressions in Redis. The cache is shipped with our docker image.
For each expression harvested by Souper, we compare the dataflow
facts computed by precise algorithms written by
us against what an LLVM compiler computes.

# Setup Redis

First, let us make sure the redis-server is serving the Souper expressions of SPEC CPU benchmarks. You can check the keyspace by:
```
(docker) $ cd /usr/src/artifact-cgo/precision/spec/ && redis-server &
(docker) $ redis-cli dbsize
```
This should return `269,113`. The artifact provides redis cache file `dump.rdb.7z`
that contains all input Souper expressions.

# Set Souper environment variables

```
(docker) $ export SOUPER_IGNORE_SOLVER_ERRORS=1
(docker) $ export SOUPER_SOLVER="-z3-path=/usr/src/artifact-cgo/precision/souper/third_party/z3-install/bin/z3"
```

# Evaluation: Table 1 (Precision Testing of each DFA)

We are now finally ready to test precision of each dataflow fact
evaluated in Table 1.

### Set Memory Limit
We recommend setting memory limit, so that your machine does not hang
by using the entire swap space. The precision testing experiment
consumes a lot of memory. For instance, we set the memory limit to
2GB in our experiments.
```
(docker) $ ulimit -Sv 2000000
```
### Set Execution Timeout
We also limit execution time of `souper-check` and `Z3` in `crontab`
to keep running these experiments at a faster pace. Note: `crontab` is not shipped in our docker image, ignore this section if you're working inside docker.

```
(docker) $ crontab -e
```

Add following crontab entries.
```
*/5 * * * *  killall -u root -older-than 15m souper-check
*/5 * * * *  killall -u root -older-than 15m z3
```

### Run Precision Testing Script

When you run each script (recommend, one at a time only),
it generates thousands of small files containing the results
computed by Souper and LLVM. So, for clean usage and
understanding later on, create separate directories and run
scripts in that so that you can always have separate results.

Make sure you set and move to the path:
```
(docker) $ export CGO_HOME=/usr/src/artifact-cgo
(docker) $ cd $CGO_HOME
```
- **For known bits dataflow fact:**
```
(docker) $ mkdir $CGO_HOME/known && cd $CGO_HOME/known
(docker) $ $CGO_HOME/precision/souper-build/cache_dfa --knownbits
```
You will see filenames starting with `knownbits_*`
This may take up to 22 hours to finish on a machine
with 16-cores.

- **For negative dataflow fact:**
```
(docker) $ mkdir $CGO_HOME/neg && cd $CGO_HOME/neg
(docker) $ $CGO_HOME/precision/souper-build/cache_dfa --neg
```
Estimated time: 5 hours

- **For non-negative dataflow fact:**
```
(docker) $ mkdir $CGO_HOME/non-neg && cd $CGO_HOME/non-neg
(docker) $ $CGO_HOME/precision/souper-build/cache_dfa --nonneg
```
Estimated time: 9 hours

- **For non-zero dataflow fact:**
```
(docker) $ mkdir $CGO_HOME/non-zero && cd $CGO_HOME/non-zero
(docker) $ $CGO_HOME/precision/souper-build/cache_dfa --nonzero
```
Estimated time: 18 hours

- **For power of two dataflow fact:**
```
(docker) $ mkdir $CGO_HOME/power && cd $CGO_HOME/power
(docker) $ $CGO_HOME/precision/souper-build/cache_dfa --power
```
Estimated time: 5 hours

- **For number of sign bits dataflow fact:**
```
(docker) $ mkdir $CGO_HOME/signbits && cd $CGO_HOME/signbits
(docker) $ $CGO_HOME/precision/souper-build/cache_dfa --signBits
```
Estimated time: 21 hours

- **For integer range dataflow fact:**
```
(docker) $ mkdir $CGO_HOME/range && cd $CGO_HOME/range
(docker) $ $CGO_HOME/precision/souper-build/cache_range
```
Estimated time: 25 hours

- **For demanded bits dataflow fact:**
```
(docker) $ mkdir $CGO_HOME/db && cd $CGO_HOME/db
(docker) $ $CGO_HOME/precision/souper-build/cache_demandedbits
```
Estimated time: 25 hours

To understand the results, you can check
[this](README.md#analysis-section-41).


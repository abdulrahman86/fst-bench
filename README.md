# Hadoop Benchmark Suite (HiBench) #
## HiBench - the Hadoop Benchmark Suite ##

---
- Release version: 2.2
- Release date: 2012/10/23
- Contact: [Lan Yi](mailto:lan.yi@intel.com), [Kai Wei](mailto:kai.wei@intel.com), [Shengsheng Huang](mailto:shengsheng.huang@intel.com), [Jason Dai](mailto:jason.dai@intel.com) 
- Homepage: https://github.com/intel-hadoop/Hibench

- Contents:
    1. Overview
    2. Getting Started
    3. Running
    4. For Yarn

---
### OVERVIEW ###

This benchmark suite contains 10 typical Hadoop workloads (including micro benchmarks, HDFS benchmarks, web search benchmarks, machine learning benchmarks, and data analytics benchmarks). This benchmark suite also has options for users to enable input/output compression for most workloads with default compression codec (zlib). Some initial work based on this benchmark suite please refer to the included ICDE workshop paper (i.e., `WISS10_conf_full_011.pdf`).

Note: Since HiBench-2.2, the input data of benchmarks are all automatically generated by their corresponding prepare scripts.

  **Micro Benchmarks:**

1. Sort (sort)

    This workload sorts its *text* input data, which is generated using the Hadoop RandomTextWriter example.

2. WordCount (wordcount)

    This workload counts the occurrence of each word in the input data, which are generated using the Hadoop RandomTextWriter example. It is representative of another typical class of real world MapReduce jobs - extracting a small amount of interesting data from large data set.

3. TeraSort (terasort)

    TeraSort is a standard benchmark created by Jim Gray. Its input data is generated by Hadoop TeraGen example program.

  **HDFS Benchmarks:**

4. enhanced DFSIO (dfsioe)

    Enhanced DFSIO tests the HDFS throughput of the Hadoop cluster by generating a large number of tasks performing writes and reads simultaneously. It measures the average I/O rate of each map task, the average throughput of each map task, and the aggregated throughput of HDFS cluster.

5. Sleep (sleep)

    This workload just sleep for the time you set.

  **Web Search Benchmarks:**

6. Nutch indexing (nutchindexing)

    Large-scale search indexing is one of the most significant uses of MapReduce. This workload tests the indexing sub-system in Nutch, a popular open source (Apache project) search engine. The workload uses the automatically generated Web data whose hyperlinks and words both follow the Zipfian distribution with corresponding parameters. The dict used to generate the Web page texts is the default linux dict file /usr/share/dict/linux.words.

7. PageRank (pagerank)

    The workloads contains an implementation of the PageRank algorithm on Hadoop (a search engine ranking benchmark included in pegasus 2.0). The workload uses the automatically generated Web data whose hyperlinks follow the Zipfian distribution.

  **Machine Learning Benchmarks:**

8. Mahout Bayesian classification (bayes)

    Large-scale machine learning is another important use of MapReduce. This workload tests the Naive Bayesian (a popular classification algorithm for knowledge discovery and data mining) trainer in Mahout 0.7, which is an open source (Apache project) machine learning library. The workload uses the automatically generated documents whose words follow the zipfian distribution. The dict used for text generation is also from the default linux file /usr/share/dict/linux.words.

9. Mahout K-means clustering (kmeans)
    
    This workload tests the K-means (a well-known clustering algorithm for knowledge discovery and data mining) clustering in Mahout 0.7. The input data set is generated by GenKMeansDataset based on Uniform Distribution and Guassian Distribution.

  **Data Analytics Benchmarks:**

10. Hive Query Benchmarks (hivebench)

    This workload is developed based on SIGMOD 09 paper "A Comparison of Approaches to Large-Scale Data Analysis" and HIVE-396. It contains Hive queries (Aggregation and Join) performing the typical OLAP queries described in the paper. Its input is also automatically generated Web data with hyperlinks following the Zipfian distribution.

---
### Getting Started ###

2. Prerequisites 

  1. Setup HiBench

      Make sure these things are installed: maven. Then, locate into `HiBench/common/hibench` and run `mvn process-sources` to get dependencies.

  2. Setup Hadoop

      Before you run any workload in the package, please verify the Hadoop framework is running correctly. All the workloads have been tested with Cloudera Distribution of Hadoop 5(cdh5.1.0) and Hadoop version 1.0.4 and 2.2.0

  3. Setup Hive (for hivebench)
    
      Please make sure you have properly set up Hive in your cluster if you want to test hivebench. Or the benchmark willuse the default release fetched by maven.

2. Configure for the all workloads

    You need to set some global environment variables in the `bin/hibench-config.sh` file located in the root dir.

          HADOOP_HOME      <The Hadoop installation location>
          HADOOP_CONF_DIR  <The hadoop configuration DIR, default is $HADOOP_HOME/conf>
          COMPRESS_GLOBAL  <Whether to enable the in/out compression for all workloads, 0 is disable, 1 is enable>
          COMPRESS_CODEC_GLOBAL  <The default codec used for in/out data compression>

    Note: Do not change the default values of other global environment variables unless necessary.

3. Configure each workload

    You can modify the `conf/configure.sh` file under each workload folder if it exists. All the data size and options related to the workload are defined in this file. 

4. Synchronize the time on all nodes (This is required for dfsioe, and optional for others)

---
### Running ###

- Run several workloads together

  The `conf/benchmarks.lst` file under the package folder defines the workloads to run when you execute the `bin/run-all.sh` script under the package folder. Each line in the list file specifies one workload. You can use `#` at the beginning of each line to skip the corresponding bench if necessary. 

- Run workload in throughput test mode

  The `conf/benchmarks-concurrent.lst` file under the package folder defines the workloads to run when you execute the `bin/run-concurrent.sh` script under the package folder. The number at the end of each line indicates the number of each workload you want to submit simultaneously. Before running, execute the script `bin/prepare-concurrent.sh`.

  For the workload hivebench, please run the metastore as a service first to support concurrency: `hive --service metastore`.

- Run each workload separately

  You can also run each workload separately. In general, there are 3 different files under one workload folder.

        conf/configure.sh	Configuration file contains all parameters such as data size and test options.
        bin/prepare*.sh   Generate or copy the job input data into HDFS.
        bin/run*.sh       Execute the workload

  Follow the steps below to run a workload

  1. Configure the benchmark: 
      
      set your own configurations by modifying `configure.sh` if necessary
  2. Prepare data: 
      
      `bin/prepare.sh` (`bin/prepare-read.sh` for dfsioe) to prepare input data in HDFS for running the benchmark
  3. Run the benchmark:
      
      `bin/run*.sh` to run the corresponding benchmark



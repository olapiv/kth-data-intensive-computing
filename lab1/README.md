# Lab 1 - MapReduce, HDFS, HBase, Spark

## Build

```bash
    cd lab1
    docker build -t dic-lab1 .
```

## Start and Setup container

1. Run the Docker container in interactive mode

   ```bash
    docker run -it \
        -p 9870:9870 -p 9864:9864 -p 8888:8888 \
        -v ${PWD}/src:/home/dataintensive/src \
        dic-lab1:latest
    ```

1. Run `$APP_HOME/entrypoint.sh`

    This will prompt the message *"The authenticity of host 'localhost (127.0.0.1)' can't be established. Are you sure you want to continue connecting (yes/no)?"*. Type in *yes*.

1. Run `$APP_HOME/tests/test_hadoop.sh` to check whether Hadoop is working (optional)

<<<<<<< HEAD
1. Open http://127.0.0.1:9870 or http://127.0.0.1:9864 in Browser to check port mapping

## Task 1

1. Run `source $APP_HOME/src/id2221/topten/setup.sh`

1. Create table in HBase

    1. `$HBASE_HOME/bin/hbase shell`
    1. In HBASE shell run `create 'topten', 'info'`
    1. Exit shell (ctrl + c)

1. Run top_ten.java. The output is HBase table.

    `$HADOOP_HOME/bin/hadoop jar topten.jar id2221.topten.TopTen topten_input`

1. Check output in HBase

    1. $HBASE_HOME/bin/hbase shell
    1. In HBASE shell run `scan 'topten'`
    1. Exit shell (ctrl + c)
=======
1. Open http://127.0.0.1:9870 or http://127.0.0.1:9864 or http://127.0.0.1:8888 in Browser to check port mapping
>>>>>>> 9368cdc... added the necessary software needed for part 2

# Lab 1 - MapReduce, HDFS, HBase, Spark

## Build

```bash
    docker build -t dic-lab1 .
```

## Run

1. Run the Docker container in interactive mode

   ```bash
    docker run -it \
        -p 9870:9870 -p 9864:9864 \
        -v ${PWD}/src:/home/dataintensive/src \
        dic-lab1:latest
    ```

1. Run `$APP_HOME/entrypoint.sh`

1. Run `$APP_HOME/tests/test_hadoop.sh` to check whether Hadoop is working

1. Open http://127.0.0.1:9870 or http://127.0.0.1:9864 in Browser to check port mapping

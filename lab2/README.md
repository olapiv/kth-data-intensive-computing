# Lab 2 - Stream and Graph Processing with Spark, Kafka, and Cassandra

## Build

```bash
    cd lab2
    docker build -t dic-lab2 .
```

## Start and Setup container

1. Run the Docker container in interactive mode

   ```bash
    docker run -it \
        -p 2128:2128 -p 8888:8888 \
        -v ${PWD}/src:/home/dataintensive/src \
        dic-lab2:latest
    ```

1. Run `$APP_HOME/entrypoint.sh`

    This will prompt the message *"The authenticity of host 'localhost (127.0.0.1)' can't be established. Are you sure you want to continue connecting (yes/no)?"*. Type in *yes*.

1. Run `$APP_HOME/tests/test_hadoop.sh` to check whether Hadoop is working (optional)

1. Open http://127.0.0.1:9870 or http://127.0.0.1:9864 in Browser to check port mapping

## Task 1

[WIP]

## Task 2
1. Run `$APP_HOME/run/jupyter_notebook.sh`

    This will start the Jupyter Notebook on port 8888
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
        -p 2128:2128 -p 8888:8888 -p 9042:9042 \
        -v ${PWD}/src:/home/dataintensive/src \
        dic-lab2:latest
    ```
## Task 1
1. Run '$APP_HOME/entrypoint.sh'

2. Run 'cd src/sparkstreaming/'

    You should now be in the sparkstreaming directory

3. Run 'setsid nohup sbt run &'

    This will run the KafkaSpark application in the background

4. Run 'cd ..' & then 'cd generator'

    You should now be in the generator directory

4. Run 'sbt run'

    This will start the Producer to generate a streaming input (pairs of "String,int") and feed them to Kafka.
    Let this run for a while before doing 'ctrl + c' to kill the process/application.

5. Run '$CASSANDRA_HOME/bin/cqlsh'

    This starts the cqlsh prompt

6. Run 'use avg_space; select * from avg;'

    Now you should see some results

[WIP]

## Task 2
1. Run `$APP_HOME/run/jupyter_notebook.sh`

    This will start the Jupyter Notebook on port 8888
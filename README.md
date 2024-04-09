# kafka-debug-container
A docker image with debug utils that are handy for diagnosing issues with a CFK install of Confluent Platform.

Pre-built images for linux AMD and ARM are here: https://hub.docker.com/repository/docker/bargovic/kafka-debug

#### Tools included
* [Apache Kafka CLI](https://docs.confluent.io/kafka/operations-tools/kafka-tools.html)
* curl
* jq
* [kcat](https://github.com/edenhill/kcat)
* keytool
* kubectl
* netcat
* netstat
* nslookup
* openssl
* vi

### How to build and run
You can re-build the image with your own client properties files and keystore(s)/truststore(s).  
Place the files you want to load into the container in the `properties/` and `keystores/` directories, and then rebuild.

```
docker buildx build --platform linux/amd64 -t bargovic/kafka-debug:1.0.2-amd64 .
docker run -it bargovic/kafka-debug:1.0.2-amd64 /bin/bash
```

### How to deploy to K8s
```
kubectl apply -f debug-pod.yml -n confluent
```

### Example debug commands 
Apache Kafka CLI:
```
kafka-topics --list --bootstrap-server kafka.fios-router.home:9092 --command-config properties/kafka-client.properties
```

ksqlDB Shell:
```
ksql https://ksqldb.fios-router.home -u testadmin --config-file properties/ksql.properties
```

Update connect logging level:
```
curl -s -k -X PUT -H "Content-Type:application/json" https://connect/admin/loggers/io.confluent.connect.syslog -d '{"level": "DEBUG"}' -u <username>:<password> | jq
curl -s -k -X GET https://connect/admin/loggers/ -u <username>:<password> | jq
```

nslookup and netcat:
```
nslookup kafka.fios-router.home
nc -zv kafka.fios-router.home 9092

nslookup kafka.confluent.svc.cluster.local
nc -zv kafka.confluent.svc.cluster.local 9071
```




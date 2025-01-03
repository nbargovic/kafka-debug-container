# kafka-debug-container
A docker image with debug utils that are handy for diagnosing issues with a CFK install of Confluent Platform. 

#### Tools included
* [Apache Kafka CLI](https://docs.confluent.io/kafka/operations-tools/kafka-tools.html)
* curl
* helm
* jq
* [kcat](https://github.com/edenhill/kcat)
* keytool
* [ksqldb-cli](https://docs.confluent.io/platform/current/ksqldb/installing.html#starting-the-ksqldb-cli)
* kubectl
* netcat
* netstat
* nslookup
* openssl
* oc
* vi

### How to build
You can build the image with your own client properties files and keystore(s)/truststore(s).  
1. Base64 the contents of all keystores, truststores, and kube config files.
<bt>example `cat keystore.p12 | base64`
2. Insert the base64 contents into `debug-secrets.yml`
3. Update or insert any client connection properties files into the `properties/` directory
4. Build the container:
```
docker buildx build --platform linux/amd64 -t bargovic/kafka-debug:2.0.0-amd64 .
```

### How to deploy to K8s
```
kubectl apply -f debug-secrets.yaml
kubectl apply -f debug-pod.yml -n confluent
```

### Example debug commands 
Apache Kafka CLI:
```
kafka-topics.sh --list --bootstrap-server kafka.fios-router.home:9092 --command-config properties/kafka-client.properties
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




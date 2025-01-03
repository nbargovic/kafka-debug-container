FROM confluentinc/cp-base-new:latest

USER root

RUN dnf update -y

RUN dnf install -y nmap-ncat \
 && dnf install -y bind-utils \
 && dnf install -y jq \
 && dnf install -y vim \
 && dnf install -y openssl-libs \
 && dnf install -y net-tools

RUN mkdir -p /home/appuser/.local/bin
RUN chown -R appuser:appuser /home/appuser/.local
RUN mkdir -p /home/appuser/.kube
RUN chown -R appuser:appuser /home/appuser/.kube
COPY --chown=appuser --chmod=755 ./kubectl/kubectl.amd64 /home/appuser/.local/bin/kubectl
COPY --chown=appuser --chmod=755 ./kcat-1.7.1/kcat.amd64 /usr/bin/kcat
COPY --chown=appuser --chmod=755 ./helm-3.16.4/helm.amd64 /usr/bin/helm
COPY --chown=appuser --chmod=755 ./openshift-client/oc.tar.gz /home/appuser/.
RUN tar -zxvf /home/appuser/oc.tar.gz
RUN rm /home/appuser/oc.tar.gz
RUN mv oc /usr/bin/oc
RUN chown appuser:appuser /usr/bin/oc

WORKDIR /home/appuser

COPY --chown=appuser --chmod=755 ./kafka_2.13-3.8.1 /home/appuser/kafka_2.13-3.8.1/.
COPY --chown=appuser --chmod=755 ./ksqldb-cli-7.8.0 /home/appuser/ksqldb-cli-7.8.0/.
COPY --chown=appuser --chmod=755 ./properties /home/appuser/properties/.

ENV PATH="${PATH}:/home/appuser/kafka_2.13-3.8.1/bin:/home/appuser/ksqldb-cli-7.8.0/bin"

USER appuser

#used to keep pod alive in k8s deployment
CMD ["sh", "-c", "tail -f /dev/null"]

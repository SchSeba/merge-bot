FROM registry.access.redhat.com/ubi8/python-39

USER root

ENV GO_VERSION=1.21.6
RUN curl -Ls https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz | \
    tar -C /usr/local -zxvf -
ENV PATH="/usr/local/go/bin:$PATH"

COPY go.env /usr/local/go/

WORKDIR /src
COPY . .
RUN python -m pip install .

WORKDIR /working
RUN rm -rf /src
RUN chown default .
RUN chmod 0777 .

USER default
ENTRYPOINT [ "/opt/app-root/bin/merge-bot" ]

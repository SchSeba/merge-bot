FROM registry.fedoraproject.org/fedora:42

USER root

RUN dnf update -y && dnf install -y python3-pip git make diffutils && dnf clean all

ENV GO_VERSION=1.24.6
RUN curl -Ls https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz | \
    tar -C /usr/local -zxvf -
ENV PATH="/usr/local/go/bin:$PATH"

COPY go.env /usr/local/go/

WORKDIR /src
COPY . .
RUN python -m pip install .

WORKDIR /working
RUN rm -rf /src
RUN useradd --no-create-home merge-bot
RUN chown merge-bot .
RUN chmod 0777 .

USER merge-bot
ENTRYPOINT [ "/usr/local/bin/merge-bot" ]

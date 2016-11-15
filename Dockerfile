FROM debian:jessie

RUN apt-get update \
  && apt-get install -y --no-install-recommends curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY runner /usr/local/bin/testrunner

COPY . /test/
WORKDIR /test
ENTRYPOINT ["testrunner"]

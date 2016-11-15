# Assert curl output

Your typical bash script for smoke testing a microservice would start:

```bash
#!/bin/bash
set -e
[[ ! -z "$DEBUG" ]] && set -x
trap "exit" INT

CURL_RETRY="--retry 3 --retry-delay 5"
# because curl retry doesn't happen on "Connection refused", i.e. when a dependency isn't up yet
sleep $CURL_INITIAL_WAIT

curl $CURL_RETRY -f http://my-service/
curl $CURL_RETRY -I http://my-service/nonexistent | grep "404"
curl $CURL_RETRY -f http://my-service/page | grep -v "/[Pp]age title/"
```

Works great with for example [build-contract](https://github.com/Yolean/build-contract),
but with limitations:
 * Quite a bit of boilerplate for every script.
 * Assertion errors are really just errors. With teting libs you'd expect to see what the actual result was.

## Using crep

Put a bunch of test scripts named `*.sh` in ./test and...
```
docker run --rm -v $(pwd)/test:/test -e DEBUG=y -e CURL_INITIAL_WAIT=1 -e CURL_RETRY="--retry 2 --retry-delay 3" yolean/crep
echo "$? == 0 means success"
```

## Building

```
docker build -t yolean/crep .
```

Publish to https://hub.docker.com/r/yolean/crep/

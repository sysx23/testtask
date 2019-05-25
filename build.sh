#!/bin/bash

function check_http {
	http_code="$(curl -s -o /dev/null -w "%{http_code}" localhost:$port)"
	echo $http_code | grep "^200$" > /dev/null
}

echo -n Building image
image=$(docker build -q -t test .)
echo " - $image"
echo -n Running container
container=$(docker run -p :80 --rm -d test)
echo " - $container"
port="$(docker port $container  $port | cut -d: -f2)"
echo Service is listning on port $port

echo Waiting for service to be started
for i in $(seq 1 30); do
	sleep 1;
	echo -n .
	check_http && break
done
echo


if check_http ; then
	echo Everything is up and running. Have a nice day!
else 
	echo Testing failed:
	echo "	expected http response status code: 200"
	echo "	got: $http_code"
	exit 1
fi


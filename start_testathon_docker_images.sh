#!/bin/bash

echo ""
echo -e "[ INFO ] Cleaning up Testathon containers and network..."

docker stop testathon-database &> /dev/null
docker stop testathon-liferay &> /dev/null

docker rm testathon-database &> /dev/null
docker rm testathon-liferay &> /dev/null

docker network rm testathon-network &> /dev/null

echo ""
echo -e "[ INFO ] Creating Testathon network..."

docker network create testathon-network

echo ""
echo -e "[ INFO ] Creating MySQL database container..."

docker run \
	--detach \
	--env MYSQL_ALLOW_EMPTY_PASSWORD="yes" \
	--env MYSQL_DATABASE=lportal \
	--health-cmd='mysqladmin ping -h localhost' \
	--health-retries=10 \
	--health-timeout=20s \
	--name testathon-database \
	--network testathon-network \
	--publish 3310:3306 \
	mysql:8.0

echo ""
echo -e "[ INFO ] Waiting for MySQL database container to become operational..."

attempt=0
max_attempts=60

until [ "$(docker inspect --format '{{.State.Health.Status}}' testathon-database)" == "healthy" ]
do
	attempt=$((attempt + 1))

	if [[ "${attempt}" -ge "${max_attempts}" ]]
	then
		echo ""
		echo -e "[ ERROR ] MySQL database container did not become healthy after $((max_attempts * 2)) seconds. Aborting."
		exit 1
	fi

	sleep 2
done

echo ""
echo -e "[ INFO ] Creating Liferay Portal container..."

docker run \
	--name testathon-liferay \
	--network testathon-network \
	--platform linux/amd64 \
	--publish 8080:8080 \
	liferay/release-candidates:testathon-2026.q1-phase-2
#!/bin/bash

docker stop testathon-database &> /dev/null
docker stop testathon-liferay &> /dev/null

docker rm testathon-database &> /dev/null
docker rm testathon-liferay &> /dev/null

docker network rm testathon-network &> /dev/null

docker network create testathon-network

docker run -d \
	--name testathon-database \
	--network testathon-network \
	-p 3310:3306 \
	-e MYSQL_ALLOW_EMPTY_PASSWORD="yes" \
	-e MYSQL_DATABASE=lportal \
	--health-cmd='mysqladmin ping -h localhost' \
	--health-retries=10 \
	--health-timeout=20s \
	mysql:8.0

sleep 20

docker run \
	--name testathon-liferay \
	--network testathon-network \
	-p 8080:8080 \
	liferay/release-candidates:testathon-2026.q1-phase-1-for-mysql
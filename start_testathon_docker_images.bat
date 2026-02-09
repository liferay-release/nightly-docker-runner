@echo off

echo.
echo [ INFO ] Cleaning up Testathon containers and network...

docker stop testathon-database >nul 2>&1
docker stop testathon-liferay >nul 2>&1

docker rm testathon-database >nul 2>&1
docker rm testathon-liferay >nul 2>&1

docker network rm testathon-network >nul 2>&1

echo.
echo [ INFO ] Creating Testathon network...

docker network create testathon-network

echo.
echo [ INFO ] Creating MySQL database container...

docker run -d ^
	--name testathon-database ^
	--network testathon-network ^
	-p 3310:3306 ^
	-e MYSQL_ALLOW_EMPTY_PASSWORD="yes" ^
	-e MYSQL_DATABASE=lportal ^
	--health-cmd="mysqladmin ping -h localhost" ^
	--health-retries=10 ^
	--health-timeout=20s ^
	mysql:8.0

echo.
echo [ INFO ] Waiting for MySQL database container to become operational...

timeout /t 20 /nobreak >nul

echo.
echo [ INFO ] Creating Liferay Portal container...

docker run ^
	--name testathon-liferay ^
	--network testathon-network ^
	-p 8080:8080 ^
	liferay/release-candidates:testathon-2026.q1-phase-1-for-mysql
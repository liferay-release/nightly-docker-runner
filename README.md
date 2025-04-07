Download this repository using the link https://github.com/liferay-release/nightly-docker-runner/archive/refs/heads/main.zip.

Next, add or copy the `*.config` files to the folder `configs`, like `com.liferay.portal.search.elasticsearch.configuration.ElasticsearchConfiguration.config`, and/or edit the existing `portal-ext.properties` placed in the folder `properties`. These resources will be copied to the nightly build before its starts up. Then, choose one of the following options to run the nightly build:

## How to run the nightly build with the default database (Hypersonic)

1. `docker build -t nightly .`
2. `docker run --name liferay-nightly --publish 8080:8080 nightly`

## How to run the nightly build with a MySQL database
 
1. Open the file `properties/portal-ext.properties` and remove all `#` to enable the MySQL configuration.
2. Open the terminal and run the command `docker-compose up`.
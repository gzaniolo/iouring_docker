# Some instrs

## WARNINGS

Some stuff is not working, but I figured it would be better to get a preliminary version out so you can at least get programming io uring.

## Actual instrs

### Create docker
To create docker container image:
```
docker build -t gfs .
```
To start docker container:
```
docker run -d --name test-container -e TZ=UTC -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=password gfs 
```
To enter shell in docker container:
```
docker exec -it test-container /bin/bash
```


### pgbouncer
This command must only be run once at container creation:
```
chmod 777 /var/run/postgresql/
```
To run pgbouncer:
```
su - pgbouncer
pbbouncer a.ini
```

### benchbase
#### WARNING: I don't think this works, but you should be able to at least program our own pgbouncer and get it to run
To test benchbase:
```
cd /root/benchbase/target/benchbase-postgres
java -jar benchbase.jar -b tpcc -c config/postgres/sample_tpcc_config.xml --create=true --load=true --execute=true
```
#### This one should work
To test benchbase with pgbouncer (remember to start pgbouncer first):
```
cd /root/benchbase/target/benchbase-postgres
java -jar benchbase.jar -b tpcc -c config/postgres/sample_tpcc_config_2.xml --create=true --load=true --execute=true
```

# Use the base PostgreSQL image you're currently using
FROM ubuntu/postgres:14-22.04_beta

# Install PgBouncer
RUN apt-get update && \
    apt-get install -y \
    # for benchbase
    git \
    openjdk-21-jdk \
    # for pgbouncer
    libtool \
    pandoc \
    make \
    openssl \ 
    libssl-dev \
    pkg-config \
    libevent-dev \
    && \
    rm -rf /var/lib/apt/lists/*

# Initialize necessary postgres database
ENV POSTGRES_USER=admin
ENV POSTGRES_PASSWORD=password

COPY init-db.sh /docker-entrypoint-initdb.d/

# Give password 'a' to the root user. 
# Necessary for non-root user to be able to su - root
RUN echo "root:a" | chpasswd
# Set the PgBouncer configuration file

WORKDIR /root/

RUN git clone --depth 1 https://github.com/cmu-db/benchbase.git
RUN cd benchbase && \
    ./mvnw clean package -P postgres && \
    cd target && \
    tar xvzf benchbase-postgres.tgz

# Configuration that can test if pgbouncer is working
COPY sample_tpcc_config_2.xml \
  benchbase/target/benchbase-postgres/config/postgres/sample_tpcc_config_2.xml

# Create a non-root user for running PgBouncer
RUN groupadd -r pgbouncer && useradd -r -g pgbouncer -m pgbouncer

# Change pgbouncer shell to bash
RUN chsh -s /bin/bash pgbouncer

WORKDIR /home/pgbouncer/

# Set the PgBouncer configuration file
# NOTE: If you want to change these paths, you must also change 'a.ini'
# If you change it somewhere not in user directory, you must also change the 
#  permissions of that location to allow pgbouncer to access it
COPY a.ini a.ini
COPY userlist.txt userlist.txt

RUN git clone https://github.com/pgbouncer/pgbouncer.git && \
    cd pgbouncer && \
    git submodule init && \
    git submodule update && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install

# Sadge: This command does not appear to do what we want
# PgBouncer needs access to this directory
RUN chmod 777 /var/run/postgresql/


WORKDIR /

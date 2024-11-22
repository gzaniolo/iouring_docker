#!/bin/bash
set -e

# Wait for PostgreSQL to start, then create the database
until psql -U "$POSTGRES_USER" -h "localhost" -c '\l' > /dev/null 2>&1; do
  echo "Waiting for PostgreSQL to start..."
  sleep 2
done

# Create the database
psql -U "$POSTGRES_USER" -h "localhost" -c "CREATE DATABASE benchbase;"

echo "Database 'benchbase' created successfully!"

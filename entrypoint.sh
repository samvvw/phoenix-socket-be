#!/bin/bash

while ! pg_isready -q -h $PGHOST -p $PGPORT -U $PGUSER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
  echo "Database $PGDATABASE does not exist. Creating..."
  mix ecto.create
  echo "Database $PGDATABASE created."
  mix ecto.migrate
  mix run priv/repo/seeds.exs
fi

if [[ ! -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
  echo "APP should run now"
  echo "running app"
  mix phx.server
fi
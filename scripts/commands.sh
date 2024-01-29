#!/bin/sh

#o shell irá encerrar o script caso algum comando falhe
set -e

while ! nc -z$POSTGRES_HOST $POSTGRES_PORT; do
  echo "Waiting for postgres datatbase startup ($POSTGRES_HOST $POSTGRES_PORT)..."  
  sleep 0.1
done

echo "PostgreSQL started ($POSTGRES_HOST:$POSTGRES_PORT)"

python manage.py collectstatic
python manage.py migrate 
python manage.py runserver
#!/bin/bash
 /bin/bash -c "source /opt/conda/bin/activate lost"

 # init env vars 
if [ -z "${LOST_DB_IP}" ]; then
  export LOST_DB_IP="db-lost"
fi

if [ -z "${LOST_DB_PORT}" ]; then
  export LOST_DB_PORT=3306
fi

if [ -z "${RABBITMQ_IP}" ]; then
  export RABBITMQ_IP="rabbitmqlost"
fi

if [ -z "${RABBITMQ_PORT}" ]; then
  export RABBITMQ_PORT=5672
fi

# Wait for database to get available
#wait for l3p mysql
nc -z $LOST_DB_IP $LOST_DB_PORT
n=$?
while [ $n -ne 0 ]; do
    sleep 1
    nc -z $LOST_DB_IP $LOST_DB_PORT
    n=$?
    echo "$(date): Waiting for MySQL@$LOST_DB_IP:$LOST_DB_PORT"
done

#wait for rabbitmq
# nc -z $RABBITMQ_IP $RABBITMQ_PORT
# n=$?
# while [ $n -ne 0 ]; do
#     sleep 1
#     nc -z $RABBITMQ_IP $RABBITMQ_PORT
#     n=$?
#     echo "$(date): Waiting for RabbitMQ@$RABBITMQ_IP:$RABBITMQ_PORT"
# done

mkdir -p ${LOST_HOME}/logs

if [ ${DEV} = "True" ]; then
  source /opt/conda/bin/activate lost && python3 /code/backend/lost/app.py
  # endpoint="source /opt/conda/bin/activate lost && python3 /code/backend/lost/app.py"
  # eval $endpoint &
  #cd /code/frontend/lost
  #npm start
  #frontend="npm start"
  # # eval $frontend &

else
  echo "Production version not yet supported."
  #gunicorn lost.wsgi -b 0.0.0.0:8000
fi
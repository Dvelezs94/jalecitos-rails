#!/bin/bash -x

function start() {
  docker-compose up -d --build --force-recreate
}

function stop() {
  docker-compose down
}

function create_db() {
  docker-compose exec app rails db:create
}

case $1 in
  start)
    start
  ;;
  stop)
    stop
  ;;
  create-db)
    create_db
  ;;
  run)
    shift
    docker-compose exec app $@
  ;;
  restart)
    stop
    start
  ;;
  fix-perms)
    sudo chown -R $USER:$USER .
  ;;
  *)
    echo "
    Usage: 
    $0 start/stop
    $0 create-db
    $0 run command here
    $0 fix-perms"
  ;;
esac
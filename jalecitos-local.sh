#!/bin/bash -x

function start() {
  docker-compose up -d --build --force-recreate
}

function stop() {
  docker-compose down
}

function create_db() {
  docker-compose exec app rails db:create
  docker-compose exec app rails db:migrate
}

function generate_db_diagram {
  bash $0 run rake diagram:all
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
    sudo chown -R $USER:$USER app/
  ;;
  db_diag)
    generate_db_diagram
  ;;
  *)
    echo "
    Usage:
    $0 start/stop
    $0 create-db
    $0 run command here
    $0 fix-perms
    $0 db_diag"
  ;;
esac
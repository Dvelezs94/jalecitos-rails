#!/bin/bash -x

function start() {
  read -p "Delete DB folder to start from scratch? (y/n): " DBDEL
  read -p "Create DB and migrations on startup? (y/n): " DBCREATE
  if [ "$DBDEL" == "y" ]
  then
    echo "Deleting DB folder..."
    sudo rm -rf tmp/db/
    echo "done."
  fi
  docker-compose up -d --build --force-recreate
  if [ "$DBCREATE" == "y" ]
  then
    bash $0 create-db
  fi
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

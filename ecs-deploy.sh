#!/bin/bash -e

echo "Deploying commit $CI_COMMIT_SHORT_SHA on branch $CI_COMMIT_REF_NAME"
case $CI_COMMIT_REF_NAME in
  master)
    ecs deploy jalecitos-prod rails -t $CI_COMMIT_SHORT_SHA --timeout 300
    ecs deploy jalecitos-prod sidekiq -t $CI_COMMIT_SHORT_SHA --timeout 300
  ;;
  development)
    ecs deploy jalecitos-dev rails -t $CI_COMMIT_SHORT_SHA --timeout 300
    ecs deploy jalecitos-dev sidekiq -t $CI_COMMIT_SHORT_SHA --timeout 300
  ;;
  staging)
    ecs deploy jalecitos-stage rails -t $CI_COMMIT_SHORT_SHA --timeout 300
    ecs deploy jalecitos-stage sidekiq -t $CI_COMMIT_SHORT_SHA --timeout 300
  ;;
esac

echo "Deployed succesfully"

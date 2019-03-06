#!/bin/sh

echo "Deploying commit $CI_COMMIT_SHORT_SHA on branch $CI_COMMIT_REF_NAME"
case $CI_COMMIT_REF_NAME in
  master)
    ecs deploy jalecitos-production rails -t ${CI_COMMIT_REF_NAME}-${CI_COMMIT_SHORT_SHA} --region $AWS_REGION --timeout 300
    ecs deploy jalecitos-production sidekiq -t ${CI_COMMIT_REF_NAME}-${CI_COMMIT_SHORT_SHA} --region $AWS_REGION --timeout 300
  ;;
  development)
    ecs deploy jalecitos-dev rails -t ${CI_COMMIT_REF_NAME}-${CI_COMMIT_SHORT_SHA} --region $AWS_REGION --timeout 300
    ecs deploy jalecitos-dev sidekiq -t ${CI_COMMIT_REF_NAME}-${CI_COMMIT_SHORT_SHA} --region $AWS_REGION --timeout 300
  ;;
  staging)
    ecs deploy jalecitos-stage rails -t ${CI_COMMIT_REF_NAME}-${CI_COMMIT_SHORT_SHA} --region $AWS_REGION --timeout 300
    ecs deploy jalecitos-stage sidekiq -t ${CI_COMMIT_REF_NAME}-${CI_COMMIT_SHORT_SHA} --region $AWS_REGION --timeout 300
  ;;
esac

echo "Deployed succesfully"

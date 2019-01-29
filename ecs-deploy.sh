#!/bin/sh

echo "Deploying commit $CI_COMMIT_SHORT_SHA on branch $CI_COMMIT_REF_NAME"
case $CI_COMMIT_REF_NAME in
  master)
    ecs deploy jalecitos-prod rails -t $IMAGE_TAG --region $AWS_REGION --timeout 300
    ecs deploy jalecitos-prod sidekiq -t $IMAGE_TAG --region $AWS_REGION --timeout 300
  ;;
  development)
    ecs deploy jalecitos-dev rails -t $IMAGE_TAG --region $AWS_REGION --timeout 300
    ecs deploy jalecitos-dev sidekiq -t $IMAGE_TAG --region $AWS_REGION --timeout 300
  ;;
  staging)
    ecs deploy jalecitos-stage rails -t $IMAGE_TAG --region $AWS_REGION --timeout 300
    ecs deploy jalecitos-stage sidekiq -t $IMAGE_TAG --region $AWS_REGION --timeout 300
  ;;
esac

echo "Deployed succesfully"

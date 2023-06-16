#!/bin/bash

if [ -z $1 ]; then
  echo usage: ./getlogs.sh namespace
  exit 1
fi

echo "Making sure pod directory exist for redirect"
mkdir -p pod

export namespace=$1


echo "Finding pods and fetching logs and putting them into pod/podname.containername"
for pod in $(oc get pods -n $namespace -o name); do
  for container in \
    $(kubectl get $pod -n $namespace -o jsonpath={.spec.containers[*].name}); do
    oc logs $pod -n $namespace -c $container > $pod.$container
  done
done

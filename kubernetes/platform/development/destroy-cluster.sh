#!/bin/sh

echo "\n🏴️ Destroying Kubernetes cluster...\n"

minikube stop --profile shop

minikube delete --profile shop

echo "\n🏴️ Cluster destroyed\n"

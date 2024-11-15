#!/bin/sh

echo "\n📦 Initializing Kubernetes cluster...\n"

minikube start --cpus 2 --memory 4g --driver docker --profile shop

echo "\n🔌 Enabling NGINX Ingress Controller...\n"

minikube addons enable ingress --profile shop

sleep 15

echo "\n📦 Deploying platform services..."

kubectl apply -f services

sleep 5

echo "\n⌛ Waiting for PostgreSQL to be deployed..."

while [ $(kubectl get pod -l db=shop-postgres | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\n⌛ Waiting for PostgreSQL to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=shop-postgres \
  --timeout=180s

echo "\n⌛ Waiting for Redis to be deployed..."

while [ $(kubectl get pod -l db=shop-redis | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\n⌛ Waiting for Redis to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=shop-redis \
  --timeout=180s

echo "\n⌛ Waiting for RabbitMQ to be deployed..."

while [ $(kubectl get pod -l db=shop-rabbitmq | wc -l) -eq 0 ] ; do
  sleep 5
done

echo "\n⌛ Waiting for RabbitMQ to be ready..."

kubectl wait \
  --for=condition=ready pod \
  --selector=db=shop-rabbitmq \
  --timeout=180s

echo "\n⛵ Happy Sailing!\n"

#!/bin/bash

echo "Create VPC and subnets"
gcloud compute networks create lab-net  --subnet-mode=custom --bgp-routing-mode=regional
gcloud compute networks subnets create safe  --range=192.168.0.0/24 --network=lab-net --region=us-east1
gcloud compute networks subnets create unsafe --range=192.168.128.0/29 --network=lab-net --region=us-east1

echo "Creating instance"
gcloud compute instances create awesome-service --tags=admin

echo "Create Bucket for storage"
gsutil mb gs://bucket-of-bad-stuff

echo "Adding firewall rules"
gcloud compute firewall-rules create allow-ingress-admin-lab-net \
    --direction=INGRESS --priority=1000 --network=lab-net --action=ALLOW \
    --rules=tcp:22,tcp:80,tcp:443,icmp --source-ranges=0.0.0.0/0 --target-tags=admin
gcloud compute firewall-rules create allow-ingress-insecure-lab-net \
    --direction=INGRESS --priority=1000 --network=lab-net --action=ALLOW \
    --rules=all --source-ranges=0.0.0.0/0 --target-tags=insecure

echo "Done"
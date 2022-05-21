# AWS Kafka Cluster

This repo contains code to provision infrastructure in AWS and runs a Kafka cluster of 3 nodes there. Terraform creates instances in VPC, which are available from admin IP only. Ansible installs Zookeeper and Kafka through Bastion.


# How to run

Fulfill the following manual steps to prepare local environment to provision infrastructure:

* Create AWS Elastic IP resource for bastion instance and assign its `Allocation Id` to `TF_VAR_ec2_bastion_eip_id` environment variable
* Generate AWS Key Pairs to access EC2 instances with SSH and assign its `Name` to `TF_VAR_ec2_ssh_key_name` environment variable
* Take IP address of your machine and assign it to `TF_VAR_admin_static_ip` environment variable

From `./provision` directory run `terraform apply -auto-approve`, or `make provision`.

To prepar Kafka configuration code move to `./configure` directory and run the following:

* Install `cp-ansible` collection by running `ansible-galaxy install -r requirements.yml`
* Copy `ssh.example.cfg` to `.ssh.cfg` (with `mv ssh.example.cfg .ssh.cfg` for ex.) and replace: `{bastion.example.com}` with bastion public DNS address (can be taken from Terraform output); `{path-to-ec2-ssh-key}` path to created earlier AWS Key Pairs

To run the code execute `make configure` or:

* Ensure Ansible can connect to all the node instances by running `ansible all -m ping`
* Run installation and configuration `ansible-playbook confluent.platform.all --tags=zookeeper,kafka_broker`

After launch is finished successfully, run `kafkacut` to query Kafka metadata from instances:

```
docker run --rm -t confluentinc/cp-kafkacat kafkacat -b {node_public_dns}:9092 -L -J
```

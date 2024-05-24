# Assignment
# Project Name
Assignment-project
## Introduction

mac os 기준으로 작성된 문서입니다.

terraform을 사용하여 eks를 구축하는 github입니다.

## Table of Contents

- [Assignment](#assignment)
- [Project Name](#project-name)
  - [Introduction](#introduction)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Configuration](#configuration)
  - [Usage](#usage)
  - [Directory Structure](#directory-structure)

## Prerequisites

List the software and tools that need to be installed before setting up the project.

- aws-cli install
- terraform install
- kubectl install
- shell scripts

## Installation

Step-by-step instructions to install the project.

1. aws-cli install
    ```bash
    brew install aws-cli
    ```
2. terraform install
    ```bash
    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform
    ```
3. kubectl install(1.29)
    ```bash
    curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.0/2024-01-04/bin/darwin/amd64/kubectl
    curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.0/2024-01-04/bin/darwin/amd64/kubectl.sha256
    openssl sha1 -sha256 kubectl
    chmod +x ./kubectl
    mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
    echo 'export PATH=$HOME/bin:$PATH' >> ~/.bash_profile
    ```

## Configuration

Pre-setup for Terraform on AWS: S3 Bucket and DynamoDB Table with aws-cli

1. Create a S3
    ```plaintext
    aws s3api create-bucket --bucket terraform-state-js-test --region ap-northeast-2 --create-bucket-configuration LocationConstraint=ap-northeast-2
    aws s3api put-bucket-versioning --bucket terraform-state-js-test --versioning-configuration Status=Enabled
    ```
2. Create a DynamoDB
    ```plaintext
    aws dynamodb create-table \
    --table-name terraform-locks \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1
    ```

## Usage

1. **Plan the changes:**
    ```bash
    terraform init
    terraform plan
    ```

    The `terraform plan` command creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure.

2. **Apply the changes:**
    ```bash
    terraform apply
    ```

    The `terraform apply` command executes the actions proposed in a Terraform plan to create, update, or destroy resources.

3. **Destroy the infrastructure:**
    ```bash
    terraform destroy
    ```
## Directory Structure

Explanation of the project's directory structure.

```plaintext
awsinfra/
├── vpc/
|   ├── backend.tf
|   ├── data.tf
|   ├── main.tf
|   ├── outputs.tf
|   └── variables.tf
├── eks-module/
|   ├── backend.tf
|   ├── data.tf
|   ├── main.tf
|   ├── outputs.tf
|   ├── variables.tf
|   └── vpc-cni-iam.json.tmpl
├── eks-manifest-yaml
|   ├── ingress
|       └── ingress.yaml
|   └── Loadbalancer-controller
|       ├── iam-policy.json
|       ├── README.md
|       ├── v2_5_4_full.yaml
|       └── v2_5_4_ingressclass.yaml
|   └── nginx
|       ├── namespace.yaml
|       ├── nginx-deployment.yaml
|       └── nginx-service.yaml
├── .gitignore
└── README.md
```
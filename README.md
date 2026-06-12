# Terraform AWS EC2 Instance Creation

## Objective

Create an AWS EC2 instance using Terraform from Ubuntu terminal and store the project in GitHub.

---

## Prerequisites / Installations

### On Ubuntu

```bash
sudo apt update
sudo apt install unzip git -y
```

### Install Terraform

```bash
wget https://releases.hashicorp.com/terraform/<version>/terraform_<version>_linux_amd64.zip
unzip terraform_*.zip
sudo mv terraform /usr/local/bin/
terraform -version
```

### Install AWS CLI

```bash
sudo apt install awscli -y
aws --version
```

### Configure AWS Credentials

```bash
aws configure
```

Provide:

* AWS Access Key ID
* AWS Secret Access Key
* Region (e.g. us-east-1)
* Output format (json)

---[Get the above keys from AWS UI- Create User - attach policies - give AdminstrationAccess - create access key]

## Step 1: AWS Preparation

### Get AMI ID

AWS Console → EC2 → Launch Instance → Select OS → Copy AMI ID.

Example:

```text
ami-09xxxxxxxxxxxxxx
```

### Create Key Pair

AWS Console → EC2 → Key Pairs → Create Key Pair.
We can select existing key pair or create new key pair in AWS UI. 
Otherwise we can code to put in keypair.tf so that there would be no need of going to ui and get key pair

Create a file called keypair.tf:

resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my_keypair" {
  key_name   = "terraform-key"
  public_key = tls_private_key.my_key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.my_key.private_key_pem
  filename        = "terraform-key.pem"
  file_permission = "0400"
}

Also add this provider in main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }

    tls = {
      source  = "hashicorp/tls"
    }

    local = {
      source  = "hashicorp/local"
    }
  }
}

update resource as this in main.tf

key_name = aws_key_pair.my_keypair.key_name



### Important

The following must be in the SAME REGION:

* AMI
* Key Pair
* Security Group
* EC2 Instance

Example:

```text
us-east-1 (N. Virginia)
```

---

## Step 2: Create Terraform Files

Create project folder: in ubuntu terminal

```bash
mkdir terraform_project1
cd terraform_project1
```

Create files:

```bash
touch main.tf
touch variables.tf
touch outputs.tf
```
check the above 3 file content in repo
---



## Step 3: Initialize Terraform

```bash
terraform init
```

this init will download the below:

* AWS Provider Plugin
* Required Terraform dependencies

---

## Step 5: Validate Configuration

```bash
terraform validate
```

this will checks Terraform syntax and configuration.

---

## Step 6: Review Execution Plan

```bash
terraform plan
```

this will show:

* Resources to be created
* Resources to be modified
* Resources to be destroyed

---

## Step 7: Create Infrastructure

```bash
terraform apply
```

Approve:

```text
yes
```

Terraform creates:

* EC2 Instance
* Security Group

---

## Step 8: Verify Resources

AWS Console → EC2

Verify:

* Instance created
* Security Group attached
* Correct region selected

---

## Step 9: Initialize Git Repository (in ubuntu terminal)

```bash
git init
```

Create .gitignore:

```bash
touch .gitignore or vi .gitignore
```

Example contents:

```text
.terraform/
*.tfstate
*.tfstate.*
terraform.tfvars
crash.log
```

---

## Step 10: Commit Code

```bash
git add .
git commit -m "Initial Terraform AWS EC2 Project"
```

---

## Step 11: Create GitHub Repository

GitHub → New Repository

Example:

```text
terraform_project1
```

Do not initialize with README.

---

## Step 12: Connect Local Repository to GitHub

```bash
git remote add origin https://github.com/<username>/terraform_project1.git
```

Verify:

```bash
git remote -v
```

---

## Step 13: Generate GitHub Token

GitHub Navigation:

Profile → Settings → Developer Settings → Personal Access Tokens → Tokens (Classic)

Create:

* Token Type: Classic
* Scope: repo

Copy token immediately.

---

## Step 14: Push Code to GitHub

```bash
git branch -M main
git push -u origin main
```

When prompted:

Username:

```text
your-github-username
```

Password:

```text
Paste Personal Access Token (PAT)
```

---

## Commands Summary

```bash
terraform init
terraform validate
terraform plan
terraform apply

git init
git add .
git commit -m "Initial Commit"
git remote add origin <repo-url>
git branch -M main
git push -u origin main
```
## Step 15: Destroy Infrastructure

When the project is no longer needed, destroy all resources created by Terraform.

### Review What Will Be Deleted

```bash
terraform plan -destroy
```

This shows all resources that Terraform will remove.

### Destroy Resources

```bash
terraform destroy
```

Approve when prompted:

```text
yes
```

Terraform will delete all resources managed in the state file, such as:

* EC2 Instance
* Security Group
* AWS Key Pair (if created through Terraform)
* Any other Terraform-managed AWS resources

### Verify Deletion

AWS Console → EC2

Check:

* Instances → Instance no longer exists
* Security Groups → Terraform-created SG removed
* Key Pairs → Terraform-created key pair removed

### Important Notes

* Only resources created and managed by Terraform are deleted.
* If a key pair was created manually from the AWS Console and only referenced in Terraform using `key_name`, Terraform will NOT delete it.
* If the key pair was created using Terraform (`aws_key_pair` resource), Terraform will delete it automatically during `terraform destroy`.

### Useful Commands

```bash
terraform plan -destroy
terraform destroy
```

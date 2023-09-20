TERRAFORM_VERSION = 1.2.6

init:
	cp -r ./devops/cd/${ENVIRONMENT}/* .
	terraform init --backend-config=terraform.config -upgrade

plan-to-apply:
	terraform plan -out tfplan.binary
	terraform show -json tfplan.binary > tfplan.json

plan-to-destroy:
	terraform plan -destroy -out tfplan.binary
	terraform show -json tfplan.binary > tfplan.json

apply:
	terraform apply --auto-approve

destroy:
	terraform destroy --auto-approve

install_awscli:
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	unzip awscliv2.zip
	sudo ./aws/install
	rm awscliv2.zip
	rm -rf ./aws

install_terraform:
	wget --quiet https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
	unzip -q terraform_${TERRAFORM_VERSION}_linux_amd64.zip
	sudo mv terraform /usr/local/bin/
	terraform --version
	rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip
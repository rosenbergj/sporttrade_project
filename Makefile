init: clean
	terraform init

plan: clean
	terraform plan -out plan.tfplan -var-file=credentials.tfvars

apply:
	terraform apply plan.tfplan

clean:
	rm plan.tfplan

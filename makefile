all: deploy destroy

deploy:
	cd terraform/ && terraform init -backend-config=./dev/dev.tfbackend -reconfigure && terraform plan -var-file=./dev/dev.tfvars && terraform apply -var-file=./dev/dev.tfvars -auto-approve
destroy:
	cd terraform/ && terraform init -backend-config=./dev/dev.tfbackend -reconfigure && terraform destroy -auto-approve 
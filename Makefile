# Makefile

MAKEFLAGS += -s
.DEFAULT_GOAL := help

export IAC_DIR=iac
export AWS_PROFILE=$(shell echo $(dir) | cut -d'/' -f1 | head -n1)

# --------------------------------------------
#  Terragrunt Targets
# --------------------------------------------

test:
	echo "AWS_PROFILE: $(AWS_PROFILE)"

init: .env ## Runs terragrunt run-all init on given path
	docker compose run --rm terragrunt sh -c "printenv; cd $(dir); terragrunt run-all init"

plan: .env ## Runs terragrunt run-all init on given path
	docker compose run --rm terragrunt sh -c "cd $(dir); terragrunt run-all plan"

apply: .env ## Runs terragrunt run-all init on given path
	docker compose run --rm terragrunt sh -c "cd $(dir); terragrunt run-all apply"

destroy: .env ## Runs terragrunt run-all init on given path
	docker compose run --rm terragrunt sh -c "cd $(dir); terragrunt run-all destroy"

# --------------------------------------------
#  Utility Targets
# --------------------------------------------

clean: ## [WARNING] Removes .env, state and lock files. Local Dev Only
	sudo find $(IAC_DIR)/$(deploy) -name ".terraform.lock.hcl" -type f -exec rm {} \;
	sudo find $(IAC_DIR)/$(deploy) -name "*.terragrunt-cache*" -type d -prune -exec rm -rf {} \;
	sudo find $(IAC_DIR)/$(deploy) -name ".env" -type f -exec rm {} \;

help:
	printf "\nUsage: make [TARGET] dir=path_to_deployment\n\n"
	printf "Makefile Targets:\n\n"
	awk -F':.*##' '/^[^\t].+?:.*##/{printf " \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# --------------------------------------------
#  Envvars Targets
# --------------------------------------------

# Don't want to re-run envvars if .env already ensured. however, if terraform init hasnt been run execute this.
.env:
	if [ ! -f ".env" ]; \
	then \
		touch .env; \
		docker-compose run --rm envvars validate; \
		docker-compose run --rm envvars envfile --overwrite; \
		docker-compose run --rm envvars ensure; \
	fi
.PHONY: .env

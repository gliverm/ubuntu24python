.DEFAULT_GOAL := help

IMAGENAME := hello-world
LINTDIR := app
export PWD=
BLUE='\033[0;34m'
NC='\033[0m' # No Color

#help:  @ List available tasks on this project
help:
	@grep -E '[0-9a-zA-Z\.\-]+:.*?@ .*$$' $(MAKEFILE_LIST)| sort | tr -d '#'  | awk 'BEGIN {FS = ":.*?@ "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


#dev.hadolint: @ Runs static docker linter hadolint 
dev.hadolint:
	@echo "\n${BLUE}Run hadolint ...${NC}\n"
	docker container run --rm -i hadolint/hadolint < Dockerfile

#dev.buildlinter:  @ Build docker image for linting
dev.buildlinter:
	@echo "\n${BLUE}Building Docker image for code linting ...${NC}\n"
	docker build --file Dockerfile --target qa -t ${IMAGENAME}-qa:test .

#dev.buildlinternocache:  @ Build docker image for linting without cache
dev.buildlinternocache:
	@echo "\n${BLUE}Building Docker image for code linting ...${NC}\n"
	docker build --no-cache --file Dockerfile --target qa -t ${IMAGENAME}-qa:test .

#dev.dockerlint:  @ Runs linting in dev docker image
dev.dockerlint:
	@echo "\n${BLUE}Run pylint ...${NC}\n"
	docker run -i --rm -v $$(pwd):/code -w /code ${IMAGENAME}-qa:test pylint --exit-zero --rcfile=setup.cfg ${LINTDIR}
	@echo "\n${BLUE}Run flake8 ...${NC}\n"
	docker run -i --rm -v $$(pwd):/code -w /code ${IMAGENAME}-qa:test flake8 --exit-zero ${LINTDIR}
	@echo "\n${BLUE}Run bandit ...${NC}\n"
	docker run -i --rm -v $$(pwd):/code -w /code ${IMAGENAME}-qa:test bandit -r --ini setup.cfg || true
	@echo "\n${BLUE}Run black format checker ...${NC}\n"
	docker run -i --rm -v $$(pwd):/code -w /code ${IMAGENAME}-qa:test black --check ${LINTDIR}/ || true

# Note to help my future self:
#	Single $ has special meaning in make file.  To make a single $ need two $$.
#	Need that tab to create indentations vs plain ole spaces
#prod.buildapp: @ Build docker image for app
prod.buildapp:
	@echo "\n${BLUE}Building Docker image for ${IMAGENAME} ...${NC}\n"
	docker build --file Dockerfile --target app -t ${IMAGENAME}:app .

#prod.buildappnocache: @ Build docker image for app without cache
prod.buildappnocache:
	@echo "\n${BLUE}Building Docker image for ${IMAGENAME} ...${NC}\n"
	docker build --no-cache --file Dockerfile --target app -t ${IMAGENAME}::app .

#prod.runapp: @ Run app within docker container
prod.runapp:
	@echo "\n${BLUE}Run app within docker container ...${NC}\n"
	docker run -it --rm ${IMAGENAME}:app
.SILENT:
.PHONY: vote metrics

help:
	{ grep --extended-regexp '^[a-zA-Z_-]+:.*#[[:space:]].*$$' $(MAKEFILE_LIST) || true; } \
	| awk 'BEGIN { FS = ":.*#[[:space:]]*" } { printf "\033[1;32m%-15s\033[0m%s\n", $$1, $$2 }'

user-create: # create iam user + access key
	./make.sh user-create

user-destroy: # destroy iam user
	./make.sh user-destroy

ecr-create: # create ecr repository
	./make.sh ecr-create

ecr-run: # run latest image pushed to ecr
	./make.sh ecr-run

ecr-stop: # stop + remove the docker container run with `ecr-run`
	./make.sh ecr-stop

ecr-destroy: # destroy ecr repository
	./make.sh ecr-destroy

vote: # run vote website using npm - dev mode (livereload + nodemon)
	./make.sh vote

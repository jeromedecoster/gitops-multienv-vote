# create ecr repository
ecr-create() {
    if [[ ! -f "$PROJECT_DIR/.env_REPOSITORY_URI" ]]; then
        aws ecr create-repository \
            --repository-name $PROJECT_NAME \
            --query 'repository.repositoryUri' \
            --region $AWS_REGION \
            --profile $AWS_PROFILE \
            --output text \
            2>/dev/null >"$PROJECT_DIR/.env_REPOSITORY_URI"
        info created file .env_REPOSITORY_URI
    fi

    REPOSITORY_URI=$(cat "$PROJECT_DIR/.env_REPOSITORY_URI")
    log REPOSITORY_URI $REPOSITORY_URI
}

ecr-create

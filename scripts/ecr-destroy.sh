# destroy ecr repository
ecr-destroy() {
    aws ecr delete-repository \
        --repository-name $PROJECT_NAME \
        --region $AWS_REGION \
        --profile $AWS_PROFILE \
        2>/dev/null

    rm --force "$PROJECT_DIR/.env_REPOSITORY_URI"
}

ecr-destroy

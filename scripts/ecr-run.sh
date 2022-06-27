ecr-run() {
    if [[ ! -f "$PROJECT_DIR/.env_ACCOUNT_ID" ]];
    then
        aws sts get-caller-identity \
            --query 'Account' \
            --profile $AWS_PROFILE \
            --output text \
            2>/dev/null > "$PROJECT_DIR/.env_ACCOUNT_ID"
    fi
    
    ACCOUNT_ID=$(cat "$PROJECT_DIR/.env_ACCOUNT_ID")
    log ACCOUNT_ID $ACCOUNT_ID

    # add login data into /home/$USER/.docker/config.json (create or update authorization token)
    aws ecr get-login-password \
        --region $AWS_REGION \
        --profile $AWS_PROFILE \
        | docker login \
        --username AWS \
        --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

    # get the first feature repository (so, everything except master branch)
    REPOSITORY_NAME=$(aws ecr describe-repositories \
        --query "repositories[?starts_with(repositoryName, '$PROJECT_NAME-')].[repositoryName]" \
        --output text | \
        head -n 1)
    log REPOSITORY_NAME $REPOSITORY_NAME

    # get the most recent image (if not tag 'latest' available)
    # https://stackoverflow.com/a/49413539
    # IMAGE_TAG=$(aws ecr describe-images \
    #     --repository-name $REPOSITORY_NAME \
    #     --query "sort_by(imageDetails,& imagePushedAt)[-1].imageTags[0]" \
    #     --output text \
    #     2>/dev/null)
    # log IMAGE_TAG $IMAGE_TAG

    REPOSITORY_URI=$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPOSITORY_NAME
    log REPOSITORY_URI $REPOSITORY_URI

    docker run \
        --rm \
        -e WEBSITE_PORT=4000 \
        -p 4000:4000 \
        --name vote \
        $REPOSITORY_URI:latest
}

ecr-run
user-create() {
    if [[ ! -f "$PROJECT_DIR/.env_AWS_ACCESS_KEY_ID" ]]; then
        # https://awscli.amazonaws.com/v2/documentation/api/latest/reference/iam/create-user.html
        aws iam create-user \
            --user-name $PROJECT_NAME \
            --profile $AWS_PROFILE \
            2>/dev/null

        # https://awscli.amazonaws.com/v2/documentation/api/latest/reference/iam/attach-user-policy.html
        aws iam attach-user-policy \
            --user-name $PROJECT_NAME \
            --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess \
            --profile $AWS_PROFILE

        local KEY=$(aws iam create-access-key \
            --user-name $PROJECT_NAME \
            --query 'AccessKey.{AccessKeyId:AccessKeyId,SecretAccessKey:SecretAccessKey}' \
            --profile $AWS_PROFILE \
            2>/dev/null)

        echo "$KEY" |
            jq '.AccessKeyId' --raw-output |
            tr -d '\n' >"$PROJECT_DIR/.env_AWS_ACCESS_KEY_ID"
        info created file .env_AWS_ACCESS_KEY_ID

        echo "$KEY" |
            jq '.SecretAccessKey' --raw-output |
            tr -d '\n' >"$PROJECT_DIR/.env_AWS_SECRET_ACCESS_KEY"
        info created file .env_AWS_SECRET_ACCESS_KEY
    fi

    AWS_ACCESS_KEY_ID=$(cat "$PROJECT_DIR/.env_AWS_ACCESS_KEY_ID")
    log AWS_ACCESS_KEY_ID $AWS_ACCESS_KEY_ID

    AWS_SECRET_ACCESS_KEY=$(cat "$PROJECT_DIR/.env_AWS_SECRET_ACCESS_KEY")
    log AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY
}

user-create

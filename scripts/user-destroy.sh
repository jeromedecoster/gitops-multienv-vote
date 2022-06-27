user-destroy() {
    # detach all attached policies
    POLICIES=$(aws iam list-attached-user-policies \
        --user-name $PROJECT_NAME \
        --query "AttachedPolicies[*].PolicyArn" \
        --output text \
        2>/dev/null)
    for ARN in $POLICIES; do
        log detach user policy $ARN
        # https://awscli.amazonaws.com/v2/documentation/api/latest/reference/iam/detach-user-policy.html
        aws iam detach-user-policy \
            --user-name $PROJECT_NAME \
            --policy-arn $ARN \
            --profile $AWS_PROFILE \
            2>/dev/null
    done

    # https://awscli.amazonaws.com/v2/documentation/api/latest/reference/iam/list-access-keys.html
    ACCESS_KEYS=$(aws iam list-access-keys \
        --user-name $PROJECT_NAME \
        --query "AccessKeyMetadata[*].AccessKeyId" \
        --output text \
        2>/dev/null)
    for KEY_ID in $ACCESS_KEYS; do
        log delete access key $KEY_ID
        # https://awscli.amazonaws.com/v2/documentation/api/latest/reference/iam/delete-access-key.html
        aws iam delete-access-key \
            --user-name $PROJECT_NAME \
            --access-key-id $KEY_ID
    done

    # https://awscli.amazonaws.com/v2/documentation/api/latest/reference/iam/delete-user.html
    aws iam delete-user \
        --user-name $PROJECT_NAME \
        --profile $AWS_PROFILE \
        2>/dev/null

    rm --force "$PROJECT_DIR/.env_AWS_ACCESS_KEY_ID"
    rm --force "$PROJECT_DIR/.env_AWS_SECRET_ACCESS_KEY"
}

user-destroy

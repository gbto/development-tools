#!/bin/bash
# De-register all ECS definitions in a region
# Maintainer: Quentin Gaborit, <gibboneto@gmail.com>
# Syntax: ecr-create-repository.sh [aws region] [aws account id] [repository name]
# Example: /bin/bash .ecs-deregister-tasks-definitions $REGION

get_task_definition_arns() {
    aws ecs list-task-definitions --region $1 |
        jq -M -r '.taskDefinitionArns | .[]'
}

delete_task_definition() {
    local arn=$1
    aws ecs deregister-task-definition \
        --region $1 \
        --task-definition "${arn}" >/dev/null
}

for arn in $(get_task_definition_arns); do
    echo "Deregistering ${arn}..."
    delete_task_definition "${arn}"
done

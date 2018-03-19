#!/usr/bin/env bash
if [ "$APP_BUILD_NAME" ]
then
	echo "Starting to publish : "$APP_BUILD_NAME "build ... "
	export REGISTRY_URI=`aws ecr describe-repositories --repository-names $APP_BUILD_NAME | jq -r '.repositories[0].repositoryUri'`
	if [ ! "$REGISTRY_URI" ]
	then
		echo "Creating new registry on ECS with name "$APP_BUILD_NAME
		aws ecr create-repository --repository-name $APP_BUILD_NAME --region ap-southeast-2
	else
		echo "The registry "$APP_BUILD_NAME" already exists."
		echo "ECR's registry URI: "$REGISTRY_URI
	fi
	echo "Authenticating Docker CLI ... "
	$(aws ecr get-login --no-include-email)
    echo "Publishing docker image to registry ... "
    export DOCKER_IMAGE_ID=$(docker images $APP_BUILD_NAME:$APP_VERSION --format "{{.ID}}" | head -n 1)
    export URI_AND_TAG=$REGISTRY_URI:dev-$APP_GIT_COMMIT_ID
    docker tag $DOCKER_IMAGE_ID $URI_AND_TAG
	docker push $URI_AND_TAG
else
	echo "The build name has not been defined, exiting with error ..."
	exit 1
fi
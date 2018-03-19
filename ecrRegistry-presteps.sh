if [ "$APP_BUILD_NAME" ]
then
	echo "Login Docker CLI ... "
	$(aws ecr get-login --no-include-email)
	echo "Starting to publish : "$APP_BUILD_NAME "build ... "
	export REGISTRY_URI=`aws ecr describe-repositories --repository-names $APP_BUILD_NAME | jq -r '.repositories[0].repositoryUri'`
	if [ ! "$REGISTRY_URI" ]
	then
		echo "Creating new registry on ECS with name "$APP_BUILD_NAME
		aws ecr create-repository --repository-name $APP_BUILD_NAME
	else
		echo "The registry "$APP_BUILD_NAME" already exists."
		echo "ECR's registry URI: "$REGISTRY_URI
	fi
else
	echo "The build name has not been defined, exiting with error ..."
	exit 1
fi

if [ "$ARTIFACT_NAME" ]
then
	echo "Starting to publish : "$ARTIFACT_NAME "artifact ... "
	export REGISTRY_URI=`aws ecr describe-repositories --repository-names $ARTIFACT_NAME | jq -r '.repositories[0].repositoryUri'`
	if [ ! "$REGISTRY_URI" ]
	then
		echo "Creating new registry on ECS with name "$ARTIFACT_NAME
		aws ecr create-repository --repository-name $ARTIFACT_NAME
	else
		echo "The "$ARTIFACT_NAME "already exists."
		echo "ECR's registry URI: "$REGISTRY_URI
	fi
else
	echo "The artifact name has not been defined, exiting with error ..."
	exit 1
fi

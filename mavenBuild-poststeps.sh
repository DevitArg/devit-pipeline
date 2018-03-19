export APP_VERSION=$(docker images $JOB_BASE_NAME --format "{{.Tag}}" | head -n 1)

echo APP_VERSION=$APP_VERSION > parameters.properties
echo APP_BUILD_NAME=$JOB_BASE_NAME >> parameters.properties
echo APP_GIT_COMMIT_ID=$GIT_COMMIT >> parameters.properties

## BUILD PARAMETERS FILE, to be used by downstream process ...
cat parameters.properties
# survival-list

## Server build

Based on https://github.com/knative/docs/tree/3fc620606049c2ccdc3ef071feff862670b4921e/code-samples/community/serving/helloworld-rust and https://cloud.google.com/run/docs/quickstarts/build-and-deploy/deploy-service-other-languages

$ docker build -t bjarkebjarke/survival-list-server .
$ docker push bjarkebjarke/survival-list-server
$ gcloud run deploy

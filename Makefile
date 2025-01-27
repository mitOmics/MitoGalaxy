NAMESPACE=bntfdi
APP=gntfd
TAG=1.0

build:
	docker build --no-cache=true -t ${NAMESPACE}/${APP}:${TAG} .
run:
	docker run --name=${APP} --detach=true ${NAMESPACE}/${APP}:${TAG}
clean:
	docker stop ${APP} && docker rm ${APP}
reset: clean
	docker rmi ${NAMESPACE}/${APP}:${TAG}

prune-images-name:
	docker rmi $(docker images | grep "^<none" | awk '{print $3}')
prune-images-tag:
	docker rmi $(docker images | grep "none" | awk '{print $3}')


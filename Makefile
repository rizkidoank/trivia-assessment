EXECUTABLES = docker helm dgoss
programs := $(foreach exec,$(EXECUTABLES),\
		$(if $(shell which $(exec)),"$(exec): exists\n",$(error "No $(exec) in PATH, please install required programs")))

prerequisites:
	@echo "Checking prerequisites..."
	@echo ${programs}

config:
	@echo "[Docker] Login to Docker..."
	@docker login -u "$(username)"

build-images:
	@echo "[Docker] Building docker images for trivia-backend"
	@docker build -t ${username}/trivia-backend:$$(cat trivia-backend/VERSION) trivia-backend/
	
	@echo "[Docker] Tests docker images for trivia-backend"
	@GOSS_FILE=trivia-backend/goss.yaml dgoss run ${username}/trivia-backend:$$(cat trivia-backend/VERSION)
	
	@echo "[Docker] Building docker images for trivia-frontend"
	@docker build -t ${username}/trivia-frontend:$$(cat trivia-frontend/VERSION) trivia-frontend/	

	@echo "[Docker] Tests docker images for trivia-backend"
	@GOSS_FILE=trivia-frontend/goss.yaml dgoss run ${username}/trivia-frontend:$$(cat trivia-frontend/VERSION)

publish-images:
	@echo "[Docker] Push or publish docker images for trivia-backend"
	@docker push ${username}/trivia-backend:$$(cat trivia-backend/VERSION)
	@echo "[Docker] Push or publish docker images for trivia-frontend"
	@docker push ${username}/trivia-frontend:$$(cat trivia-frontend/VERSION)

docker-images: build-images publish-images


helm-dry-run:
	@helm lint trivia-helm/
	@helm install --dry-run --generate-name --set environment=${environment} trivia-helm/

helm-install:
	@helm upgrade --install ${name} --set environment=${environment} trivia-helm/
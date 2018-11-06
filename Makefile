APP_VERSION ?= 0.9.1

REPOSITORY ?= mumoshu/kube-magic-ip-assigner
TAG ?= $(APP_VERSION)-$(KUBE_VERSION)
IMAGE ?= $(REPOSITORY):$(TAG)

BUILD_ROOT ?= build/$(TAG)
DOCKERFILE ?= $(BUILD_ROOT)/Dockerfile
ROOTFS ?= $(BUILD_ROOT)/rootfs
KUBE_VERSION ?= 1.9.8

.PHONY: build
build: $(DOCKERFILE) $(ROOTFS)
	cd $(BUILD_ROOT) && docker build --build-arg KUBE_VERSION=$(KUBE_VERSION) -t $(IMAGE) .

.PHONY: clean
clean:
	echo Removing $(BUILD_ROOT)...
	rm -rf $(BUILD_ROOT)

publish:
	docker push $(IMAGE) && docker push $(ALIAS)

$(DOCKERFILE): $(BUILD_ROOT)
	cp Dockerfile $(DOCKERFILE)

$(ROOTFS): $(BUILD_ROOT)
	cp -R rootfs $(ROOTFS)

$(BUILD_ROOT):
	mkdir -p $(BUILD_ROOT)

travis-env:
	travis env set DOCKER_EMAIL $(DOCKER_EMAIL)
	travis env set DOCKER_USERNAME $(DOCKER_USERNAME)
	travis env set DOCKER_PASSWORD $(DOCKER_PASSWORD)

test:
	@echo There are no tests available for now. Skipping

docker-run: SELECTOR ?=
docker-run: DELETE ?=
docker-run:
	docker run --rm -it \
	  --privileged \
	  --cap-add NET_ADMIN \
	  --network host \
	  --env-file docker-run-env \
	  -v $(HOME)/.kube/:/root/.kube \
	  -v $(HOME)/.minikube:$(HOME)/.minikube \
	  -e SELECTOR="$(SELECTOR)" \
	  -e DELETE="$(DELETE)" \
	$(IMAGE)

kubectl-run: DOCKER_CMD ?=
kubectl-run: PORT ?= 9200
kubectl-run: SELECTOR ?= app=elastalert
kubectl-run: PROTOCOL ?= tcp
kubectl-run: NAMESPACE ?= kube-system
kubectl-run:
	if kubectl get pod magic-ip-assigner-tester; then \
	  kubectl delete pod magic-ip-assigner-tester; \
	fi
	kubectl run magic-ip-assigner-tester --rm --tty -i --restart=Never \
	  --env PORT="$(PORT)" \
	  --env SELECTOR="$(SELECTOR)" \
	  --env PROTOCOL="$(PROTOCOL)" \
	  --env NAMESPACE="$(NAMESPACE)" \
	  --image $(IMAGE) --command -- $(DOCKER_CMD)

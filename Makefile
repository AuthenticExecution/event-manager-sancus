REPO		?= gianlu33/event-manager-sancus
TAG			?= latest

UART_DEVICE ?= $(shell echo $(DEVICE) | perl -pe 's/(\d+)(?!.*\d+)/$$1+1/e')

build:
	docker build -t $(REPO):$(TAG) .

push:
	docker push $(REPO):$(TAG)

pull:
	docker pull $(REPO):$(TAG)

run: check_port check_device
	docker run -it -p $(PORT):$(PORT) -e PORT=$(PORT) -e DEVICE=$(DEVICE) -e UART_DEVICE=$(UART_DEVICE) --device=$(DEVICE) --device=$(UART_DEVICE) --rm --name event-manager-$(PORT) $(REPO):$(TAG)

login:
	docker login

clean:
	docker rm $(shell docker ps -a -q) 2> /dev/null || true
	docker image prune -f

check_port:
	@test $(PORT) || (echo "PORT variable not defined. Run make <target> PORT=<port>" && return 1)

check_device:
	@test $(DEVICE) || (echo "DEVICE variable not defined. Run make <target> DEVICE=<device>" && return 1)

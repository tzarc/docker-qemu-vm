.PHONY: build

.DEFAULT_TARGET: build

build:
	find -type f -and -not -path '*/.git/*' -exec dos2unix '{}' +
	docker build --tag docker-qemu-vm:latest .

push:
	docker rmi tzarc/qemu-vm:latest || true
	docker build --tag tzarc/qemu-vm:latest .
	docker push tzarc/qemu-vm:latest

test: boot-iso
	touch test-root.qcow2 test-nvram
	docker-compose -f test-docker-compose.yml up

stoptest:
	docker-compose -f test-docker-compose.yml down
	rm test-root.qcow2 test-nvram

boot-iso:
	if [ ! -f ubuntu-server-amd64.iso ] ; then \
		curl -L https://releases.ubuntu.com/20.04.2/ubuntu-20.04.2-live-server-amd64.iso -o ubuntu-server-amd64.iso ; \
	fi

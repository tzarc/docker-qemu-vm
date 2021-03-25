.PHONY: build

.DEFAULT_TARGET: build

build:
	find -type f -and -not -path '*/.git/*' -exec dos2unix '{}' +
	docker build --tag docker-qemu-vm:latest .

push:
	docker rmi tzarc/qemu-vm:latest || true
	docker build --tag tzarc/qemu-vm:latest .
	docker push tzarc/qemu-vm:latest

test: alpine-iso
	touch test-root.qcow2 test-nvram
	docker-compose -f test-docker-compose.yml up

stoptest:
	docker-compose -f test-docker-compose.yml down
	rm test-root.qcow2 test-nvram

alpine-iso:
	if [ ! -f alpine-standard-3.13.3-x86_64.iso ] ; then \
		curl -L https://dl-cdn.alpinelinux.org/alpine/v3.13/releases/x86_64/alpine-standard-3.13.3-x86_64.iso -Oalpine-standard-3.13.3-x86_64.iso ; \
	fi

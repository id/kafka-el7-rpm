.PHONY:	rpm clean source

KAFKA_VERSION ?= 0.8.2.0
SCALA_VERSION ?= 2.10
VERSION = $(shell echo $(KAFKA_VERSION) | sed "s/-/_/")
BUILD_NUMBER ?= 1
SOURCE_NAME = kafka_$(SCALA_VERSION)-$(KAFKA_VERSION)
SOURCE = $(SOURCE_NAME).tgz
TOPDIR = /tmp/kafka-rpm
PWD = $(shell pwd)
URL = $(shell curl -s https://www.apache.org/dyn/closer.cgi/kafka/$(KAFKA_VERSION)/$(SOURCE)?asjson=1 | python -c 'import sys,json; data=json.load(sys.stdin); print data["preferred"] + data["path_info"]')

rpm: source
	@rpmbuild -v -bb \
			--define "version $(VERSION)" \
			--define "build_number $(BUILD_NUMBER)" \
			--define "source $(SOURCE)" \
			--define "source_name $(SOURCE_NAME)" \
			--define "_sourcedir $(PWD)" \
			--define "_rpmdir $(PWD)" \
			--define "_topdir $(TOPDIR)" \
			kafka.spec

clean:
	@rm -rf $(TOPDIR) x86_64
	@rm -f $(SOURCE)

source: $(SOURCE)

$(SOURCE): KEYS $(SOURCE).asc
	@wget -q $(URL)
	gpg --verify $(SOURCE).asc $(SOURCE)

$(SOURCE).asc:
	@wget -q https://dist.apache.org/repos/dist/release/kafka/$(KAFKA_VERSION)/$(SOURCE).asc

KEYS:
	@wget -q https://dist.apache.org/repos/dist/release/kafka/KEYS
	gpg --import KEYS

.PHONY:	rpm clean source

KAFKA_VERSION ?= 2.3.0
SCALA_VERSION ?= 2.12
VERSION = $(shell echo $(KAFKA_VERSION) | sed "s/-/_/")
BUILD_NUMBER ?= 3
BUILD_METRICS ?= 1
SOURCE_NAME = kafka_$(SCALA_VERSION)-$(KAFKA_VERSION)
SOURCE = $(SOURCE_NAME).tgz
TOPDIR = /tmp/kafka-rpm
PWD = $(shell pwd)
URL = $(shell curl -s https://www.apache.org/dyn/closer.cgi/kafka/$(KAFKA_VERSION)/$(SOURCE)?asjson=1 | python -c 'import sys,json; data=json.load(sys.stdin); print data["preferred"] + data["path_info"]')
METRICS_GRAPHITE = metrics-graphite-2.2.0.jar
METRICS_GRAPHITE_URL = http://search.maven.org/remotecontent?filepath=com/yammer/metrics/metrics-graphite/2.2.0/$(METRICS_GRAPHITE)

rpm: source
	@rpmbuild -v -bb \
			--define "version $(VERSION)" \
			--define "build_number $(BUILD_NUMBER)" \
			--define "source $(SOURCE)" \
			--define "source_name $(SOURCE_NAME)" \
			--define "_sourcedir $(PWD)" \
			--define "_rpmdir $(PWD)/RPMS" \
			--define "_topdir $(TOPDIR)" \
			--define "build_with_metrics $(BUILD_METRICS)" \
			kafka.spec

clean:
	@rm -rf $(TOPDIR) x86_64
	@rm -f $(SOURCE) $(SOURCE).asc KEYS $(METRICS_GRAPHITE)

source: $(SOURCE) $(METRICS_GRAPHITE)

$(SOURCE): KEYS $(SOURCE).asc
	@wget -q $(URL)
	gpg --verify $(SOURCE).asc $(SOURCE)

$(SOURCE).asc:
	@wget -q https://dist.apache.org/repos/dist/release/kafka/$(KAFKA_VERSION)/$(SOURCE).asc

KEYS:
	@wget -q https://dist.apache.org/repos/dist/release/kafka/KEYS
	gpg --import KEYS

$(METRICS_GRAPHITE):
		@wget -q $(METRICS_GRAPHITE_URL) -O $(METRICS_GRAPHITE)

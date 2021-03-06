CSC_FLAGS   = -O3
INSTALL_PREFIX ?= /usr/local
PLUGIN_API_PATH = $(INSTALL_PREFIX)/lib/dlaunch/plugin-api

-include build/extra.makefile
build/extra.makefile:
	chicken-builder-init

all: build/dlaunch-plugin-api.import.so
build/dlaunch-plugin-api.import.so: \
  src/dlaunch-plugin-api.scm | build/dlaunch.o
	cd build/ && \
	  csc $(CSC_FLAGS) -J -c ../$< -o ../$(@:%.import.so=%.o) && \
	  csc $(CSC_FLAGS) -dynamic ../$(@:%.so=%.scm) -o ../$@
	rm $(@:%.import.so=%.o) $(@:%.so=%.scm)

.PHONY: install uninstall
install: all
	mkdir -p "$(INSTALL_PREFIX)/bin/"
	mkdir -p "$(PLUGIN_API_PATH)"
	cp build/dlaunch "$(INSTALL_PREFIX)/bin/"
	cp build/dlaunch-plugin-api.import.so "$(PLUGIN_API_PATH)"
	cp $(wildcard build/*.import.scm) "$(PLUGIN_API_PATH)"

uninstall:
	rm "$(INSTALL_PREFIX)/bin/dlaunch"
	rm -rfv "$(PLUGIN_API_PATH)/"
	rmdir --ignore-fail-on-non-empty "$(INSTALL_PREFIX)/bin/" \
	  "$(INSTALL_PREFIX)/lib/dlaunch" "$(INSTALL_PREFIX)/lib/"

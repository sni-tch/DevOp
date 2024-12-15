AUTOMAKE_OPTIONS = foreign
bin_PROGRAMS = program
program_SOURCES = main.cpp Class.cpp Class_H.h
check_PROGRAMS = test
test_SOURCES = test.cpp Class.cpp
PACKAGE = program
VERSION = 1.0
PACKAGE_BUGREPORT = valera.erohovv@gmail.com
CTRLF_DIR = $(CURDIR)/debian
CTRLF_NAME = $(CTRLF_DIR)/control
.PHONY: deb debug
deb:
	mkdir -p deb/DEBIAN
	echo "Package: myprogram" > deb/DEBIAN/control
	echo "Version: 1.0" >> deb/DEBIAN/control
	echo "Section: utils" >> deb/DEBIAN/control
	echo "Priority: optional" >> deb/DEBIAN/control
	echo "Architecture: amd64" >> deb/DEBIAN/control
	echo "Maintainer: Your Name <valera.erohovv@gmail.com>" >> deb/DEBIAN/control
	echo "Description: A short description of the package" >> deb/DEBIAN/control
debug:
	@echo "${PACKAGE}"
	@echo "${VERSION}"
	@echo "${PACKAGE_BUGREPORT}"

check: test
    @./test

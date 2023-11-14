################################################################################
#
# python-pypa-build
#
################################################################################

PYTHON_PYPA_BUILD_VERSION = 1.0.3
PYTHON_PYPA_BUILD_DIR = build-$(PYTHON_PYPA_BUILD_VERSION)
PYTHON_PYPA_BUILD_SOURCE = build-$(PYTHON_PYPA_BUILD_VERSION).tar.gz
PYTHON_PYPA_BUILD_SITE = https://files.pythonhosted.org/packages/98/e3/83a89a9d338317f05a68c86a2bbc9af61235bc55a0c6a749d37598fb2af1

# -----------------------------------------------------------------------------

HOST_PYTHON_PYPA_BUILD_SETUP_TYPE = flit-bootstrap

HOST_PYTHON_PYPA_BUILD_DEPENDENCIES = host-python-packaging host-python-pyproject-hooks

host-python-pypa-build: | $(HOST_DIR)
	$(call host-python-package)

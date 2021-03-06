.PHONY: build dev lint format format-imports test

SKAFFOLD = ./run-k3d.sh && skaffold

VENV_NAME?=.venv
VENV_BIN=$(shell pwd)/${VENV_NAME}/bin
VENV_ACTIVATE=. ${VENV_BIN}/activate
PYTHON=${VENV_BIN}/python3

.PHONY: build
build:
	$(SKAFFOLD) build

.PHONY: dev
dev:
	$(SKAFFOLD) dev --port-forward

venv: $(VENV_NAME)/bin/activate
$(VENV_NAME)/bin/activate: setup.py
	test -d $(VENV_NAME) || virtualenv -p python3 $(VENV_NAME)
	${PYTHON} -m pip install -U pip setuptools
	${PYTHON} -m pip install -e .[devel]
	touch $(VENV_NAME)/bin/activate

lint: venv
	${PYTHON} -m pylint --reports=n helloworld

format: venv
	${PYTHON} -m black -l 79 --py36 helloworld

format-imports: venv
	${PYTHON} -m isort -y -rc helloworld/. tests/.

test: venv
	${PYTHON} -m pytest tests
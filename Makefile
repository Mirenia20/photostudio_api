.PHONY: venv install db test run clean all

PYTHON = python
VENV = .venv
PIP = $(VENV)/bin/pip
PYTEST = $(VENV)/bin/pytest
UVICORN = $(VENV)/bin/uvicorn

all: install db test

venv:
	$(PYTHON) -m venv $(VENV)

install: venv
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt

db:
	./scripts/init-db.sh

test:
	$(PYTEST) -q

run:
	$(UVICORN) app.main:app --reload

clean:
	rm -rf $(VENV)
	rm -f db/photostudio.db
	rm -rf .pytest_cache
	rm -rf __pycache__ app/__pycache__ tests/__pycache__

#! /bin/bash
pipenv install --dev
pipenv run pre-commit install
pipenv run pre-commit autoupdate
# apt-get update && \
#     apt-get upgrade -y && \
#     pipenv run playwright install --with-deps chromium && \
#     apt-get autoremove && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

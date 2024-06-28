# ------------------------------
# Multistage Docker File
# ------------------------------
# ------------------------------
# IMAGE: Target 'base' image
# docker build --file Dockerfile --target base -t app-base .
# docker run -it --rm app-base
# ------------------------------
    ARG UBUNTU_RELEASE=24.04
    FROM ubuntu:${UBUNTU_RELEASE} AS base
    LABEL maintainer="Gayle Livermore <gayle.livermore@gmail.com>"
    ENV LANG="C.UTF-8"
    ENV LC_ALL="C.UTF-8"
    ENV LC_CTYPE="C.UTF-8"
    ENV TZ=America/Chicago
    ENV SHELL=/bin/bash
    RUN chsh -s /bin/bash
    RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
    # hadolint ignore=DL3008
    RUN echo "===> Adding build dependencies..."  && \
        apt-get update && \
        apt-get upgrade -y && \
        apt-get install --no-install-recommends --yes \
        git \
        libfontconfig1 \
        ca-certificates \
        wget \
        curl && \
        apt-get autoremove && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*
    # Basic install of git check
    RUN ["git", "--version"]
    
    # ------------------------------
    # IMAGE: Target 'pythonbase' for base of all images that need Python
    # docker build --file Dockerfile --target pythonbase -t app-pythonbase .
    # docker build --no-cache --file Dockerfile --target pythonbase -t app-pythonbase .
    # docker run -it --rm app-pythonbase
    # ------------------------------
    FROM base AS pythonbase
    # hadolint ignore=DL3008
    RUN echo "===> Adding build dependencies..."  && \
        apt-get update && \
        apt-get upgrade -y && \
        apt-get install --no-install-recommends --yes \
        python3 \
        build-essential \
        openssh-client \
        python3-dev \
        python3-pip \
        python3-pycurl && \
        apt-get autoremove && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*
    ENV PYTHONDONTWRITEBYTECODE 1
    ENV PYTHONUNBUFFERED=1
    # hadolint ignore=DL3013
    RUN echo "===> Installing and Updating package management tools ..." && \
        python3 -m pip config set global.break-system-packages true && \
        python3 -m pip install --no-cache-dir --upgrade --ignore-installed pip && \
        python3 -m pip install --no-cache-dir --upgrade setuptools && \
        python3 -m pip install --no-cache-dir --ignore-installed --upgrade wheel && \
        python3 -m pip install --no-cache-dir --upgrade pyinstaller && \
        python3 -m pip install --no-cache-dir --upgrade pipenv && \
        python3 -m pip list
    
    # ------------------------------
    # IMAGE: Target 'dev' for code development - no Python pkgs loaded
    # docker build --file Dockerfile --target dev -t app-dev .
    # docker run -it --rm app-dev
    # docker container run -it -d -v app:/development -v ~/.ssh:/root/ssh -v ~/.gitconfig:/root/.gitconfig app-dev
    # docker container run -it -v app:/development -v ~/.ssh:/root/ssh -v ~/.gitconfig:/root/.gitconfig app-dev
    # ------------------------------
    FROM pythonbase AS dev
    WORKDIR /
    ARG PROJECT_DIR=/development
    RUN echo "===> creating working directory..."  && \
        mkdir -p $PROJECT_DIR
    WORKDIR $PROJECT_DIR
    
    # ------------------------------
    # IMAGE: Target 'qa' for static code analysis and unit testing
    # Future: Consider benefit lint shell script in addition to below
    # Install the latest static code analysis tools
    # docker build --file Dockerfile --target qa -t app-qa .
    # docker run -it --rm app-qa
    # docker run -it --rm -v ${PWD}:/code hello-world-qa:test sh
    # docker run -it --rm -v ${PWD}:/code hello-world-qa:test 
    # docker run -i --rm -v ${PWD}:/code app-qa pylint --exit-zero --rcfile=setup.cfg **/*.py
    # docker run -i --rm -v ${PWD}:/code app-qa flake8 --exit-zero
    # docker run -i --rm -v ${PWD}:/code app-qa bandit -r --ini setup.cfg
    # docker run -i --rm -v $(pwd):/code -w /code app-qa black --check --exclude app/tests/ app/ || true
    # docker run -i --rm -v ${PWD}:/code app-unittest pytest --with-xunit --xunit-file=pyunit.xml --cover-xml --cover-xml-file=cov.xml app/tests/*.py
    # ------------------------------
    FROM dev AS qa
    WORKDIR /
    COPY Pipfile .
    COPY Pipfile.lock .
    # Ensure linting tools are latest 
    # hadolint ignore=DL3013
    RUN echo "===> Installing python pkgs . . ." && \
        pipenv install --dev --deploy --system && \
        pip install --upgrade --no-cache-dir pylint flake8 bandit black
    WORKDIR /code/
    
    # ------------------------------
    # IMAGE: Target 'builder' builds production app utilizing pipenv
    # docker build --file Dockerfile --target app -t app:app .
    # docker run -it --rm app:app
    # docker run -it --rm app:app sh
    # docker run -it --rm --name app app:app 
    # docker run -it --rm app:app base
    # ------------------------------
    FROM pythonbase as builder
    RUN echo "===> Installing specific python package versions ..."
    WORKDIR /
    COPY Pipfile .
    COPY Pipfile.lock .
    RUN pipenv install --system --deploy
    COPY ./app /app
    RUN echo "===> Building application runtime . . ." && \
        pyinstaller \
            --onefile \
            app/hello_world.py && \
        ls && \
        ls dist/hello_world

# ------------------------------
# IMAGE: Target 'app' for final production app build
# docker build --file Dockerfile --target app -t app:app .
# docker run -it --rm --name app app:app sh
# Using volumnes with a username different than host is problematic: https://github.com/moby/moby/issues/2259
# ------------------------------
FROM base as app
WORKDIR /
RUN echo "===> Install app ..."
COPY --from=builder /dist/hello_world /opt/hello_world
ENV PATH "$PATH:/opt"
CMD ["hello_world"]

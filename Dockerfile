# VERSION: 1.0.0
# DESCRIPTION: GIRTH: Item Response Theory test suite
# BUILD: docker build --rm -t docker-girth-test .
FROM python:3.9-slim-bullseye

LABEL maintainer="Ryan Sanchez <ryan.sanchez@gofactr.com>"

RUN apt-get update && apt-get install -y --no-install-recommends\
  g++ \
  libblas3 \
  liblapack3 \
  liblapack-dev \
  libblas-dev \
  npm \ 
  nodejs \
  && npm install -g configurable-http-proxy \  
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

# Add a user
RUN useradd -ms /bin/bash girthuser

USER girthuser
WORKDIR /home/girthuser

# Copy the requirements
COPY --chown=girthuser:girthuser ./requirements.txt requirements.txt

ENV PYTHONPYCACHEPREFIX="/home/girthuser/.cache/cpython/"
ENV PATH="/home/girthuser/.local/bin:${PATH}"
ENV JUPYTERHUB_SINGLEUSER_APP="jupyter_server.serverapp.ServerApp"

RUN pip install --no-cache-dir --user -r requirements.txt \
  && pip install --no-cache-dir --user jupyterhub jupyterlab \
  && rm requirements.txt \
  && rm -rf .cache

# Get the notebooks
COPY --chown=girthuser:girthuser notebooks notebooks

EXPOSE 8888

# Start JupyterLab
ENTRYPOINT [ "jupyter", "lab", "--port=8888", "--no-browser", "--ip=0.0.0.0"]
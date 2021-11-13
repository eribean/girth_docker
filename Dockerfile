# VERSION: 1.0.0
# DESCRIPTION: GIRTH: Item Response Theory test suite
# BUILD: docker build --rm -t docker-girth-test .
FROM python:3.9-slim-bullseye

RUN pip install --upgrade pip

# Add a user
RUN adduser girthuser

USER girthuser
WORKDIR /home/girthuser

# Copy the requirements
COPY --chown=girthuser:girthuser ./requirements.txt requirements.txt

ENV PATH="/home/girthuser/.local/bin:${PATH}"

RUN pip install --user -r requirements.txt \
  && pip install --user jupyterlab

COPY --chown=girthuser:girthuser . .

EXPOSE 8080

# Start Jupyter la
ENTRYPOINT [ "jupyter", "lab", "--port=8080", "--no-browser", "--ip=0.0.0.0", "--allow-root"]
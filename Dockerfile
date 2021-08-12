FROM ubuntu:latest
WORKDIR /builder
COPY sources ./sources
COPY scripts ./scripts
ENV PATH="$PATH:/builder/scripts"
ENV BUILD_SCRIPTS_DIR /builder
RUN echo 'for s in /builder/sources/*.sh; do . $s; done' >> /root/.bashrc
SHELL ["/bin/bash", "-c"]
COPY ./entrypoint.sh ./
ENTRYPOINT ["/builder/entrypoint.sh"]

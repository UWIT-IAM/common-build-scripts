FROM ubuntu:latest
WORKDIR /builder
COPY sources ./sources
# COPY scripts ./scripts  # TODO: Uncomment when we have scripts
# ENV PATH="$PATH:/builder/scripts"  # TODO: Uncomment when we have scripts
ENV BUILD_SCRIPTS_DIR /builder
RUN echo 'for s in /builder/sources/*.sh; do . $s; done' >> /root/.bashrc
SHELL ["/bin/bash", "-c"]
COPY ./entrypoint.sh ./
ENTRYPOINT ["/builder/entrypoint.sh"]

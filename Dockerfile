FROM quay.io/bgruening/galaxy:20.05
MAINTAINER Fabiano Menegidio <fabiano.menegidio@bioinformatica.com.br>

ENV GALAXY_CONFIG_BRAND="gNTDi"
ENV GALAXY_CONFIG_CONDA_AUTO_INSTALL=True
ENV GALAXY_CONFIG_CONDA_AUTO_INIT=True
ENV ENABLE_TTS_INSTALL=True
ENV PYTHONWARNINGS="ignore:Please.upgrade::pip._internal.cli.base_command"
ENV PYTHONWARNINGS="ignore:DEPRECATION"

ADD config/scripts/postinst.sh /bin/postinst
RUN postinst

COPY config/tools/seed_0.yaml $GALAXY_ROOT/tools_0.yaml

ADD config/galaxy/tool_conf.xml $GALAXY_ROOT/config/
ADD config/galaxy/dependency_resolvers_conf.xml $GALAXY_ROOT/config/

RUN df -h \
    && install-tools $GALAXY_ROOT/tools_0.yaml \
    && /tool_deps/_conda/bin/conda clean --tarballs --yes > /dev/null \
    && rm /export/galaxy-central/ -rf \
    && df -h

ENV ENABLE_FIX_PERMS=1

RUN mkdir -p $GALAXY_ROOT/workflows

VOLUME ["/export/", "/var/lib/docker", "/data/"]

EXPOSE :80
EXPOSE :21
EXPOSE :22
EXPOSE :8800

CMD ["/usr/bin/startup"]

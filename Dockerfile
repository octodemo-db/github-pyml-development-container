FROM continuumio/miniconda3

ARG scripts_dir=/tmp/scripts/
ARG image_url=https://github.com/octodemo-db/github-pyml-development-container
ARG version=1
ARG revision=unknown

# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

COPY ./scripts/* ${scripts_dir}
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && ${scripts_dir}/common-debian.sh "false" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" \
    && /opt/conda/bin/conda env update -f ${scripts_dir}conda_environment.yml \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* ${scripts_dir}

USER vscode

LABEL org.opencontainers.image.authors GitHub Solutions Engineering
LABEL org.opencontainers.image.url $image_url
LABEL org.opencontainers.image.documentation $image_url/README.md
LABEL org.opencontainers.image.source $image_url
LABEL org.opencontainers.image.version $version
LABEL org.opencontainers.image.revision $revision
LABEL org.opencontainers.image.vendor GitHub
LABEL org.opencontainers.image.licenses MIT
LABEL org.opencontainers.image.title GitHub Solutions Engineering Codespaces container for Python ML
LABEL org.opencontainers.image.description Container for Python ML in GitHub Codespaces

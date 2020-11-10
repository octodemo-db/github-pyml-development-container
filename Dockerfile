FROM continuumio/miniconda3

ARG scripts_dir=/tmp/scripts/

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

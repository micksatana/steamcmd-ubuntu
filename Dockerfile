ARG BASE_IMAGE="ubuntu:noble"
# Space-separated locales to be generated. See the full list from /etc/locale.gen
ARG ENABLE_LOCALES="en_US.UTF-8"
ARG UID=1001
ARG USER=steam
ARG GID=1001
ARG GROUP=steam

FROM ${BASE_IMAGE}
ARG ENABLE_LOCALES
ARG UID
ARG USER
ARG GID
ARG GROUP

ENV USER="${USER}"
ENV UID="${UID}"
ENV GROUP="${GROUP}"
ENV GID="${GID}"

RUN apt-get update
RUN echo steam steam/question select "I AGREE" | debconf-set-selections && \
    echo steam steam/license note '' | debconf-set-selections && \
    apt-get install -y steamcmd
RUN apt-get install -y --no-install-recommends \
        ca-certificates \
        iputils-ping \
        tzdata \
        locales \
        golang-go \
    && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

RUN locale-gen ${ENABLE_LOCALES}

RUN go get github.com/itzg/rcon-cli && rcon-cli -h

RUN groupadd "${GROUP}" --gid "${GID}" \
    && useradd "${USER}" --create-home --uid "${UID}" --gid "${GID}" --home-dir /home/${USER}

USER ${USER}

WORKDIR /home/${USER}

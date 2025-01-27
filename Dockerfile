ARG BASE_IMAGE="ubuntu:noble"
ARG RCON_IMAGE="outdead/rcon:latest"
# Space-separated locales to be generated. See the full list from /etc/locale.gen
ARG ENABLE_LOCALES="en_US.UTF-8"
ARG UID=1001
ARG USER=steam
ARG GID=1001
ARG GROUP=steam

FROM ${RCON_IMAGE} AS rcon

FROM ${BASE_IMAGE} as steamcmd

RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        ibsdl2-2.0-0:i386=2.30.0+dfsg-1build3 \
        curl \
    && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/steamcmd

RUN curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

FROM ${BASE_IMAGE}
ARG UID
ARG USER
ARG GID
ARG GROUP
ARG RCON_IMAGE
ARG ENABLE_LOCALES

ENV USER="${USER}"
ENV STEAMDIR="/home/${USER}/.steamcmd"
ENV PATH="${STEAMDIR}:${PATH}"

COPY --from=rcon /rcon /usr/bin/rcon

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        lib32gcc-s1 \
        python3-minimal \
        iputils-ping \
        tzdata \
        locales \
    && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

RUN locale-gen ${ENABLE_LOCALES}

RUN groupadd "${GROUP}" --gid "${GID}" \
    && useradd "${USER}" --create-home --uid "${UID}" --gid "${GID}" --home-dir /home/${USER}

COPY --from=steamcmd --chown=${UID}:${GID} /usr/src/steamcmd/ ${STEAMDIR}
COPY --from=steamcmd [ \
    "/usr/lib/i386-linux-gnu/libthread_db.so.1", \
    "/usr/lib/i386-linux-gnu/libSDL2-2.0.so.0", \
    "/usr/lib/i386-linux-gnu/libSDL2-2.0.so.0.3000.0", \
    "/usr/lib/i386-linux-gnu/" \
]

USER ${USER}

RUN mkdir -p /home/${USER}/.steam/sdk32 /home/${USER}/.steam/sdk64 \
    && ln -s /home/${USER}/.steamcmd/linux32/steamclient.so /home/${USER}/.steam/sdk32/steamclient.so \
    && ln -s /home/${USER}/.steamcmd/linux64/steamclient.so /home/${USER}/.steam/sdk64/steamclient.so

WORKDIR /home/${USER}

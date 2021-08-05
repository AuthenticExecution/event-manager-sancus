FROM python:slim

# Install dependencies

WORKDIR /usr/src/app

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends tzdata \
    && ln -fs /usr/share/zoneinfo/Europe/Brussels /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata \
    && apt-get install -y --no-install-recommends tk screen git \
    && rm -rf /var/lib/apt/lists/*

# Install sancus-loader

COPY bin/ /bin
RUN git clone --depth 1 https://github.com/sancus-tee/sancus-core.git \
    && mv sancus-core/tools tools \
    && rm -rf sancus-core

# Install reactive-uart2ip

RUN git clone --depth 1 https://github.com/AuthenticExecution/reactive-uart2ip.git \
    && pip install reactive-uart2ip/ \
    && rm -rf reactive-uart2ip

# Fetch the event manager binary

RUN git clone --depth 1 https://github.com/AuthenticExecution/env.git \
    && mv env/sancus/reactive.elf . \
    && rm -rf env

# Run
COPY run.sh .
CMD ["./run.sh"]
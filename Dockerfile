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

# Install latest reactive-uart2ip

RUN pip install reactive-uart2ip

# copy the applications

COPY app/ .

# Run

COPY run.sh .
CMD ["./run.sh"]

FROM ubuntu:24.04

ARG PIP_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple
ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_INDEX_URL=${PIP_INDEX_URL}
ENV NEXAU_VENV=/opt/nexau-venv
ENV PATH=${NEXAU_VENV}/bin:${PATH}

RUN sed -i 's|http://ports.ubuntu.com/ubuntu-ports|http://mirrors.ustc.edu.cn/ubuntu-ports|g; s|http://archive.ubuntu.com/ubuntu|http://mirrors.ustc.edu.cn/ubuntu|g; s|http://security.ubuntu.com/ubuntu|http://mirrors.ustc.edu.cn/ubuntu|g; s|https://ports.ubuntu.com/ubuntu-ports|http://mirrors.ustc.edu.cn/ubuntu-ports|g; s|https://archive.ubuntu.com/ubuntu|http://mirrors.ustc.edu.cn/ubuntu|g; s|https://security.ubuntu.com/ubuntu|http://mirrors.ustc.edu.cn/ubuntu|g' /etc/apt/sources.list /etc/apt/sources.list.d/*.sources 2>/dev/null || true
RUN sed -i 's|Components: .*|Components: main universe|g' /etc/apt/sources.list.d/*.sources 2>/dev/null || true

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl git python3 python3-venv python3-pip \
    && rm -rf /var/lib/apt/lists/*

COPY NexAU-harbor.tar.gz /tmp/NexAU-harbor.tar.gz
COPY NexAU-local.tar.gz /tmp/NexAU-local.tar.gz

RUN mkdir -p /tmp/NexAU-harbor /tmp/NexAU-local \
    && tar -xzf /tmp/NexAU-harbor.tar.gz -C /tmp/NexAU-harbor --strip-components=1 \
    && tar -xzf /tmp/NexAU-local.tar.gz -C /tmp/NexAU-local --strip-components=1 \
    && python3 -m venv ${NEXAU_VENV} --clear \
    && . ${NEXAU_VENV}/bin/activate \
    && pip install --upgrade pip \
    && pip install /tmp/NexAU-harbor \
    && pip install /tmp/NexAU-local \
    && pip install e2b uv==0.7.13 pytest==8.4.1 \
    && mkdir -p /root/.local/bin \
    && printf 'export PATH="%s/bin:$PATH"\n' "${NEXAU_VENV}" > /root/.local/bin/env \
    && rm -rf /tmp/NexAU-harbor /tmp/NexAU-local /tmp/*.tar.gz /root/.cache/pip

WORKDIR /app

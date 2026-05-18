FROM ahe-nexau-runtime:local

ARG PIP_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple
ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_INDEX_URL=${PIP_INDEX_URL}
ENV PATH=/opt/nexau-venv/bin:${PATH}

COPY alpine-extended-3.19.0-x86_64.iso /opt/bench-cache/alpine-extended-3.19.0-x86_64.iso
COPY NotoSansSymbols2-Regular.ttf /fonts/noto.ttf

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        asciinema \
        build-essential \
        expect \
        fossil \
        gcc \
        jimsh \
        libgl1 \
        make \
        netcat-openbsd \
        nginx \
        openssh-client \
        openssh-server \
        qemu-system-x86 \
        qemu-utils \
        sshpass \
        stockfish \
        tclsh \
        telnet \
        tmux \
        tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
        cython==3.1.3 \
        flit==3.12.0 \
        numpy==2.3.0 \
        pillow==11.2.1 \
        python-chess==1.2.0 \
        setuptools==80.9.0

RUN git clone -o origin --single-branch https://github.com/bottlepy/bottle.git /opt/bench-cache/bottle \
    && cd /opt/bench-cache/bottle \
    && git reset --hard 0207a34f0c5716cd292dd4480253ad35d3da49f3 \
    && git remote remove origin \
    && git tag -d $(git tag -l) \
    && git reflog expire --expire=now --all \
    && git gc --prune=now --aggressive

RUN git clone --depth 1 --branch 0.5.3 https://github.com/SPOCKnots/pyknotid.git /opt/bench-cache/pyknotid

RUN ln -sf /usr/games/stockfish /usr/local/bin/stockfish

WORKDIR /app

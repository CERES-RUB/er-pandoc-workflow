FROM pandoc/ubuntu-latex:2.9.2.1

WORKDIR /data

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -q --no-allow-insecure-repositories update \
	&& apt-get install --assume-yes --no-install-recommends \
		fonts-sil-charis \
		fonts-sil-charis-compact \
		fonts-freefont-otf \
		fonts-sil-gentiumplus \
		fonts-sil-scheherazade \
		fonts-noto \
		fonts-noto-cjk \
		python3-pip \
		xsltproc \
	&& rm -rf /var/lib/apt/lists/*

RUN pip3 install \
		pandoc-fignos==2.2 \
		pandoc-tablenos==2.1 \
		panflute==1.12

RUN tlmgr option repository ftp://tug.org/historic/systems/texlive/2020/tlnet-final \
    && tlmgr update --self \
    && tlmgr install footmisc \
                     zref \
                     ctex

COPY fonts/NotoSansSyriacEstrangela-Regular.ttf /usr/share/fonts/truetype/
RUN fc-cache

RUN ln -s /usr/bin/python3 /usr/bin/python

COPY . /data
ENTRYPOINT ["/data/compile_md2pdf.sh"]

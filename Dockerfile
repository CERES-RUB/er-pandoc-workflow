FROM pandoc/ubuntu-latex:2.13

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
		pandoc-fignos==2.4.0 \
		pandoc-tablenos==2.3.0 \
		panflute==2.1.0

# Add this once the texlive repo is frozen.
#RUN tlmgr option repository ftp://tug.org/historic/systems/texlive/2021/tlnet-final \
RUN tlmgr update --self \
    && tlmgr install footmisc \
                     zref \
                     ctex

COPY fonts/NotoSansSyriacEstrangela-Regular.ttf /usr/share/fonts/truetype/
RUN fc-cache

COPY . /data
ENTRYPOINT ["/data/compile_md2pdf.sh"]

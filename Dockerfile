#FROM pandoc/latex:3.1-ubuntu
FROM pandoc/latex:edge-ubuntu

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
		panflute==2.3.0

# Add this once the texlive repo is frozen.
#RUN tlmgr option repository ftp://tug.org/historic/systems/texlive/2021/tlnet-final \
RUN tlmgr update --self \
	&& tlmgr install ctex \
					 environ \
					 eso-pic \
					 footmisc \
					 koma-script \
					 luacolor \
					 luatexja \
					 lua-ul \
					 tcolorbox \
					 zref \
					 babel-greek \
					 babel-hebrew \
					 babel-icelandic \
					 babel-indonesian \
					 babel-japanese \
					 babel-latin \
					 babel-malay \
					 babel-russian \
					 babel-thai \
					 babel-turkish \
					 babel-ukrainian \
					 babel-vietnamese \
					 hyphen-ancientgreek \
					 hyphen-arabic \
					 hyphen-armenian \
					 hyphen-chinese \
					 hyphen-churchslavonic \
					 hyphen-coptic \
					 hyphen-ethiopic \
					 hyphen-farsi \
					 hyphen-greek \
					 hyphen-icelandic \
					 hyphen-indic \
					 hyphen-indonesian \
					 hyphen-latin \
					 hyphen-mongolian \
					 hyphen-russian \
					 hyphen-sanskrit \
					 hyphen-thai \
					 hyphen-turkish \
					 hyphen-turkmen \
					 hyphen-ukrainian

COPY fonts/NotoSansSyriacEstrangela-Regular.ttf /usr/share/fonts/truetype/
RUN fc-cache

COPY . /data
ENTRYPOINT ["/data/compile_md2pdf.sh"]

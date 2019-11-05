# Installation

Das neue Template basiert auf [pandoc](http://pandoc.org/). Artikel werden in [Markdown] geschrieben und anschließend mittels LaTeX in ein PDF gesetzt.

Zur Vereinfachung werden einige Skripte genutzt. Daher setzt der Workflow ein laufendes Ubuntu 18.04 voraus. Das kann innerhalb von Windows aktiviert werden.

## Installation von Ubuntu unter Windows

[Dokumentation](https://docs.microsoft.com/en-us/windows/wsl/install-win10)

Nach der Installation kann eine Ubuntu-Shell über das Startmenü aufgerufen werden.

## Installation der erforderlichen Ubuntu-Pakete

In der Ubuntu-Shell müssen zunächst die erforderlichen Ubuntu-Pakete installiert werden:

```bash
sudo apt update
xargs -a packages sudo apt install
```

Anschließend müssen die erforderlichen Python-Pakete installiert werden:

```bash
pip3 install --user -r requirements.txt
```

Nun muss noch pandoc installiert werden:

```bash
wget https://github.com/jgm/pandoc/releases/download/2.7.3/pandoc-2.7.3-1-amd64.deb

sudo dpkg -i pandoc-2.7.3-1-amd64.deb
```

Für die automatische Extraktion der Bibliographie muss zudem [anystyle](https://github.com/inukshuk/anystyle/) installiert werden:

```bash
cat >> ~/.bashrc <<EOF
# Ruby/Gems settings
export GEM_HOME="\${HOME}/.local/lib/gems"
export PATH="\$GEM_HOME/bin:\$PATH"
EOF
source ~/.bashrc

gem install anystyle-cli
```

#!/bin/bash
cat >> ~/.bashrc <<EOF
# Ruby/Gems settings
export GEM_HOME="\${HOME}/.local/lib/gems"
export PATH="\$GEM_HOME/bin:\$PATH"
EOF
source ~/.bashrc

gem install anystyle-cli

#!/bin/bash
cd /usr/local/share/texmf/
wget http://mirror.ctan.org/macros/latex/contrib/footmisc.zip
unzip footmisc.zip
cd footmisc/
latex footmisc.ins && latex footmisc.dtx 
cd ..
mktexlsr

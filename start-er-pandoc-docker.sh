#!/bin/bash
docker build -f Dockerfile-er-pandoc.ilker . -t er:pandoc-2.9.2.1
docker run $* --rm --name er-pandoc -d  -v $(pwd)/../pandoc-workflow/:/data/ -v er-articles:/work -v $(pwd)/../articles:/data/articles/ -ti  er:pandoc-2.9.2.1 tail -f /var/log/alternatives.log

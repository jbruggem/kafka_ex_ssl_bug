#!/bin/bash

cd $(dirname $0)

docker build . -t erlang:21.3.8.1-ingela_anderton_andin_p1-slim

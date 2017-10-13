#!/bin/bash
# git pull

( cd __blddir && \
ifdef(`__windows__', cmake --build . -- /maxcpucount:7, time cmake --build . -- -j7) )

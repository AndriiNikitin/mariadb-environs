#!/bin/bash

( cd __blddir && \
	cmake __srcdir -DPLUGIN_TOKUDB=NO -DCMAKE_BUILD_TYPE=Debug "$@"
)

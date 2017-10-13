#!/bin/bash

( cd __blddir && \
	cmake __srcdir -DPLUGIN_TOKUDB=NO "$@"
)

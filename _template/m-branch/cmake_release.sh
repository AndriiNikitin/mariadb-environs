#!/bin/bash

( cd __blddir && \
	cmake __srcdir -DBUILD_CONFIG=mysql_release -DWITH_READLINE=1 -DPLUGIN_TOKUDB=NO "$@"
)

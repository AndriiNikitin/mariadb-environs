#!/bin/bash
./replant.sh m0-system
_testscript/deploy.sh 10.1 0
_testscript/deploy.sh 10.2 0
_testscript/deploy.sh 10.1.22 0
_testscript/deploy.sh 10.0 0
_testscript/deploy.sh 5.5 0
_testscript/deploy.sh 10.0.30 0
_testscript/deploy.sh 10.1 0
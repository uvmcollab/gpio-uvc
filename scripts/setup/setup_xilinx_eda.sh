#!/usr/bin/env bash

export GIT_ROOT=$(git rev-parse --show-toplevel)
export GPIO_UVC_ROOT="$GIT_ROOT"
export UVM_WORK="$GIT_ROOT/work/uvm"
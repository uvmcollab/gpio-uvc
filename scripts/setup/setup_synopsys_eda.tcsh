#!/usr/bin/env tcsh

setenv GIT_ROOT "`git rev-parse --show-toplevel`"
setenv GPIO_UVC_ROOT "$GIT_ROOT"
setenv UVM_WORK "$GIT_ROOT/work/uvm"

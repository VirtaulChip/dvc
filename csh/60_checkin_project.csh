#!/bin/csh -f
#set verbose=1
set prog = $0:t
if (($1 == "-h") || ($1 == "--help")) then
   echo "Usage: $prog <DESIGN_PHASE>"
   exit -1
endif
echo "======================================================="
echo "TIME: @`date +%Y%m%d_%H%M%S` BEGIN $prog $*"

if ($?DVC_HOME == 0) then
   setenv DVC_HOME $0:h/..
endif
setenv CSH_DIR $DVC_HOME/csh
source $CSH_DIR/12_get_server.csh
source $CSH_DIR/13_get_project.csh

echo "INFO: Checkin Project Design Data : $DESIGN_PROJT"
setenv DVC_PATH ""

source $CSH_DIR/69_checkin_dvc_path.csh

echo "TIME: @`date +%Y%m%d_%H%M%S` END   $prog"
echo "======================================================="

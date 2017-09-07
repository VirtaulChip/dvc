#!/bin/csh -f
set prog = $0:t
if (($1 == "-h") || ($1 == "--help")) then
   echo "Usage: $prog <DESIGN_STAGE>"
   exit -1
endif

if ($?DOP_HOME == 0) then
   setenv DOP_HOME $0:h/../..
endif
setenv CSH_DIR $DOP_HOME/dvc/csh
source $CSH_DIR/12_get_server.csh
source $CSH_DIR/13_get_project.csh
source $CSH_DIR/14_get_version.csh

if (($1 != "") && ($1 != ".")) then
   setenv DESIGN_STAGE $1
   echo "PARM: DESIGN_STAGE = $DESIGN_STAGE"
endif

setenv PROJT_URL $SVN_URL/$DESIGN_PROJT
setenv PHASE_URL $PROJT_URL/$DESIGN_PHASE
setenv BLOCK_URL $PHASE_URL/$DESIGN_BLOCK
setenv STAGE_URL $BLOCK_URL/$DESIGN_STAGE
svn info $STAGE_URL >& /dev/null
if ($status == 1) then
   echo "ERROR: Cannot find Project Design Stage : $DESIGN_STAGE"
   exit 1
endif

#svn info $STAGE_URL
echo "URL: $STAGE_URL"
echo "------------------------------------------------------------"
svn list $STAGE_URL -v

exit 0

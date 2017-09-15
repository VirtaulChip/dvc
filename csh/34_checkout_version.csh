#!/bin/csh -f
#set verbose=1
set prog = $0:t
if (($1 == "") || ($1 == "-h") || ($1 == "--help")) then
   echo "Usage: $prog <DESIGN_VERSN>"
   exit -1
endif
echo "TIME: @`date +%Y%m%d_%H%M%S` BEGIN $prog $*"

if ($?DVC_HOME == 0) then
   setenv DVC_HOME $0:h/..
endif
setenv CSH_DIR $DVC_HOME/csh
source $CSH_DIR/12_get_server.csh
source $CSH_DIR/13_get_project.csh
source $CSH_DIR/04_set_version.csh

setenv PROJT_URL $SVN_URL/$DESIGN_PROJT
setenv PHASE_URL $PROJT_URL/$DESIGN_PHASE
setenv BLOCK_URL $PHASE_URL/$DESIGN_BLOCK
setenv STAGE_URL $BLOCK_URL/$DESIGN_STAGE
setenv VERSN_URL $STAGE_URL/$DESIGN_VERSN

svn info $VERSN_URL >& /dev/null
if ($status == 1) then
   echo "ERROR: Cannot find Project Design Version : $DESIGN_VERSN"
   exit -1
endif

echo "INFO: Checkout Project Design Version : $DESIGN_VERSN"
mkdir -p $CURR_PROJT/$DESIGN_PHASE/$DESIGN_BLOCK/$DESIGN_STAGE/$DESIGN_VERSN

if ($?depth_mode) then
endif

if {(test -e $CURR_PROJT/$DESIGN_PHASE/$DESIGN_BLOCK/$DESIGN_STAGE/$DESIGN_VERSN/.dvc)} then
   svn update --quiet --force $VERSN_URL $CURR_PROJT/$DESIGN_PHASE/$DESIGN_BLOCK/$DESIGN_STAGE/$DESIGN_VERSN --set-depth $depth_mode
   svn update --quiet --force $CURR_PROJT/$DESIGN_PHASE/$DESIGN_BLOCK/$DESIGN_STAGE/$DESIGN_VERSN/.dvc
else
   svn checkout --force $VERSN_URL $CURR_PROJT/$DESIGN_PHASE/$DESIGN_BLOCK/$DESIGN_STAGE/$DESIGN_VERSN --depth $depth_mode
   svn checkout --force $VERSN_URL/.dvc $CURR_PROJT/$DESIGN_PHASE/$DESIGN_BLOCK/$DESIGN_STAGE/$DESIGN_VERSN/.dvc
endif

rm -f $CURR_PROJT/:
rm -f $CURR_PROJT/$DESIGN_PHASE/:
rm -f $CURR_PROJT/$DESIGN_PHASE/$DESIGN_BLOCK/:
rm -f $CURR_PROJT/$DESIGN_PHASE/$DESIGN_BLOCK/$DESIGN_STAGE/:
ln -s $DESIGN_PHASE $CURR_PROJT/:
ln -s $DESIGN_BLOCK $CURR_PROJT/$DESIGN_PHASE/:
ln -s $DESIGN_STAGE $CURR_PROJT/$DESIGN_PHASE/$DESIGN_BLOCK/:
ln -s $DESIGN_VERSN $CURR_PROJT/$DESIGN_PHASE/$DESIGN_BLOCK/$DESIGN_STAGE/:

echo "TIME: @`date +%Y%m%d_%H%M%S` END   $prog"
echo ""
exit 0

#!/bin/csh -f
set prog = $0:t
if (($1 == "") || ($1 == "-h") || ($1 == "--help")) then
   echo "Usage: $prog <DESIGN_PHASE>"
   exit -1
endif
#echo "TIME: @`date +%Y%m%d_%H%M%S` BEGIN $prog $*"

if ($?DVC_HOME == 0) then
   setenv DVC_HOME $0:h/..
endif
setenv CSH_DIR $DVC_HOME/csh
setenv ETC_DIR $DVC_HOME/etc
source $CSH_DIR/12_get_server.csh
source $CSH_DIR/13_get_project.csh
source $CSH_DIR/14_get_version.csh

if ($1 != "") then
   setenv DESIGN_PHASE $1
   $CSH_DIR/00_set_env.csh --quiet DESIGN_PHASE $DESIGN_PHASE
endif

setenv PROJT_URL $SVN_URL/$DESIGN_PROJT
setenv PHASE_URL $PROJT_URL/$DESIGN_PHASE
svn info $PHASE_URL >& /dev/null
if ($status == 0) then
   echo "INFO: Exist Project Design Phase : $DESIGN_PHASE"
   if ($?info_mode) then
      svn info $PHASE_URL
   endif
else

#=========================================================
echo "INFO: Create Project Design Phase : $DESIGN_PHASE"
svn mkdir --quiet $PHASE_URL -m "Create Design Phase $DESIGN_PHASE ..." --parents
svn mkdir --quiet $PHASE_URL/.dvc -m "Design Platform Config Directory" --parents

set tmpfile=`mktemp`
echo -n "" > $tmpfile
echo "/$DESIGN_PHASE" > $tmpfile
svn import --quiet $tmpfile $PROJT_URL/.dvc/PHASE -m 'Project Phase Name'
rm -f $tmpfile

set readme=`mktemp`
echo -n "" > $readme
echo "# Design Version Control Directory" >> $readme
echo "=======================================" >> $readme
echo "* Project : $DESIGN_PROJT" >> $readme
echo "* Phase   : $DESIGN_PHASE" >> $readme
echo "* Path    : /$DESIGN_PHASE/" >> $readme
echo "* Author  : $USER" >> $readme
echo "* Date    : `date +%Y%m%d_%H%M%S`" >> $readme
echo "=======================================" >> $readme

svn import --quiet $readme $PHASE_URL/.dvc/README -m 'Initial Design Phase Directory'
rm -fr $readme
#=========================================================

endif

#echo "TIME: @`date +%Y%m%d_%H%M%S` END   $prog"
echo ""
exit 0

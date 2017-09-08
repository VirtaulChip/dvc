#!/bin/csh -f
#set verbose=1
set prog = $0:t
if (($1 == "") || ($1 == "-h") || ($1 == "--help")) then
   echo "Usage: $prog <DESIGN_CONTR> <SRC_FILE> <DEST_NAME>"
   exit -1
endif

if ($?DVC_HOME == 0) then
   setenv DVC_HOME $0:h/..
endif
setenv CSH_DIR $DVC_HOME/csh
source $CSH_DIR/12_get_server.csh
source $CSH_DIR/13_get_project.csh
source $CSH_DIR/14_get_version.csh
source $CSH_DIR/15_get_container.csh
if ($2 != "") then
    set src_name = $2
    set dst_name = $2:t
    if ($3 != "") then
        set dst_name = $3
    endif
    if {(test -d $DVC_CONTAINER/$dst_name)} then
       if {(test -d $src_name)} then
          # if both src and dest are directory, remove dest directory first
          rm -fr $DVC_CONTAINER/$dst_name
          cp -r $src_name $DVC_CONTAINER/$dst_name
       else if {(test -e $src_name)} then
          cp -r $src_name $DVC_CONTAINER/$dst_name
       endif
    else
       rm -fr $DVC_CONTAINER/$dst_name
       cp -fr $src_name $DVC_CONTAINER/$dst_name
    endif 
    (cd $DVC_CONTAINER; svn add $dst_name --force)
endif


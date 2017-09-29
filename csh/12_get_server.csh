#!/bin/csh -f
#set verbose = 1
set prog = $0:t
if (($1 == "-h") || ($1 == "--help")) then
   echo "Usage: $prog [-v]"
   exit -1
endif
if (($1 == "-v") || ($1 == "--verbose")) then
   set verbose_mode = 1
   shift argv
endif

if ($1 == "--info") then
   set info_mode = 1
   shift argv
endif

if ($1 == "--recursive") then
   set recursive_mode = 1
   set depth_mode = infinity
   shift argv
endif

switch($1)
case "--infinity":
   set depth_mode = infinity
   shift argv
   breaksw
cace "--empty":
   set depth_mode = empty
   shift argv
   breaksw
case "--files":
   set depth_mode = files
   shift argv
   breaksw
case "--immediates":
   set depth_mode = immediates
   shift argv
   breaksw
case "--depth")) then
   shift argv
   set depth_mode = $1
   shift argv
   breaksw
endsw

if ($1 == "--xml") then
   set xml_mode = 1
   shift argv
endif

if ($?SVN_ROOT == 0) then
   if {(test -e .dop/env/SVN_ROOT)} then
      setenv SVN_ROOT  `cat .dop/env/SVN_ROOT`
   else
      setenv SVN_ROOT  $HOME/SVN_ROOT
   endif
endif

if ($?SVN_MODE == 0) then
   if {(test -f $SVN_ROOT/.dop/env/SVN_MODE)} then
     setenv SVN_MODE      `cat $SVN_ROOT/.dop/env/SVN_MODE`
   else
     setenv SVN_MODE      file
   endif
endif

if ($?SVN_HOST == 0) then
   if {(test -f $SVN_ROOT/.dop/env/SVN_HOST)} then
     setenv SVN_HOST      `cat $SVN_ROOT/.dop/env/SVN_HOST`
   else
     setenv SVN_HOST      `hostname`
   endif
endif

if ($?SVN_PORT == 0) then
   if {(test -f $SVN_ROOT/.dop/env/SVN_PORT)} then
     setenv SVN_PORT      `cat $SVN_ROOT/.dop/env/SVN_PORT`
   else
     setenv SVN_PORT      3690
   endif
endif

if ($?SVN_URL == 0) then
   if {(test -f $SVN_ROOT/.dop/env/SVN_URL)} then
     setenv SVN_URL      `cat $SVN_ROOT/.dop/env/SVN_URL`
   else if ($SVN_MODE == "svn") then
      setenv SVN_URL "svn://$SVN_HOST"":$SVN_PORT/"
   else
      setenv SVN_URL "file://$SVN_ROOT"
   endif
endif

if ($?info_mode) then
  echo "INFO: SVN_ROOT = $SVN_ROOT"
  echo "INFO: SVN_MODE = $SVN_MODE"
  echo "INFO: SVN_HOST = $SVN_HOST"
  echo "INFO: SVN_PORT = $SVN_PORT"
  echo "INFO: SVN_URL  = $SVN_URL"
endif


if {(test -e $SVN_ROOT/.dop/env/PTR_PHASE)} then
  setenv PTR_PHASE `cat $SVN_ROOT/.dop/env/PTR_PHASE`
else if ($?PTR_PHASE == 0) then
  setenv PTR_PHASE :phase
endif

if {(test -e $SVN_ROOT/.dop/env/PTR_BLOCK)} then
  setenv PTR_BLOCK `cat $SVN_ROOT/.dop/env/PTR_BLOCK`
else if ($?PTR_BLOCK == 0) then
  setenv PTR_BLOCK :block
endif

if {(test -e $SVN_ROOT/.dop/env/PTR_STAGE)} then
  setenv PTR_STAGE `cat $SVN_ROOT/.dop/env/PTR_STAGE`
else if ($?PTR_STAGE == 0) then
  setenv PTR_STAGE :stage
endif

if {(test -e $SVN_ROOT/.dop/env/PTR_VERSN)} then
  setenv PTR_VERSN `cat $SVN_ROOT/.dop/env/PTR_VERSN`
else if ($?PTR_VERSN == 0) then
  setenv PTR_VERSN :version
endif

if {(test -e $SVN_ROOT/.dop/env/PTR_VERSN)} then
  setenv PTR_CONTR `cat $SVN_ROOT/.dop/env/PTR_CONTR`
else if ($?PTR_CONTR == 0) then
  setenv PTR_CONTR :container
endif

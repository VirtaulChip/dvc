# Design Version Control V2018_1107a

## Version Control Engine -- Subversion

- The SVN server is initialized withthe following parameters:

	  $SVN_ROOT : svn repository root path, need to be set first
	
	  $SVN_MODE : svn | file -- server db access mode
	  $SVN_HOST : server host name -- only been used in svn server mode
	  $SVN_PORT : server port name -- only been used in svn server mode
  
- When a project is createed, there will be one repository under:

	  $SVN_ROOT/<project_name>/

- Project config files are copied from $DVC_HOME/etc/conf/:

	  $SVN_ROOT/<project_name>/conf/
      

## Design Database Directory Structure

- Under project respository, there are 4 levels of design version directories 

[Directory]:

	$DESIGN_PROJT/		(Project Repository Root)

		$DESIGN_PHASE/
			$DESIGN_BLOCK/
				$DESIGN_STAGE/
					$DESIGN_VERSN/


Phase Name (defined by project manager):

	P1-trial , P2-stable, P3-final, P4-tapeout, ...

Block Name (defined by design manager):

	chip, cpu, gpu, ddr, sub1, ...

Stage Name (defined based on tool execution flow):

	000-DATA,	100-CIRCUIT,	200-LOGIC,	300-DFT,
	400-APR,	500-SIGNOFF,	600-TAPEOUT,	700-TESTING,
	800-PACKAGE,	900-SYSTEM

Version Name (defined by designer, recommend to follow the same convention):  

	<DBSRC_DATE>-<DBDST_WEEK>-<REMARK>
	170910-ww38-ftp
	170910-ww39-scan
	170910-ww40-apr
	170910-ww42-eco

***
## Execution Flow:

### 0. Download DVC package and Create unix environment setup script (Run Once):

Example:

	;######################################################
	;## run the following step once                      ##
	;## install DVC package in /tools/icdop              ##
	;######################################################

	% cd /too/icdop/
	% git clone https://github.com/icdop/dvc.git
	% cd dvc/
	% /tools/icdop/dvc/setup.cshrc

	=> create CSHRC.dvc under /tools/icdop/dvc/ directory

	;######################################################
	;## source the CSHRC.dvc to acces the DVC utility    ##
	;######################################################

	% source /tools/icdop/dvc/CSHRC.dvc

		DVC_HOME = /tools/icdop/dvc


### 1. Create project account and root directory

Example:

	- Project Root Directory
	
		PROJ_ROOT = /project/N13301A
		
	- Project Central Data Directory 

		$PROJ_ROOT/techlib/		: n13301uc0
		$PROJ_ROOT/design/		: n13301ud0
		$PROJ_ROOT/flow/		: n13301uc0
		$PROJ_ROOT/svn/			: n13301ua0

	- Project User Working Directory 
	
		$PROJ_ROOT/users/n13301ua0/	: n13301ua0
		$PROJ_ROOT/users/n13301ub0/	: n13301ub0
		$PROJ_ROOT/users/n13301ub1/	: n13301ub1
		....

### 2. Initialize project specific svn file server (Run If Needed)  - CAD/IT

Step-2.1:

	;######################################################
	;## create project specific CSHRC.dvc                ##
	;######################################################

	% cp $DVC_HOME/CSHRC.dvc  $PROJ_ROOT/flow
	% echo 'setnev PROJ_ROOT /projects/N13301A' >> CSHRC.dvc
	% echo 'setenv SVN_ROOT  $PROJ_ROOT/svn'    >> CSHRC.dvc
	% echo 'setenv SVN_MODE  svn'               >> CSHRC.dvc
	% echo 'setenv SVN_HOST  icdop_server'      >> CSHRC.dvc
        % echo 'setenv SVN_PORT  3690'              >> CSHRC.dvc


Step-2.2:

	;######################################################
	;## source the CSHRC.dvc to acces the DVC utility    ##
	;######################################################

	% source $PROJ_ROOT/flow/CSHRC.dvc


	;######################################################
	;## Init SVN DB with file access mode                ##
	;## (only svnadmin can init file server db)          ##
	;######################################################

	% dvc_init_server \
		--root $PROJ_ROOT/svn \
		--mode file


	;######################################################
	;## dvc_create_project   <proj_id>                   ##
	;######################################################

	% dvc_create_project N11301A


	;######################################################
	;## Start SVN server for other members to use        ##
	;## % dvc_init_server \                              ##
	;##	--root $SVN_ROOT \                           ##
	;##	--mode $SVN_MODE \                           ##
	;##	--host $SVN_HOST -port $SVN_PORT             ##
	;######################################################

	% dvc_init_server \
		--root $PROJ_ROOT/svn \
		--mode svn \
		--host localhost -port 3690


### 3. Create design folder for members - Technical Lead

Example:

	;######################################################
	;## source the CSHRC.dvc to acces the DVC utility    ##
	;######################################################

	% source /projects/N11301A/flow/CSHRC.dvc

	;######################################################
	;## dvc_create_project   <proj_name>                 ##
	;######################################################

	% dvc_create_project N11301A

	;######################################################
	;## dvc_create_folder   <phase>/<block>/<stage>/<version>
	;######################################################

	% dvc_create_folder   P1-trial/block1/000-DATA/170910-ww38-place


### 4. Checkin design data into design folder - Designer

Example:

	;######################################################
	;## source the CSHRC.dvc to acces the DVC utility    ##
	;######################################################

	% source /projects/N11301A/flow/CSHRC.dvc

	;######################################################
	;## dvc_checkout_project   <proj_name> [<dest_path>] ##
	;######################################################
	% dvc_checkout_project N11301A _

	% dvc_checkout_folder P1-trial/block1/000-DATA/170910-ww38-place

	% dvc_copy_object /some_rundir_path/design.v       design.v
	% dvc_link_object /some_rundir_path/design.spef.gz design.spef.gz

	% dvc_list_folder --recursive

	% dvc_checkin_folder



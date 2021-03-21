###############################################################
#######   terminal settings   #################################
###############################################################

echo "set printing commands"
set -x

# exit script if error
echo "set exit script if error"
set -e

###############################################################
#######   Define variables   ##################################
###############################################################
# create release
DEV_BRANCH=dev
MILESTONE_BRANCH=milestone
RELASE_BRANCH=main

WORK_DIR=$1
CALL_FUNCTION=$2

###############################################################
#######   FUNCTIONS   #########################################
###############################################################

test () {
    echo "test run release in $WORK_DIR"
    exit 0
}

###############################################################
#######   MAIN PROCESS   ######################################
###############################################################

# run a function if a name is passed
$CALL_FUNCTION

echo "START RELEASE PROCESS"
echo 
echo "change directory to $WORK_DIR"
cd $WORK_DIR

CURRENT_DIR=$PWD

echo "the working dirrectory is $CURRENT_DIR"

echo "stash all uncommitted changes"
git add . && git stash

echo "switch branch to $MILESTONE_BRANCH and pull changes from server"
git checkout $MILESTONE_BRANCH && git pull -p -r

# TODO: remove snapshots

echo "switch branch to $RELASE_BRANCH and pull changes from server"
git checkout $RELASE_BRANCH && git pull -p -r

echo "merge $MILESTONE_BRANCH into $RELASE_BRANCH"
git merge --no-ff --no-commit -s recursive -X theirs $MILESTONE_BRANCH 


echo "RELEASE PROCESS WAS FINISHED"

###############################################################

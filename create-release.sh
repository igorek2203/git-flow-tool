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
RELEASE_BRANCH=main

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

echo "switch branch to $RELEASE_BRANCH and pull changes from server"
git checkout $RELEASE_BRANCH && git pull -p -r

echo "merge $MILESTONE_BRANCH into $RELEASE_BRANCH"
git merge --no-ff --no-commit -s recursive -X theirs $MILESTONE_BRANCH 

# TODO: remove all snapshots
mvn versions:set -DremoveSnapshot
mvn versions:use-releases
mvn versions:update-properties -DallowIncrementalUpdates=false -DallowMajorUpdates=false -DallowMinorUpdates=false

echo "get new project version"
PROJECT_VERSION_NEW=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)

echo "commit release"
git commit -m"release ${PROJECT_VERSION_NEW}" && git push

echo "RELEASE PROCESS WAS FINISHED"

###############################################################

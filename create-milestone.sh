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
# create milestone
DEV_BRANCH=dev
MILESTONE_BRANCH=milestone

WORK_DIR=$1
CALL_FUNCTION=$2

###############################################################
#######   FUNCTIONS   #########################################
###############################################################

test () {
    echo "test run milestone in $WORK_DIR"
    exit 0
}

###############################################################
#######   MAIN PROCESS   ######################################
###############################################################

# run a function if a name is passed
$CALL_FUNCTION

echo "START MILESTONE PROCESS"
echo 
echo "change directory to $WORK_DIR"
cd $WORK_DIR

CURRENT_DIR=$PWD

echo "the working dirrectory is $CURRENT_DIR"

echo "stash all uncommitted changes"
git add . && git stash

echo "switch branch to $DEV_BRANCH and pull changes from server"
git checkout $DEV_BRANCH && git pull -p -r

echo "remove origin $MILESTONE_BRANCH if exists"
[ ! -z $(git branch -a | grep "remotes/origin/$MILESTONE_BRANCH" || true) ] && git push -f -d origin $MILESTONE_BRANCH

echo "remove local $MILESTONE_BRANCH if exists"
[ ! -z $(git branch | grep "$MILESTONE_BRANCH" || true) ] && git branch -D $MILESTONE_BRANCH

echo "create a new $MILESTONE_BRANCH and push it"
git checkout -b $MILESTONE_BRANCH && git push -u origin $MILESTONE_BRANCH

echo "switch branch to $DEV_BRANCH"
git checkout $DEV_BRANCH

echo "get old project version"
PROJECT_VERSION_OLD=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)

echo "set the next minor version"
mvn build-helper:parse-version versions:set \
    -DnewVersion=\${parsedVersion.majorVersion}.\${parsedVersion.nextMinorVersion}.\${parsedVersion.incrementalVersion}\${parsedVersion.qualifier?} \
    versions:commit

echo "get current project version"
PROJECT_VERSION_CURRENT=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)

echo "commit version changes"
git add pom.xml && git commit -m"Change the project version ${PROJECT_VERSION_OLD} => ${PROJECT_VERSION_CURRENT}" && git push

echo "MILESTONE PROCESS WAS FINISHED"


###############################################################


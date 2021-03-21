###############################################################
#######   Define variables   ##################################
###############################################################

TEST=test
PROCESS_NAME=$1

#/home/igor/Documents/projects/personal/test-milestone-release
WORK_DIR=/home/igor/Documents/projects/personal/test-milestone-release #$2

# list of projects directories
declare -a PROJECTS=("test-release-repo-1" "test-release-repo-2" "test-release-repo-3")

###############################################################
#######   FUNCTIONS   #########################################  
###############################################################

milestone () {
    local WORK_DIR=$1
    echo "run milestone in $WORK_DIR"
    ./create-milestone.sh $WORK_DIR $TEST > "$WORK_DIR/milestone_process.log"
}

release () {
    local WORK_DIR=$1
    echo "run release in $WORK_DIR"
    ./create-release.sh $WORK_DIR $TEST > "$WORK_DIR/release_process.log"
}

###############################################################
#######   MAIN PROCESS   ######################################
###############################################################

echo "START PROCESS $PROCESS_NAME"

## now loop through the above array
for i in "${PROJECTS[@]}"
do
    if [ -d "$WORK_DIR/$i" ]; then
        $PROCESS_NAME "$WORK_DIR/$i"
    fi
done

echo "FINISH PROCESS $PROCESS_NAME"


###############################################################

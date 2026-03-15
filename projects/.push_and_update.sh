# ASSERT: must be at correct project directory dept (right now it is 6)
depth=$(pwd | awk -F/ '{print NF}') # split by / and count number of fields
required_depth=6
if [ "$depth" != "$required_depth" ]; then
    echo "need to be in /home/projects/<language>/<project-name>/ to setup remote"
    exit 1
fi

# ASSERT: git must be clean
if ! git diff-index --quiet HEAD --; then
    echo "need to make first commit to setup remote"
    exit 1
fi


PROJECT_DIR="$(basename "$(dirname "$PWD")")/$(basename "$PWD")"
WIN_WORKING_DIR="$WINHOME_DIR/projects/$PROJECT_DIR"

git push
git -C "$WIN_WORKING_DIR" pull
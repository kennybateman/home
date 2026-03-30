# ASSERT: must be at correct project directory dept (right now it is 6)
depth=$(pwd | awk -F/ '{print NF}') # split by / and count number of fields
required_depth=6
if [ "$depth" != "$required_depth" ]; then
    echo "need to be in /home/projects/<language>/<project-name>/ to setup remote"
    exit 1
fi

# ASSERT: must have made first commit
if ! git diff-index --quiet HEAD --; then
    echo "need to make first commit to setup remote"
    exit 1
fi

PROJECT_DIR="$(basename "$(dirname "$PWD")")/$(basename "$PWD")"
REMOTE_DIR="$WINHOME/remotes/$PROJECT_DIR"
WIN_WORKING_DIR="$WINHOME/projects/$PROJECT_DIR"
WORKING_DIR="$HOME/projects/$PROJECT_DIR"

# setup remote repo on windows...
git init --bare "$REMOTE_DIR.git" # remote, not a repo

# add that repo to the working project
git remote add winrepo "$REMOTE_DIR.git"

# first push needs to set upstream (good reason to require first commit)
git push --set-upstream winrepo main

# make a windows clone so we can view stuff on windows...
git clone "$REMOTE_DIR.git" "$WIN_WORKING_DIR"

exit 0
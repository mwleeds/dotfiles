#!/bin/bash
# Usage: clone_all_repos.sh [organization] <output directory>

ORG=$1
PER_PAGE=100
GIT_OUTPUT_DIRECTORY=${2:-"/tmp/${ORG}_repos"}

if [ -z "$GITHUB_TOKEN" ]; then
    echo -e "Variable GITHUB_TOKEN isn't set! Please specify your GitHub token.\n\nMore info: https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/"
    exit 1
fi

if [ -z "$ORG" ]; then
    echo "Variable ORG isn't set! Please specify the GitHub organization."
    exit 1
fi

mkdir -p $GIT_OUTPUT_DIRECTORY
echo "Cloning repos in $ORG to $GIT_OUTPUT_DIRECTORY/..."

for ((PAGE=1; ; PAGE+=1)); do
    REPO_COUNT=0
    ERROR=0

    while read REPO_NAME ; do
        ((REPO_COUNT++))
        echo -n "Cloning $REPO_NAME to $GIT_OUTPUT_DIRECTORY/$REPONAME... "

        git clone https://github.com/$ORG/$REPO_NAME.git $GIT_OUTPUT_DIRECTORY/$REPO_NAME >/dev/null 2>&1 ||
            { echo -e "ERROR: Unable to clone!" ; ERROR=1 ; continue ; }
        echo "done"
    done < <(curl -u :$GITHUB_TOKEN -s "https://api.github.com/orgs/$ORG/repos?per_page=$PER_PAGE&page=$PAGE" | jq -r ".[]|.name")

    if [ $ERROR -eq 1 ] ; then exit 1 ; fi
    if [ $REPO_COUNT -ne $PER_PAGE ] ; then exit 0 ; fi
done
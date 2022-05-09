#!/bin/bash
# This scripts scans a repository
# Maintainer: Quentin Gaborit, <gibboneto@gmail.com>
# Syntax: ./sqlfluff-formatter.sh [directory]

if [[ -z $1 ]]; then
    DIRECTORY=$(git rev-parse --show-toplevel)
    echo "The formatting git hook will run from $DIRECTORY"
fi

SQLFLUFF_HELPER_PATH="$DIRECTORY/sqlfluff/sqlfluff_helper.py"
SQLFLUFF_CONFIG_PATH="$DIRECTORY/sqlfluff/.sqlfluff"

# look for sqlfluff package
if [[ $(sqlfluff --version) ]]; then
    echo "Found $(sqlfluff --version)."
else
    echo "ERROR: Couldn't find the SQLFluff package. Please install it with 'pip install sqlfluff' command and try again."
    exit 1
fi

# list potential .sql changes
declare -a changedFiles=($(git ls-files --other --exclude-standard))
declare -a sqlScripts=()
for x in "${changedFiles[@]}"; do
    if [[ $x =~ .*\.(sql$|sql.j2$|ddl$|dml$) ]]; then
        sqlScripts+=($x)
    fi
done

# parse the sql scripts (if any)
if [[ ${#sqlScripts[@]} -le 0 ]]; then
    echo ">> Found ${#sqlScripts[@]} .sql script(s) in the changes list. Exiting formatting script."
    exit 0
else
    echo ">> Found ${#sqlScripts[@]} .sql script(s) in the changes list. Proceeding to formatting script."
    # check if .sqlfluff config files exists
    if test -f $SQLFLUFF_CONFIG_PATH; then
        echo ">> Existing .sqlfluff configuration found in $DIRECTORY. The current configuration will be updated."
    else
        echo ">> Couldn't locate .sqlfluff configuration in $DIRECTORY"
        echo ">> Try to re-download the sqlfluff archive from the data-engineering repository."
        exit 1
    fi
    # check if sqlfluff_helper.py exists
    if test -f $SQLFLUFF_HELPER_PATH; then
        echo ">> Existing sqlfluff_helper.py script found in $DIRECTORY"
        echo ">> The current file will be used to update the .sqlfluff config."
    else
        echo ">> Couldn't locate sqlfluff_helper.py script in $DIRECTORY"
        echo ">> Try to re-download the sqlfluff archive from the data-engineering repository."
        exit 1
    fi

    # run python helper to update the .sqlfluff config files
    python3 $SQLFLUFF_HELPER_PATH

    # apply formatting to each of the changed sql script
    echo ">> The modified .sql scripts will be formatted with sqlfluff:"
    for changedSQLFile in "${sqlScripts[@]}"; do
        echo $changedSQLFile
        sqlfluff fix -f -vv $changedSQLFile
    done
fi

exit 0

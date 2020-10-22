#!/bin/sh
 
# get all merged branch
branches=$(git branch --merged master | grep -v '^[ *]*master$')
 
# define colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
LIGHT_GRAY='\e[90m'
NC='\033[0m'
 
# if no branches are need to clear, just exit
if [ -z "$branches" ]
then
	echo "${GREEN}No merged branches to remove${NC}"
	exit 0
fi
 
# delete each merged branch
for branch in $branches
do
	echo "${LIGHT_GRAY}Deleting merged branch - ${YELLOW}${branch}${NC}"
	git branch -d $branch
done
 
echo "${GREEN}Done!"

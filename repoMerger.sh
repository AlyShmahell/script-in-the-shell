#!/bin/bash

# Git Repository Merger
# Inspired by https://saintgimp.org/2013/01/22/merging-two-git-repositories-into-one-repository-without-losing-file-history/

while [ -d $1 ]; do
	echo "The repository you are trying to create already exists!"
	echo " Please select an option:
	[o] override existing repository
	[e] exit"
	read -p "" num
	case $num in
		[o]* ) rm -rf $1;;
		[e]* ) exit;;
		* ) echo "Please answer correctly";;
		esac
done
mkdir $1
cd $1
git init


# initial commit (of a dummy file)
touch deleteme.txt
git add .
git commit -m "Initial dummy commit"


vars=($@)
reponames=""
for oldRepo in ${vars[@]:1}; do
	reponame=${oldRepo##*/}
	# Fetching oldRepo
	git remote add -f $reponame $oldRepo

	# Merger from oldRepo/master into new/master
	git merge $reponame/master -m "fetched from $reponame"
	
	if [ -f deleteme.txt ]; then
		# dummy file removal
		git rm ./deleteme.txt
		git commit -m "Clean up initial file"
	fi
	[[ !  -z  $reponames  ]] && reponames+="|"
	reponames+="^"
	reponames+=$reponame
	# Moving the oldRepo to its own subdirectory
	mkdir $reponame
	find * -maxdepth 0 | egrep -v "$reponames" | { while read name; do git mv "$name" "$reponame"; done }

	# Committing the final oldRepo merger
	git commit -m "merged $oldRepo as $reponame"
	git remote rm $reponame
done

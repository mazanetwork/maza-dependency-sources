#!/bin/bash 

set -eo pipefail

# 
# optionally specify a commit to checkout on command line
#if [ -z "$1" ] ; then 
#  cur_branch="$1"
#else  
#  cur_branch=$(git rev-parse --abbrev-ref HEAD)
#fi

cur_branch=$(git rev-parse --abbrev-ref HEAD)

commit=$(git rev-parse --short HEAD)

# if we have a sources dir, check for the commit that made it
# remove the symlink that should exist 
if [ -d sources ] ; then
   if [ -f current_maza_commit.txt ] ; then
      last_commit=$(cat current_maza_commit.txt)
      if [ "$commit" = "$last_commit" ]; then
         echo "Previous commit $commit is the same as current" 
	 echo "Remove the sources/ directory and current_maza_commit.txt"
	 echo "manually to proceed"
	 exit 1
      fi
      rm sources-$last_commit
      mv sources sources-$last_commit || { echo "mv sources to sources-$last_commit failed" ; exit 1; }
   else 
      echo "You should hace a current_maza_commit.txt with the" 
      echo "git rev-parse --short HEAD) commit hash in it"
      exit 1
   fi
fi

if [ -d maza_source ] ; then
   cd maza_source
   git checkout "$cur_branch" || { echo "Failed to checkout branch: $cur_branch" ; exit 1; }
   git pull
else
   git clone https://github.com/mazanetwork/maza maza_source  || { echo "git clone of maza repo failed" ; exit 1; }
   cd maza_source || { echo "maza_source dir not accessible" ; exit 1; }
   git checkout "$cur_branch" || { echo "Failed to checkout branch: $cur_branch" ; exit 1; }
fi


make -C depends -j3 download


mv depends/sources ../sources || { echo "failed to move downloaded sources" ; exit 1; }


cd ..
ln -s sources sources-$commit || { echo "failed to symlink sources to sources-$commit" ; exit 1; }
echo "$commit" > current_maza_commit.txt 



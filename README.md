# maza-dependency-sources
Dependency Sources for mazad/maza-qt

Sources are acquired with `get_deps.sh`  which 
 - clones the maza repo
 - runs `make -C depends download` 
 - tries to help track the deps by commit hash

Sources are stored using `git-lfs` 

OSX SDK(s) are encrypted, for use in CI/CD build systems 




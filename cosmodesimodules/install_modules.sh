script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -z $CONF ] ; then CONF=nersc;   fi
CONFDIR=$script_dir/../conf
CONFIGUREENV=$CONFDIR/$CONF-env.sh
source $CONFIGUREENV

ROOTDIR=$(realpath $COSMODESICONDA/../../../../)
MODULEDIR=$COSMODESICONDA/../../startup/modulefiles/cosmodesimodules
mkdir -p $MODULEDIR

cp $script_dir/* $MODULEDIR
chgrp -R $GRP $MODULEDIR
chmod -R u=rwX,g=rX,o-rwx $MODULEDIR

scripts="activate_cosmodesi_jupyter.sh activate_cosmodesi_jupyter.csh cosmodesi_environment.sh cosmodesi_environment.csh"
for script in $scripts ; do
    ln -sf $MODULEDIR/$script $ROOTDIR/$script
done
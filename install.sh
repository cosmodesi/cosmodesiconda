#!/bin/bash

while getopts "v" opt; do
    case $opt in
	v) set -x # print commands as they are run so we know where we are if something fails
	   ;;
    esac
done
echo Starting cosmodesiconda installation at $(date)
SECONDS=0

# Defaults
if [ -z $CONF ] ; then CONF=nersc;   fi
if [ -z $PKGS ] ; then PKGS=default; fi

# Script directory
pushd $(dirname $0) > /dev/null
topdir=$(pwd)
popd > /dev/null

scriptname=$(basename $0)
fullscript="${topdir}/${scriptname}"

# Convenience environment variables

CONFDIR=$topdir/conf

CONFIGUREENV=$CONFDIR/$CONF-env.sh
INSTALLPKGS=$CONFDIR/$PKGS-pkgs.sh

export PATH=$CONDADIR/bin:$PATH

# Initialize environment
source $CONFIGUREENV

# Set installation directories
COSMODESICONDA=$PREFIX/$DCONDAVERSION
CONDADIR=$COSMODESICONDA/conda
AUXDIR=$COSMODESICONDA/aux
MODULEDIR=$COSMODESICONDA/modulefiles/cosmodesiconda

# Install conda root environment
echo Installing conda root environment at $(date)

mkdir -p $AUXDIR/bin
mkdir -p $AUXDIR/lib 

mkdir -p $CONDADIR/bin
mkdir -p $CONDADIR/lib

curl -SL $MINICONDA \
  -o miniconda.sh \
  && /bin/bash miniconda.sh -b -f -p $CONDADIR

source $CONDADIR/bin/activate
export PYVERSION=$(python -c "import sys; print(str(sys.version_info[0])+'.'+str(sys.version_info[1]))")
echo Using Python version $PYVERSION

# Install packages
source $INSTALLPKGS

# Compile python modules
echo Pre-compiling python modules at $(date)

python$PYVERSION -m compileall -f "$CONDADIR/lib/python$PYVERSION/site-packages"

# Set permissions
echo Setting permissions at $(date)

chgrp -R $GRP $CONDADIR
chmod -R u=rwX,g=rX,o-rwx $CONDADIR

# Install modulefile
echo Installing the cosmodesiconda modulefile at $(date)

mkdir -p $MODULEDIR

cp $topdir/modulefile.gen cosmodesiconda.module

sed -i 's@_CONDADIR_@'"$CONDADIR"'@g' cosmodesiconda.module
sed -i 's@_AUXDIR_@'"$AUXDIR"'@g' cosmodesiconda.module
sed -i 's@_DCONDAVERSION_@'"$DCONDAVERSION"'@g' cosmodesiconda.module
sed -i 's@_PYVERSION_@'"$PYVERSION"'@g' cosmodesiconda.module
sed -i 's@_CONDAPRGENV_@'"$CONDAPRGENV"'@g' cosmodesiconda.module

cp cosmodesiconda.module $MODULEDIR/$DCONDAVERSION
cp cosmodesiconda.modversion $MODULEDIR/.version_$DCONDAVERSION

chgrp -R $GRP $MODULEDIR
chmod -R u=rwX,g=rX,o-rwx $MODULEDIR

# All done
echo Done at $(date)
duration=$SECONDS
echo "Installation took $(($duration / 60)) minutes and $(($duration % 60)) seconds."

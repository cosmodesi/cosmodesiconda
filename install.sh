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
topdir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
scriptname=$(basename "${BASH_SOURCE[0]}")
fullscript="${topdir}/${scriptname}"

# Convenience environment variables

CONFDIR=$topdir/conf

CONFIGUREENV=$CONFDIR/$CONF-env.sh
INSTALLPKGS=$CONFDIR/$PKGS-pkgs.sh

export PATH=$CONDADIR/bin:$PATH

# Initialize environment
source $CONFIGUREENV

for MOD in $(echo $UNLOADMODULES)
do
  module unload $MOD
done

for MOD in $(echo $LOADMODULES)
do
  module load $MOD
done

for PRGENV in $(echo $PRGENVS)
do
  mod=`module -t list 2>&1 | grep $PRGENV`
  if [ "x$mod" != x ] ; then
    if [ $PRGENV != $CONDAPRGENV ] ; then
      echo "swapping $PRGENV for $CONDAPRGENV"
      module swap $PRGENV $CONDAPRGENV
    fi
  fi
done

# Set installation directories

ROOTDIR=$PREFIX
ROOTDIRHOST=$ROOTDIR
if [ ! -z $HOSTVARIABLE ] ; then
    ROOTDIRHOST=$ROOTDIR/${!HOSTVARIABLE}
fi
COSMODESICONDA=$ROOTDIRHOST/cosmodesiconda/$DCONDAVERSION
CONDADIR=$COSMODESICONDA/conda
MPILOGINDIR=$COSMODESICONDA/mpilogin
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
python$PYVERSION -m compileall -f "$MPILOGINDIR/lib/python$PYVERSION/site-packages"

# Install modulefile
echo Installing the cosmodesiconda modulefile at $(date)

mkdir -p $MODULEDIR

MODULEFILE=$MODULEDIR/$DCONDAVERSION
cp $topdir/cosmodesiconda.gen $MODULEFILE

sed -i 's@_ROOTDIR_@'"$ROOTDIR"'@g' $MODULEFILE
sed -i 's@_CONDADIR_@'"$CONDADIR"'@g' $MODULEFILE
sed -i 's@_AUXDIR_@'"$AUXDIR"'@g' $MODULEFILE
sed -i 's@_DCONDAVERSION_@'"$DCONDAVERSION"'@g' $MODULEFILE
sed -i 's@_PYVERSION_@'"$PYVERSION"'@g' $MODULEFILE
sed -i 's@_CONDAPRGENV_@'"$CONDAPRGENV"'@g' $MODULEFILE
sed -i 's@_PRGENVS_@'"$PRGENVS"'@g' $MODULEFILE
sed -i 's@_UNLOADMODULES_@'"$UNLOADMODULES"'@g' $MODULEFILE
sed -i 's@_LOADMODULES_@'"$LOADMODULES"'@g' $MODULEFILE

cp cosmodesiconda.modversion $MODULEDIR/.version_$DCONDAVERSION

chgrp -R $GRP $MODULEDIR
chmod -R u=rwX,g=rX,o-rwx $MODULEDIR

if [ ! -z ${MPILOGIN} ] ; then
    # Now patch for login node
    MODULEDIR=$COSMODESICONDA/modulefiles/mpilogin
    mkdir -p $MODULEDIR

    MODULEFILE=$MODULEDIR/$DCONDAVERSION
    cp $topdir/mpilogin.gen $MODULEFILE
    sed -i 's@_MPILOGINDIR_@'"$MPILOGINDIR"'@g' $MODULEFILE
    sed -i 's@_PYVERSION_@'"$PYVERSION"'@g' $MODULEFILE

    # Set permissions
    echo Setting permissions at $(date)

    chgrp -R $GRP $COSMODESICONDA
    chmod -R u=rwX,g=rX,o-rwx $COSMODESICONDA
fi
# All done
echo Done at $(date)
duration=$SECONDS
echo "Installation took $(($duration / 60)) minutes and $(($duration % 60)) seconds."

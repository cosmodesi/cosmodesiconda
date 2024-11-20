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

# Initialize environment
source $CONFIGUREENV

for MOD in $(echo $UNLOADMODULES)
do
  module unload $MOD
done
unset PYTHONPATH

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
AUXDIR=$COSMODESICONDA/aux
MODULEDIR=$COSMODESICONDA/modulefiles/cosmodesiconda
if [ ! -z $COSMOPREFIX ] ; then
    COSMODIR=$COSMOPREFIX
else
    COSMODIR=$PREFIX/cosmo
fi
if [ ! -z $HOSTVARIABLE ] ; then
    COSMODIR=$COSMODIR/${!HOSTVARIABLE}
fi
COSMODIR=$COSMODIR/cosmodesiconda/$DCONDAVERSION

# Install conda root environment
echo Installing conda root environment at $(date)

mkdir -p $AUXDIR/bin
mkdir -p $AUXDIR/lib 

mkdir -p $CONDADIR/bin
mkdir -p $CONDADIR/lib
mkdir -p $COSMODIR

curl -SL $MINICONDA -o miniconda.sh && /bin/bash miniconda.sh -b -f -p $CONDADIR

source $CONDADIR/bin/activate
export PYVERSION=$(python -c "import sys; print(str(sys.version_info[0])+'.'+str(sys.version_info[1]))")
echo Using Python version $PYVERSION

# Install packages
source $INSTALLPKGS

# Compile python modules
echo Pre-compiling python modules at $(date)

python$PYVERSION -m compileall -f "$CONDADIR/lib/python$PYVERSION/site-packages"

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
sed -i 's@_ENVVARIABLES_NODES_@'"$ENVVARIABLES_NODES"'@g' $MODULEFILE
sed -i 's@_ENVVARIABLES_LOGIN_@'"$ENVVARIABLES_LOGIN"'@g' $MODULEFILE
sed -i 's@_ENVVARIABLES_@'"$ENVVARIABLES"'@g' $MODULEFILE
sed -i 's@_PATH_@'"$EXPORTPATH"'@g' $MODULEFILE
sed -i 's@_PYTHONPATH_@'"$EXPORTPYTHONPATH"'@g' $MODULEFILE
sed -i 's@_LDLIBRARYPATH_@'"$EXPORTLDLIBRARYPATH"'@g' $MODULEFILE

cp cosmodesiconda.modversion $MODULEDIR/.version_$DCONDAVERSION

chgrp -R $GRP $MODULEDIR
chmod -R u=rwX,g=rX,o-rwx $MODULEDIR

# All done
echo Done at $(date)
duration=$SECONDS

module restore

MPICC=$MPICCPFFT $PYTHON -m pip install --no-cache-dir git+https://github.com/adematti/pfft-python
MPICC=$MPICCPFFT $PYTHON -m pip install --no-cache-dir git+https://github.com/adematti/pmesh
MPICC=$MPICCPFFT $PYTHON -m pip install --no-cache-dir git+https://github.com/adematti/getdist
conda install --copy --yes --verbose -c conda-forge \
    mpi4py \
    mpich \
    gcc_linux-64 \
    gxx_linux-64\
    gfortran\

echo Intalling polychord
cobaya install polychord
cd $WORK/software/desi/cosmo/cosmodesiconda/my-desiconda/cobaya/code/PolyChordLite
make clean
make COMPILER_TYPE=gnu
pip install . --user
cd $WORK
# $PYTHON -m pip install --force --no-cache-dir --no-binary=mpi4py mpi4py
echo "Installation took $(($duration / 60)) minutes and $(($duration % 60)) seconds."

# export MINICONDA=https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
# miniforge solves fast and works well with conda-forge 
export MINICONDA=https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh
export CONDAVERSION=2.0
export GRP=desi
export CONDAPRGENV=gnu

export CC="gcc"
export FC="gfortran"
export CFLAGS="-O3 -fPIC -pthread"
export FCFLAGS="-O3 -fPIC -pthread -fexceptions"
export NTMAKE=8

# needed for mpi4py
if [ "${NERSC_HOST}" == "cori" ] ; then
  # see https://docs.nersc.gov/development/languages/python/parallel-python/
  export MPICC="cc  -shared"
elif [ "${NERSC_HOST}" == "perlmutter" ] ; then
  # see https://docs.nersc.gov/development/languages/python/using-python-perlmutter
  module load cudatoolkit
  export MPICC="cc -target-accel=nvidia80 -shared"
fi

module unload darshan            # not necessary and suspected to generate overhead
module unload altd               # not necessary and suspected to cause random job hangs
module unload craype-hugepages2M # https://docs.nersc.gov/development/languages/python/faq-troubleshooting

for PRGENV in $(echo gnu intel cray nvidia)
do
  mod=`module -t list 2>&1 | grep PrgEnv-$PRGENV`
  if [ "x$mod" != x ] ; then
    if [ $PRGENV != $CONDAPRGENV ] ; then
      echo "swapping PrgEnv-$PRGENV for PrgEnv-$CONDAPRGENV"
      module swap PrgEnv-$PRGENV PrgEnv-$CONDAPRGENV
    fi
  fi
done

if [ $CONDAPRGENV == "gnu" ] ; then
    module load openmpi
fi
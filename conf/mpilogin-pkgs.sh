# Outdated: MPI install for NERSC cori login nodes
echo Installing mpilogin packages at $(date)

prefix=$(realpath $COSMODESICONDA/mpilogin)
mkdir -p $prefix

module load openmpi
MPICC="mpicc" pip install mpi4py --no-binary=:all: --no-cache-dir --no-deps --disable-pip-version-check --ignore-installed --prefix=$prefix
MPICC="mpicc" pip install pfft-python --no-binary=:all: --no-cache-dir --no-deps --disable-pip-version-check --ignore-installed --prefix=$prefix
MPICC="mpicc" pip install mpsort --no-binary=:all: --no-cache-dir --no-deps --disable-pip-version-check --ignore-installed --prefix=$prefix
MPICC="mpicc" pip install git+https://github.com/adematti/pmesh --no-binary=:all: --no-cache-dir --no-deps --disable-pip-version-check --ignore-installed
CC="mpicc" CFLAGS="" pip install git+https://github.com/adematti/PolyChordLite@mpi4py --no-binary=:all: --no-cache-dir --no-deps --disable-pip-version-check --ignore-installed --prefix=$prefix
module unload openmpi

if [ $? != 0 ]; then
    echo "ERROR installing pip packages; exiting"
    exit 1
fi

echo Current time $(date) Done installing mpilogin packages
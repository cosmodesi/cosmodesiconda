# Install pip packages.
echo Installing pip packages at $(date)

# see https://docs.nersc.gov/development/languages/python/parallel-python/
pip install --force --no-cache-dir --no-binary=mpi4py mpi4py
MPICC="cc" pip install --no-cache-dir --no-binary=:all: git+https://github.com/adematti/pmesh
pip install --no-cache-dir --no-deps camb emcee schwimmbad getdist dynesty dill

if [ $? != 0 ]; then
    echo "ERROR installing pip packages; exiting"
    exit 1
fi

echo Current time $(date) Done installing pip packages

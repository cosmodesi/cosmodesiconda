# Install pip packages.
echo Installing pip packages at $(date)

# see https://docs.nersc.gov/development/languages/python/parallel-python/
MPICC="mpicc" pip install --force --no-cache-dir --no-binary=mpi4py mpi4py
MPICC="mpicc" pip install --no-cache-dir --no-binary=pmesh pmesh
pip install --no-cache-dir camb

if [ $? != 0 ]; then
    echo "ERROR installing pip packages; exiting"
    exit 1
fi

echo Current time $(date) Done installing conda packages

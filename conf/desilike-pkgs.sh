export DESILIKE_INSTALL_DIR=$COSMODESICOSMO/desilike
export DESILIKE_CONFIG_DIR=$DESILIKE_INSTALL_DIR/.desilike
mkdir -p $DESILIKE_CONFIG_DIR
export ENVVARIABLES="$ENVVARIABLES DESILIKE_CONFIG_DIR $DESILIKE_CONFIG_DIR DESILIKE_INSTALL_DIR $DESILIKE_INSTALL_DIR"

#PYTHON=$(which python)
#$PYTHON -m pip install --no-cache-dir git+https://github.com/adematti/PolyChordLite@mpi4py
#$PYTHON -m desilike-pkgs.py

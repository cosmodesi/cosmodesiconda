export DESILIKE_INSTALL_DIR=$COSMODIR/desilike
export DESILIKE_CONFIG_DIR=$DESILIKE_INSTALL_DIR/.desilike
mkdir -p $DESILIKE_CONFIG_DIR
export ENVVARIABLES="$ENVVARIABLES DESILIKE_CONFIG_DIR $DESILIKE_CONFIG_DIR DESILIKE_INSTALL_DIR $DESILIKE_INSTALL_DIR"

CC="cc" CFLAGS="" pip install --no-binary=:all: --no-cache-dir git+https://github.com/adematti/PolyChordLite@mpi4py
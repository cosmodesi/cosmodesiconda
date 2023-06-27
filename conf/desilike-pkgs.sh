export DESILIKE_INSTALL_DIR=$COSMODIR/desilike
export DESILIKE_CONFIG_DIR=$DESILIKE_INSTALL_DIR/.desilike
mkdir -p $DESILIKE_CONFIG_DIR
export ENVVARIABLES="$ENVVARIABLES DESILIKE_CONFIG_DIR $DESILIKE_CONFIG_DIR DESILIKE_INSTALL_DIR $DESILIKE_INSTALL_DIR"

pip install --no-cache-dir --no-deps git+https://github.com/adematti/pybird@dev
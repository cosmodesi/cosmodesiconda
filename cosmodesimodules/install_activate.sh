script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -z $CONF ] ; then CONF=nersc;   fi
source $script_dir/../conf/$CONF-env.sh

if [ -z $COSMODESIROOT ] ; then
    echo "Load a cosmodesiconda module first to get COSMODESIROOT"
    exit 0
fi

COSMODESIROOTHOST=$COSMODESIROOT
COSMODESIROOTHOSTBASH=$COSMODESIROOT
if [ ! -z $HOSTVARIABLE ] ; then
    COSMODESIROOTHOST=$COSMODESIROOT/${!HOSTVARIABLE}
    COSMODESIROOTHOSTBASH=$COSMODESIROOT'/${'$HOSTVARIABLE'}'
fi

MODULEDIR=$COSMODESIROOTHOST/cosmodesiconda/startup/modulefiles/cosmodesimodules

scripts="activate_cosmodesi_jupyter.sh activate_cosmodesi_jupyter.csh cosmodesi_environment.sh cosmodesi_environment.csh install_jupyter_kernel.sh"
for script in $scripts ; do
    cp $script_dir/$script.gen $MODULEDIR/$script
    sed -i 's@_ROOTDIR_@'"$COSMODESIROOT"'@g' $MODULEDIR/$script
    sed -i 's@_ROOTDIRHOST_@'"$COSMODESIROOTHOSTBASH"'@g' $MODULEDIR/$script
    ln -sf $MODULEDIR/$script $COSMODESIROOT/$script
done

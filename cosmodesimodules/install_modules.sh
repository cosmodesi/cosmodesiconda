script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -z $CONF ] ; then CONF=nersc;   fi
source $script_dir/../conf/$CONF-env.sh

if [ -z $COSMODESIROOT ] ; then
    echo "Load a cosmodesiconda module first to get COSMODESIROOT"
    exit 0
fi

COSMODESIROOTHOST=$COSMODESIROOT
COSMODESIROOTHOSTTCL=$COSMODESIROOT
if [ ! -z $HOSTVARIABLE ] ; then
    COSMODESIROOTHOST=$COSMODESIROOT/${!HOSTVARIABLE}
    COSMODESIROOTHOSTTCL=$COSMODESIROOT'/$env('$HOSTVARIABLE')'
fi

MODULEDIR=$COSMODESIROOTHOST/cosmodesiconda/startup/modulefiles/cosmodesimodules
mkdir -p $MODULEDIR

cp $script_dir/*.png $MODULEDIR

for script in $script_dir/versions/$1.gen ; do
    filename=$(basename -- "$script")
    filename="${filename%.*}"
    cp $script_dir/versions/$filename.gen $MODULEDIR/$filename
    sed -i 's@_ROOTDIRHOST_@'"$COSMODESIROOTHOSTTCL"'@g' $MODULEDIR/$filename
    sed -i 's@_DCONDAVERSION_@'"$COSMODESICONDA_VERSION"'@g' $MODULEDIR/$filename
done

if [ ! -z $GRP ] ; then
  chgrp -R $GRP $MODULEDIR
fi
chmod -R u=rwX,g=rX,o-rwx $MODULEDIR
source $CONFDIR/conda-pkgs.sh
for sc in $COSMOINSTALL ; do
    if [[ ! -z $sc ]] ; then
        source $CONFDIR/$sc
    fi
done
if [[ ! -z ${MPILOGIN} ]] ; then
    source $CONFDIR/mpilogin-pkgs.sh
fi

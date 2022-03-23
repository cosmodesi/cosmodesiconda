source $CONFDIR/conda-pkgs.sh
source $CONFDIR/pip-pkgs.sh
if [[ ! -z ${MPILOGIN} ]] ; then
    source $CONFDIR/mpilogin-pkgs.sh
fi
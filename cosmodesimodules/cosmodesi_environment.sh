#
# This code is meant to be sourced, not executed.
# It currently only supports NERSC hosts.
#
if [[ $(basename ${SHELL}) == "bash" || $(basename ${SHELL}) == "sh" ]]; then
    if [[ $# > 0 ]]; then
        _desi_release="/$1"
    else
        _desi_release=''
    fi
    _desi_startup=/global/cfs/cdirs/desi/users/adematti/${NERSC_HOST}/cosmodesiconda/startup/modulefiles
    if [[ -n "${DESI_ROOT}" ]]; then
        # Do nothing, successfully.
        :
    elif [[ -n "${NERSC_HOST}" ]]; then
        export DESI_ROOT=/global/cfs/cdirs/desi
    else
        echo "Could not determine a valid value of DESI_ROOT!"
        return
    fi
    if [[ "${NERSC_HOST}" == "perlmutter" || \
          "${NERSC_HOST}" == "cori" || \
          "${NERSC_HOST}" == "datatran" ]]; then
        module use ${_desi_startup}
        module load cosmodesimodules${_desi_release}
    else
        echo "DESI+Anaconda environment is not supported on ${NERSC_HOST}!"
    fi
    unset _desi_startup
    unset _desi_release
else
    echo "You are not sourcing the correct file for your shell!"
fi

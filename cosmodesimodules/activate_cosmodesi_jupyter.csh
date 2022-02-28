#!/bin/tcsh

# This script is intended to be called from a jupyter kernel.json file
# with the desimodules version number and a "connection_file" parameter
# provided by jupyter, e.g. via a file like:
# $HOME/.local/share/jupyter/kernels/cosmodesi-main/kernel.json
#

# {
# "language": "python",
# "argv": [
#   "/global/cfs/cdirs/desi/users/adematti/activate_cosmodesi_jupyter.csh",
#   "main",
#   "{connection_file}"
#   ],
# "display_name": "cosmodesi-main"
# }

set version = $1
set connection_file = $2

source /global/cfs/cdirs/desi/users/adematti/cosmodesi_environment.csh ${version}
exec python -m ipykernel -f ${connection_file}

#!/bin/bash
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ -z $CONF ] ; then CONF=nersc;   fi
source $script_dir/../conf/$CONF-env.sh

args=""
if [ ! -z $GRP ] ; then
  args="-g $GRP"
fi

$script_dir/install_pkgs.sh $script_dir/pkg_list.txt $args
#$script_dir/install_modules.sh $1
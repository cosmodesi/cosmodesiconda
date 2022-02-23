#!/bin/bash
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
$script_dir/install_pkgs.sh $script_dir/pkg_list.txt
$script_dir/install_modules.sh
#!/bin/bash

# Bootstrap a set of DESI modules for their master branch

if [ -z "$COSMODESICONDA" ] || [ -z "$COSMODESICONDA_VERSION" ]; then
    echo "Load a cosmodesiconda module first to get COSMODESICONDA and COSMODESICONDA_VERSION"
    exit 0
fi

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
install_script=$script_dir/install.py

# Install desiutil to get desiInstall script
python -m pip install git+https://github.com/desihub/desiutil.git --user --no-deps

base=$(realpath $COSMODESICONDA/..)
while read line || [[ -n "$line" ]] ; do
    if [[ $line == \#* ]] || [[ -z $line ]] ; then
    continue
    fi
    IFS='@' read -ra pkgurlversions <<< $line
    pkg=$(echo ${pkgurlversions[0]} | xargs)
    url=$(echo ${pkgurlversions[1]} | xargs)
    versions=$(echo ${pkgurlversions[2]} | xargs)
    IFS=',' read -ra versions <<< $versions
    if [ ${#versions[@]} -eq 0 ]; then
        versions=("main")
    fi
    for version in ${versions[@]} ; do
        version=$(echo ${version} | xargs)
        echo $install_script $pkg $version
        python $install_script -v -r $base $pkg $version -p $pkg:$url $2
    done
done < $1

# remove pip desiutil because we'll use the desiutil module now
#pip uninstall desiutil --yes

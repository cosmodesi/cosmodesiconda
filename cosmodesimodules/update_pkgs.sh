#!/bin/bash
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
update_list=$script_dir/update_pkg_list.txt

update_list_exists="n"
if [[ -f "$update_list" ]] ; then
    update_list_exists="y"
fi

if [[ $update_list_exists == "n" ]] ; then
    while read line || [[ -n "$line" ]] ; do
        if [[ $line == \#* ]] || [[ -z $line ]] ; then
        continue
        fi
        IFS='@' read -ra pkgurlversions <<< $line
        pkg=$(echo ${pkgurlversions[0]} | xargs)
        url=$(echo ${pkgurlversions[1]} | xargs)
        versions=$(echo ${pkgurlversions[2]} | xargs)
        IFS=',' read -ra versions <<< $versions
        for version in ${versions[@]} ; do
            version=$(echo ${version} | xargs)
            if [[ $version == "branches/main" ]] || [[ $version == "branches/master" ]]; then
                echo "$pkg @ $url @ $version" >> $update_list
            fi
        done
    done < $script_dir/pkg_list.txt
fi

$script_dir/install_pkgs.sh $update_list --force

if [[ $update_list_exists == "n" ]] ; then
    rm $update_list
fi
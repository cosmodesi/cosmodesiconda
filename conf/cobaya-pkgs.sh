# Cobaya stuffs
pip install cobaya
export COBAYA_STD_DIR=$COSMODIR/cobaya
rm -rf $COBAYA_STD_DIR
export COBAYA_PACKAGES_PATH=$COBAYA_STD_DIR
cobaya-install bicep_keck_2018 sn.pantheon bao.sdss_dr12_consensus_final des_y1.joint planck_2018_highl_plik.TTTEEE -p $COBAYA_STD_DIR
export ENVVARIABLES="$ENVVARIABLES COBAYA_STD_DIR $COBAYA_STD_DIR COBAYA_PACKAGES_PATH $COBAYA_PACKAGES_PATH"
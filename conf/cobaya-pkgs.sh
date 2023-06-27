# Cobaya stuffs
pip install cobaya
export COBAYA_STD_DIR=$COSMODIR/cobaya
rm -rf $COBAYA_STD_DIR
export COBAYA_PACKAGES_PATH=$COBAYA_STD_DIR
cobaya-install bicep_keck_2018 sn.pantheon bao.sdss_dr12_consensus_final bao.sixdf_2011_bao bao.sdss_dr7_mgs bao.sdss_dr16_baoplus_lrg bao.sdss_dr16_baoplus_elg bao.sdss_dr16_baoplus_qso bao.sdss_dr16_baoplus_lyauto bao.sdss_dr16_baoplus_lyxqso des_y1.joint planck_2018_highl_plik.TTTEEE planck_2018_lowl.TT planck_2018_lowl.EE -p $COBAYA_STD_DIR
export ENVVARIABLES="$ENVVARIABLES COBAYA_STD_DIR $COBAYA_STD_DIR COBAYA_PACKAGES_PATH $COBAYA_PACKAGES_PATH COBAYA_USE_FILE_LOCKING F"
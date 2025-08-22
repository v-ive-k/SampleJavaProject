
location_name = "southcentralus"
rg_name       = "mr8-dev-rg"

nics = {
  "buildcontroller_test" = {
    name = "nic-BUILDCONTROLLER-00-test"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dev_mr8_test" = {
    name = "nic-DEV-MR8-00-test"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dev_mrfile_test" = {
    name = "nic-DEV-MRFILE-00-test"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dev_web_2012r2_test" = {
    name = "nic-DEV-WEB-2012r2-00-test"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dockerbuild_test" = {
    name = "nic-DOCKERBUILD-00-test"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvkib2_1" = {
    name = "DVKIB2-1-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvkib2_2" = {
    name = "DVKIB2-2-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvkib2_3" = {
    name = "DVKIB2-3-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvkib2_4" = {
    name = "DVKIB2-4-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvkib2_5" = {
    name = "DVKIB2-5-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvkib2_6" = {
    name = "DVKIB2-6-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvkib2_7" = {
    name = "DVKIB2-7-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvkib2_8" = {
    name = "DVKIB2-8-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvkib2_9" = {
    name = "dvkib2-9-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvkib2_ac_0" = {
    name = "DVKIB2-AC-0-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvkib2_ac_1" = {
    name = "DVKIB2-AC-1-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvkib2_ac_2" = {
    name = "DVKIB2-AC-2-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvkib2_ac_3" = {
    name = "DVKIB2-AC-3-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvkib2_app01" = {
    name = "dvkib2-app01435"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvkib2_def01" = {
    name = "dvkib2-def01508"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvkib2_rpa01" = {
    name = "dvkib2-rpa01497"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvkib2_rpa02" = {
    name = "dvkib2-rpa02608"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvkib2_web01" = {
    name = "dvkib2-web01177"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvkib2_web02" = {
    name = "dvkib2-web02469"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvkic1_pm01_test" = {
    name = "nic-DVKIC1-PM01-00-test"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvkic1_sql03_test" = {
    name = "nic-DVKIC1-SQL03-00-test"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "dvwgb2_ftp01" = {
    name = "dvwgb2-ftp01208"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "keais_dev_test" = {
    name = "nic-KEAIS-DEV-00-test"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "keais_ship_test" = {
    name = "nic-KEAIS-SHIP-00-test"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "keais_winweb_test" = {
    name = "nic-KEAIS-WINWEB-00-test"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_nsb01" = {
    name = "kib2-nsb01216"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_0" = {
    name = "KIB2-W10DEV-0-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_10" = {
    name = "KIB2-W10DEV-10-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_11" = {
    name = "KIB2-W10DEV-11-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_12" = {
    name = "KIB2-W10DEV-12-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_15" = {
    name = "KIB2-W10DEV-15-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_2" = {
    name = "KIB2-W10DEV-2-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_20" = {
    name = "KIB2-W10DEV-20-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_21" = {
    name = "KIB2-W10DEV-21-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_22" = {
    name = "KIB2-W10DEV-22-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_24" = {
    name = "KIB2-W10DEV-24-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_25" = {
    name = "KIB2-W10DEV-25-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_26" = {
    name = "KIB2-W10DEV-26-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_29" = {
    name = "KIB2-W10DEV-29-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_3" = {
    name = "KIB2-W10DEV-3-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_30" = {
    name = "KIB2-W10DEV-30-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_31" = {
    name = "KIB2-W10DEV-31-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_32" = {
    name = "KIB2-W10DEV-32-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_33" = {
    name = "KIB2-W10DEV-33-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_34" = {
    name = "KIB2-W10DEV-34-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_5" = {
    name = "KIB2-W10DEV-5-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_7" = {
    name = "KIB2-W10DEV-7-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kib2_w10dev_9" = {
    name = "KIB2-W10DEV-9_1-nic"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "kic1_sec01_test" = {
    name = "nic-KIC1-SEC01-00-test"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "qa_mrfile_test" = {
    name = "nic-QA-MRFILE-00-test"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "qakib2_opg01" = {
    name = "qakib2-opg01829"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "sca1_iisdev_test" = {
    name = "nic-SCA1-IISDEV-00-test"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "wginb2_ghunt01" = {
    name = "wginb2-ghunt01129_z1"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
  "wgkib1_web02_test" = {
    name = "nic-WGKIB1-WEB02-00-test"
    subnet_id = "<FILL_SUBNET_ID>"
    allocation = "Dynamic"
    private_ip = ""
  }
}

os_disks = {
  "buildcontroller_test" = {
    name = "BUILDCONTROLLER-OSdisk-00-test"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dev_mr8_test" = {
    name = "DEV-MR8-OSdisk-00-test"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dev_mrfile_test" = {
    name = "DEV-MRFILE-OSdisk-00-test"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dev_web_2012r2_test" = {
    name = "DEV-WEB-2012r2-OSdisk-00-test"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dockerbuild_test" = {
    name = "DOCKERBUILD-OSdisk-00-test"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvkib2_1" = {
    name = "DVKIB2-1_OsDisk_1_b010f4a9ad4e4658a12d919fe9a63838"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvkib2_2" = {
    name = "DVKIB2-2_OsDisk_1_fd1b5452a1b24871a0b0ae433f579566"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvkib2_3" = {
    name = "DVKIB2-3_OsDisk_1_faab604fc4bf4ab7a16bcdeb631f2893"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvkib2_4" = {
    name = "DVKIB2-4_OsDisk_1_625847cf5a34468d928806a5e4b7cc16"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvkib2_5" = {
    name = "DVKIB2-5_OsDisk_1_99050c337af64175a4dd3b88b29be9cf"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvkib2_6" = {
    name = "DVKIB2-6_OsDisk_1_4f0569572987401baaa7f4f5c4da4d76"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvkib2_7" = {
    name = "DVKIB2-7_OsDisk_1_420317ff9be34484a4d38459a7bc502f"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvkib2_8" = {
    name = "DVKIB2-8_OsDisk_1_3335fee9960744418b3d6f51b17a5667"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvkib2_9" = {
    name = "dvkib2-9_OsDisk_1_b8676dfef855414197a5c687543010ec"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvkib2_ac_0" = {
    name = "DVKIB2-AC-0_OsDisk_1_814a6d59d30e40ddb9eff22979e03795"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvkib2_ac_1" = {
    name = "DVKIB2-AC-1_OsDisk_1_e782c9d8cff5417dbef68c7ad2bf79f1"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvkib2_ac_2" = {
    name = "DVKIB2-AC-2_OsDisk_1_692b5fdc21e9443d9078a2321d2f9ea3"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvkib2_ac_3" = {
    name = "DVKIB2-AC-3_OsDisk_1_96173e6b2fcb4d43ba8775e093083d49"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvkib2_app01" = {
    name = "DVKIB2-APP01_OsDisk_1_8e1525feb7b1478f9e4ceda5c8f4be3b"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvkib2_def01" = {
    name = "DVKIB2-DEF01_osdisk1"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvkib2_rpa01" = {
    name = "DVKIB2-RPA01_OsDisk_1_742f1b371716444f8dc0caacaef8d917"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvkib2_rpa02" = {
    name = "DVKIB2-RPA02_OsDisk_1_b74846474fc644e7b0f2f0ba8ac0a700"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvkib2_web01" = {
    name = "DVKIB2-WEB01_OsDisk_1_2983fb975b9d45bc806d054ea09c2dd7"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvkib2_web02" = {
    name = "DVKIB2-WEB02_OsDisk_1_c3cb151d066246e88dee0e84a975e5f8"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvkic1_pm01_test" = {
    name = "DVKIC1-PM01-OSdisk-00-test"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvkic1_sql03_test" = {
    name = "DVKIC1-SQL03-OSdisk-00-test"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "dvwgb2_ftp01" = {
    name = "DVWGB2-FTP01_OsDisk_1_0c78f25d49004de5ab80fa6a95b15f2a"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "keais_dev_test" = {
    name = "KEAIS-DEV-OSdisk-00-test"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "keais_ship_test" = {
    name = "KEAIS-SHIP-OSdisk-00-test"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "keais_winweb_test" = {
    name = "KEAIS-WINWEB-OSdisk-00-test"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_nsb01" = {
    name = "KIB2-NSB01_osdisk1"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_0" = {
    name = "KIB2-W10DEV-0_disk1_debb61f6137941e586a5eacfac28d909"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_10" = {
    name = "KIB2-W10DEV-10_OsDisk_1_10ec65cc3f1d4eff9a60d65505238116"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_11" = {
    name = "KIB2-W10DEV-11_OsDisk_1_d7c492f2d9994f629e5e8fe2b6c726e2"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_12" = {
    name = "KIB2-W10DEV-12_OsDisk_1_04770cde35fd41dab93e07e5e2ab7999"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_15" = {
    name = "KIB2-W10DEV-15_disk1_7f436fc8ff1c4053aafdb9007bc363da"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_2" = {
    name = "KIB2-W10DEV-2_disk1_9374484c920b440c8c717f360bf49830"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_20" = {
    name = "KIB2-W10DEV-20_OsDisk_1_4fd1bbe6bdcd43a3b26fd1ee74ad326d"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_21" = {
    name = "KIB2-W10DEV-21_OsDisk_1_3d750a8ff14844a99083a5ef6d1b8cae"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_22" = {
    name = "KIB2-W10DEV-22_OsDisk_1_2b0585a8609d4aac94749084431f06d6"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_24" = {
    name = "KIB2-W10DEV-24_OsDisk_1_f4207af1c990419691496fec6f73ad8a"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_25" = {
    name = "KIB2-W10DEV-25_OsDisk_1_be10a4000cb94ac3ae03e453ca1cf744"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_26" = {
    name = "KIB2-W10DEV-26_OsDisk_1_3f70d124d6654e4ea50f43e1440d9ba8"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_29" = {
    name = "KIB2-W10DEV-29_OsDisk_1_d4835c9bab064a0681c447f6d1ee3467"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_3" = {
    name = "KIB2-W10DEV-3_disk1_2ab62bf52f4e472384df7f5fa4fb041c"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_30" = {
    name = "KIB2-W10DEV-30_OsDisk_1_6251cc3d6b6c4b0da620c73e5ed7416e"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_31" = {
    name = "KIB2-W10DEV-31_OsDisk_1_42af842a16894efcb07c81edaacf7ff8"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_32" = {
    name = "KIB2-W10DEV-32_OsDisk_1_57547f347a5847f6a8ba80171f965c20"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_33" = {
    name = "KIB2-W10DEV-33_OsDisk_1_2c00d3d517374c2a8bda3ad0be63c5ce"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_34" = {
    name = "KIB2-W10DEV-34_OsDisk_1_a848645f31d34983b420941d0d28e298"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_5" = {
    name = "KIB2-W10DEV-5_disk1_b44981250bde4dd481a6598ff1626002"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_7" = {
    name = "KIB2-W10DEV-7_disk1_48160eef7e734351a02eeb5afff456e4"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kib2_w10dev_9" = {
    name = "KIB2-W10DEV-9_OsDisk_1_f55c03c66f8a4a8e8010b5d26e710d4c"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "kic1_sec01_test" = {
    name = "KIC1-SEC01-OSdisk-00-test"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "qa_mrfile_test" = {
    name = "QA-MRFILE-OSdisk-00-test"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "qakib2_opg01" = {
    name = "QAKIB2-OPG01_OsDisk_1_2ee33f23ad8f46a3b8950669b134e049"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "sca1_iisdev_test" = {
    name = "SCA1-IISDEV-OSdisk-00-test"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "wginb2_ghunt01" = {
    name = "WGINB2-GHUNT01_OsDisk_1_a8a2f72f2dff469f89e81c1f8b40af62"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
  "wgkib1_web02_test" = {
    name = "WGKIB1-WEB02-OSdisk-00-test"
    disk_size_gb = 0
    storage_account_type = ""
    os_type = ""
    hyper_v_generation = ""
  }
}

vms = {
  "buildcontroller_test" = {
    name = "BUILDCONTROLLER-test"
    size = "StandardD2asv5"
    nic_key = "buildcontroller_test"
    os_disk_key = "buildcontroller_test"
    boot_diag_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
    identity_type = "SystemAssigned"
  }
  "dev_mr8_test" = {
    name = "DEV-MR8-test"
    size = "StandardF4sv2"
    nic_key = "dev_mr8_test"
    os_disk_key = "dev_mr8_test"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dev_mrfile_test" = {
    name = "DEV-MRFILE-test"
    size = "StandardB1s"
    nic_key = "dev_mrfile_test"
    os_disk_key = "dev_mrfile_test"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dev_web_2012r2_test" = {
    name = "DEV-WEB-2012r2-test"
    size = "StandardB4asv2"
    nic_key = "dev_web_2012r2_test"
    os_disk_key = "dev_web_2012r2_test"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dockerbuild_test" = {
    name = "DOCKERBUILD-test"
    size = "StandardD4sv3"
    nic_key = "dockerbuild_test"
    os_disk_key = "dockerbuild_test"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvkib2_1" = {
    name = "DVKIB2-1"
    size = "StandardD4asv5"
    nic_key = "dvkib2_1"
    os_disk_key = "dvkib2_1"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvkib2_2" = {
    name = "DVKIB2-2"
    size = "StandardD4asv5"
    nic_key = "dvkib2_2"
    os_disk_key = "dvkib2_2"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvkib2_3" = {
    name = "DVKIB2-3"
    size = "StandardD4asv5"
    nic_key = "dvkib2_3"
    os_disk_key = "dvkib2_3"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvkib2_4" = {
    name = "DVKIB2-4"
    size = "StandardD4asv5"
    nic_key = "dvkib2_4"
    os_disk_key = "dvkib2_4"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvkib2_5" = {
    name = "DVKIB2-5"
    size = "StandardD4asv5"
    nic_key = "dvkib2_5"
    os_disk_key = "dvkib2_5"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvkib2_6" = {
    name = "DVKIB2-6"
    size = "StandardD4asv5"
    nic_key = "dvkib2_6"
    os_disk_key = "dvkib2_6"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvkib2_7" = {
    name = "DVKIB2-7"
    size = "StandardD4asv5"
    nic_key = "dvkib2_7"
    os_disk_key = "dvkib2_7"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvkib2_8" = {
    name = "DVKIB2-8"
    size = "StandardD4asv5"
    nic_key = "dvkib2_8"
    os_disk_key = "dvkib2_8"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvkib2_9" = {
    name = "dvkib2-9"
    size = "StandardD4asv5"
    nic_key = "dvkib2_9"
    os_disk_key = "dvkib2_9"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvkib2_ac_0" = {
    name = "DVKIB2-AC-0"
    size = "StandardE2sv5"
    nic_key = "dvkib2_ac_0"
    os_disk_key = "dvkib2_ac_0"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvkib2_ac_1" = {
    name = "DVKIB2-AC-1"
    size = "StandardE4bsv5"
    nic_key = "dvkib2_ac_1"
    os_disk_key = "dvkib2_ac_1"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvkib2_ac_2" = {
    name = "DVKIB2-AC-2"
    size = "StandardE2sv5"
    nic_key = "dvkib2_ac_2"
    os_disk_key = "dvkib2_ac_2"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvkib2_ac_3" = {
    name = "DVKIB2-AC-3"
    size = "StandardE4bsv5"
    nic_key = "dvkib2_ac_3"
    os_disk_key = "dvkib2_ac_3"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvkib2_app01" = {
    name = "DVKIB2-APP01"
    size = "StandardD2sv4"
    nic_key = "dvkib2_app01"
    os_disk_key = "dvkib2_app01"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvkib2_def01" = {
    name = "DVKIB2-DEF01"
    size = "StandardB2s"
    nic_key = "dvkib2_def01"
    os_disk_key = "dvkib2_def01"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvkib2_rpa01" = {
    name = "DVKIB2-RPA01"
    size = "StandardB8sv2"
    nic_key = "dvkib2_rpa01"
    os_disk_key = "dvkib2_rpa01"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvkib2_rpa02" = {
    name = "DVKIB2-RPA02"
    size = "StandardB16sv2"
    nic_key = "dvkib2_rpa02"
    os_disk_key = "dvkib2_rpa02"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvkib2_web01" = {
    name = "DVKIB2-WEB01"
    size = "StandardE2sv4"
    nic_key = "dvkib2_web01"
    os_disk_key = "dvkib2_web01"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvkib2_web02" = {
    name = "DVKIB2-WEB02"
    size = "StandardE2sv4"
    nic_key = "dvkib2_web02"
    os_disk_key = "dvkib2_web02"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvkic1_pm01_test" = {
    name = "DVKIC1-PM01-test"
    size = "StandardF2sv2"
    nic_key = "dvkic1_pm01_test"
    os_disk_key = "dvkic1_pm01_test"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvkic1_sql03_test" = {
    name = "DVKIC1-SQL03-test"
    size = "StandardE4sv3"
    nic_key = "dvkic1_sql03_test"
    os_disk_key = "dvkic1_sql03_test"
    boot_diag_uri = ""
    identity_type = ""
  }
  "dvwgb2_ftp01" = {
    name = "DVWGB2-FTP01"
    size = "StandardD2sv4"
    nic_key = "dvwgb2_ftp01"
    os_disk_key = "dvwgb2_ftp01"
    boot_diag_uri = ""
    identity_type = ""
  }
  "keais_dev_test" = {
    name = "KEAIS-DEV-test"
    size = "StandardE4sv3"
    nic_key = "keais_dev_test"
    os_disk_key = "keais_dev_test"
    boot_diag_uri = ""
    identity_type = ""
  }
  "keais_ship_test" = {
    name = "KEAIS-SHIP-test"
    size = "StandardF4sv2"
    nic_key = "keais_ship_test"
    os_disk_key = "keais_ship_test"
    boot_diag_uri = ""
    identity_type = ""
  }
  "keais_winweb_test" = {
    name = "KEAIS-WINWEB-test"
    size = "StandardF2sv2"
    nic_key = "keais_winweb_test"
    os_disk_key = "keais_winweb_test"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_nsb01" = {
    name = "KIB2-NSB01"
    size = "StandardB4ms"
    nic_key = "kib2_nsb01"
    os_disk_key = "kib2_nsb01"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_0" = {
    name = "KIB2-W10DEV-0"
    size = "StandardD4sv3"
    nic_key = "kib2_w10dev_0"
    os_disk_key = "kib2_w10dev_0"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_10" = {
    name = "KIB2-W10DEV-10"
    size = "StandardD4sv4"
    nic_key = "kib2_w10dev_10"
    os_disk_key = "kib2_w10dev_10"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_11" = {
    name = "KIB2-W10DEV-11"
    size = "StandardD4sv4"
    nic_key = "kib2_w10dev_11"
    os_disk_key = "kib2_w10dev_11"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_12" = {
    name = "KIB2-W10DEV-12"
    size = "StandardD4sv4"
    nic_key = "kib2_w10dev_12"
    os_disk_key = "kib2_w10dev_12"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_15" = {
    name = "KIB2-W10DEV-15"
    size = "StandardD4sv4"
    nic_key = "kib2_w10dev_15"
    os_disk_key = "kib2_w10dev_15"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_2" = {
    name = "KIB2-W10DEV-2"
    size = "StandardD4sv5"
    nic_key = "kib2_w10dev_2"
    os_disk_key = "kib2_w10dev_2"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_20" = {
    name = "KIB2-W10DEV-20"
    size = "StandardD4sv5"
    nic_key = "kib2_w10dev_20"
    os_disk_key = "kib2_w10dev_20"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_21" = {
    name = "KIB2-W10DEV-21"
    size = "StandardD4sv5"
    nic_key = "kib2_w10dev_21"
    os_disk_key = "kib2_w10dev_21"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_22" = {
    name = "KIB2-W10DEV-22"
    size = "StandardD4sv5"
    nic_key = "kib2_w10dev_22"
    os_disk_key = "kib2_w10dev_22"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_24" = {
    name = "KIB2-W10DEV-24"
    size = "StandardE4sv5"
    nic_key = "kib2_w10dev_24"
    os_disk_key = "kib2_w10dev_24"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_25" = {
    name = "KIB2-W10DEV-25"
    size = "StandardE4sv5"
    nic_key = "kib2_w10dev_25"
    os_disk_key = "kib2_w10dev_25"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_26" = {
    name = "KIB2-W10DEV-26"
    size = "StandardE4sv5"
    nic_key = "kib2_w10dev_26"
    os_disk_key = "kib2_w10dev_26"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_29" = {
    name = "KIB2-W10DEV-29"
    size = "StandardD4sv5"
    nic_key = "kib2_w10dev_29"
    os_disk_key = "kib2_w10dev_29"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_3" = {
    name = "KIB2-W10DEV-3"
    size = "StandardE4sv5"
    nic_key = "kib2_w10dev_3"
    os_disk_key = "kib2_w10dev_3"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_30" = {
    name = "KIB2-W10DEV-30"
    size = "StandardD4sv5"
    nic_key = "kib2_w10dev_30"
    os_disk_key = "kib2_w10dev_30"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_31" = {
    name = "KIB2-W10DEV-31"
    size = "StandardD4sv5"
    nic_key = "kib2_w10dev_31"
    os_disk_key = "kib2_w10dev_31"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_32" = {
    name = "KIB2-W10DEV-32"
    size = "StandardD4sv5"
    nic_key = "kib2_w10dev_32"
    os_disk_key = "kib2_w10dev_32"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_33" = {
    name = "KIB2-W10DEV-33"
    size = "StandardD4sv5"
    nic_key = "kib2_w10dev_33"
    os_disk_key = "kib2_w10dev_33"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_34" = {
    name = "KIB2-W10DEV-34"
    size = "StandardD4sv5"
    nic_key = "kib2_w10dev_34"
    os_disk_key = "kib2_w10dev_34"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_5" = {
    name = "KIB2-W10DEV-5"
    size = "StandardD4sv4"
    nic_key = "kib2_w10dev_5"
    os_disk_key = "kib2_w10dev_5"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_7" = {
    name = "KIB2-W10DEV-7"
    size = "StandardD4sv4"
    nic_key = "kib2_w10dev_7"
    os_disk_key = "kib2_w10dev_7"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kib2_w10dev_9" = {
    name = "KIB2-W10DEV-9"
    size = "StandardD4sv4"
    nic_key = "kib2_w10dev_9"
    os_disk_key = "kib2_w10dev_9"
    boot_diag_uri = ""
    identity_type = ""
  }
  "kic1_sec01_test" = {
    name = "KIC1-SEC01-test"
    size = "StandardB2ms"
    nic_key = "kic1_sec01_test"
    os_disk_key = "kic1_sec01_test"
    boot_diag_uri = ""
    identity_type = ""
  }
  "qa_mrfile_test" = {
    name = "QA-MRFILE-test"
    size = "StandardD2adsv5"
    nic_key = "qa_mrfile_test"
    os_disk_key = "qa_mrfile_test"
    boot_diag_uri = ""
    identity_type = ""
  }
  "qakib2_opg01" = {
    name = "QAKIB2-OPG01"
    size = "StandardE2sv4"
    nic_key = "qakib2_opg01"
    os_disk_key = "qakib2_opg01"
    boot_diag_uri = ""
    identity_type = ""
  }
  "sca1_iisdev_test" = {
    name = "SCA1-IISDEV-test"
    size = "StandardF2sv2"
    nic_key = "sca1_iisdev_test"
    os_disk_key = "sca1_iisdev_test"
    boot_diag_uri = ""
    identity_type = ""
  }
  "wginb2_ghunt01" = {
    name = "WGINB2-GHUNT01"
    size = "StandardB16ms"
    nic_key = "wginb2_ghunt01"
    os_disk_key = "wginb2_ghunt01"
    boot_diag_uri = ""
    identity_type = ""
  }
  "wgkib1_web02_test" = {
    name = "WGKIB1-WEB02-test"
    size = "StandardB2ms"
    nic_key = "wgkib1_web02_test"
    os_disk_key = "wgkib1_web02_test"
    boot_diag_uri = ""
    identity_type = ""
  }
}

data_disks = {
  "dev_mrfile_test" = [
    {
      name = "DEV-MRFILE-datadisk-01-test"
      lun = 0
      caching = "<FILL_CACHING>"
      disk_size_gb = 0
      storage_account_type = "<FILL_SKU>"
    },
    {
      name = "DEV-MRFILE-datadisk-02-test"
      lun = 1
      caching = "<FILL_CACHING>"
      disk_size_gb = 0
      storage_account_type = "<FILL_SKU>"
    },
  ]
  "dev_web_2012r2_test" = [
    {
      name = "DEV-WEB-2012r2-datadisk-01-test"
      lun = 0
      caching = "<FILL_CACHING>"
      disk_size_gb = 0
      storage_account_type = "<FILL_SKU>"
    },
  ]
  "dvkib2_rpa01" = [
    {
      name = "DVKIB2-RPA01_DataDisk01"
      lun = 0
      caching = "<FILL_CACHING>"
      disk_size_gb = 0
      storage_account_type = "<FILL_SKU>"
    },
  ]
  "dvkib2_rpa02" = [
    {
      name = "DVKIB2-RPA02_DataDisk_0"
      lun = 0
      caching = "<FILL_CACHING>"
      disk_size_gb = 0
      storage_account_type = "<FILL_SKU>"
    },
  ]
  "dvkic1_sql03_test" = [
    {
      name = "DVKIC1-SQL03-datadisk-01-test"
      lun = 0
      caching = "<FILL_CACHING>"
      disk_size_gb = 0
      storage_account_type = "<FILL_SKU>"
    },
    {
      name = "DVKIC1-SQL03-datadisk-02-test"
      lun = 1
      caching = "<FILL_CACHING>"
      disk_size_gb = 0
      storage_account_type = "<FILL_SKU>"
    },
  ]
  "keais_dev_test" = [
    {
      name = "KEAIS-DEV-datadisk-01-test"
      lun = 0
      caching = "<FILL_CACHING>"
      disk_size_gb = 0
      storage_account_type = "<FILL_SKU>"
    },
    {
      name = "KEAIS-DEV-datadisk-02-test"
      lun = 1
      caching = "<FILL_CACHING>"
      disk_size_gb = 0
      storage_account_type = "<FILL_SKU>"
    },
  ]
  "kib2_w10dev_22" = [
    {
      name = "KIB2-W10DEV-16_OsDisk_1_23e6ba78aced4999a85a124c1ad3c059"
      lun = 0
      caching = "<FILL_CACHING>"
      disk_size_gb = 0
      storage_account_type = "<FILL_SKU>"
    },
  ]
  "kic1_sec01_test" = [
    {
      name = "KIC1-SEC01-datadisk-01-test"
      lun = 0
      caching = "<FILL_CACHING>"
      disk_size_gb = 0
      storage_account_type = "<FILL_SKU>"
    },
  ]
  "qa_mrfile_test" = [
    {
      name = "QA-MRFILE-datadisk-01-test"
      lun = 0
      caching = "<FILL_CACHING>"
      disk_size_gb = 0
      storage_account_type = "<FILL_SKU>"
    },
    {
      name = "QA-MRFILE-datadisk-02-test"
      lun = 1
      caching = "<FILL_CACHING>"
      disk_size_gb = 0
      storage_account_type = "<FILL_SKU>"
    },
  ]
}

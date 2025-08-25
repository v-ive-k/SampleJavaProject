 Error: Invalid value for input variable
│
│   on terraform.tfvars line 490:
│  490: vms = {
│  491:   "buildcontroller_test" = {
│  492:     name                    = "BUILDCONTROLLER-test"
│  493:     size                    = "Standard_D2as_v5"
│  494:     nic_key                 = "buildcontroller_test"
│  495:     os_disk_key             = "buildcontroller_test"
│  496:     boot_diag_uri           = "https://migrateffe5clsa87353.blob.core.windows.net"
│  497:     identity_type           = "SystemAssigned"
│  498:     os_disk_creation_option = "Attach"
│  499:   },
│  500:   "dev_mr8_test" = {
│  501:     name                    = "DEV-MR8-test"
│  502:     size                    = "Standard_F4s_v2"
│  503:     nic_key                 = "dev_mr8_test"
│  504:     os_disk_key             = "dev_mr8_test"
│  505:     boot_diag_uri           = "https://migrateffe5clsa87353.blob.core.windows.net"
│  506:     identity_type           = "SystemAssigned"
│  507:     os_disk_creation_option = "Attach"
│  508:   },
│  509:   "dev_mrfile_test" = {
│  510:     name                    = "DEV-MRFILE-test"
│  511:     size                    = "Standard_B1s"
│  512:     nic_key                 = "dev_mrfile_test"
│  513:     os_disk_key             = "dev_mrfile_test"
│  514:     boot_diag_uri           = "https://migrateffe5clsa87353.blob.core.windows.net"
│  515:     identity_type           = "SystemAssigned"
│  516:     os_disk_creation_option = "Attach"
│  517:   },
│  518:   "dev_web_2012r2_test" = {
│  519:     name                    = "DEV-WEB-2012r2-test"
│  520:     size                    = "Standard_B4as_v2"
│  521:     nic_key                 = "dev_web_2012r2_test"
│  522:     os_disk_key             = "dev_web_2012r2_test"
│  523:     boot_diag_uri           = "https://migrateffe5clsa87353.blob.core.windows.net"
│  524:     identity_type           = "SystemAssigned"
│  525:     os_disk_creation_option = "Attach"
│  526:   },
│  527:   "dockerbuild_test" = {
│  528:     name                    = "DOCKERBUILD-test"
│  529:     size                    = "Standard_D4s_v3"
│  530:     nic_key                 = "dockerbuild_test"
│  531:     os_disk_key             = "dockerbuild_test"
│  532:     boot_diag_uri           = "https://migrateffe5clsa87353.blob.core.windows.net"
│  533:     identity_type           = "SystemAssigned"
│  534:     os_disk_creation_option = "Attach"
│  535:   },
│  536:   "dvkib2_9" = {
│  537:     name                    = "dvkib2-9"
│  538:     size                    = "Standard_D4as_v5"
│  539:     nic_key                 = "dvkib2_9"
│  540:     os_disk_key             = "dvkib2_9"
│  541:     boot_diag_uri           = ""
│  542:     identity_type           = ""
│  543:     os_disk_creation_option = "FromImage"
│  544:     image_refernece = {
│  545:       offer     = "WindowsServer"
│  546:       publisher = "MicrosoftWindowsServer"
│  547:       sku       = "2019-Datacenter"
│  548:       version   = "latest"
│  549:     }
│  550:   },
│  551:   "dvkib2_app01" = {
│  552:     name                    = "DVKIB2-APP01"
│  553:     size                    = "Standard_D2s_v4"
│  554:     nic_key                 = "dvkib2_app01"
│  555:     os_disk_key             = "dvkib2_app01"
│  556:     boot_diag_uri           = ""
│  557:     identity_type           = ""
│  558:     os_disk_creation_option = "FromImage"
│  559:     image_refernece = {
│  560:       offer     = "WindowsServer"
│  561:       publisher = "MicrosoftWindowsServer"
│  562:       sku       = "2019-Datacenter"
│  563:       version   = "latest"
│  564:     }
│  565:   },
│  566:   "dvkib2_def01" = {
│  567:     name                    = "DVKIB2-DEF01"
│  568:     size                    = "Standard_B2s"
│  569:     nic_key                 = "dvkib2_def01"
│  570:     os_disk_key             = "dvkib2_def01"
│  571:     boot_diag_uri           = ""
│  572:     identity_type           = "SystemAssigned"
│  573:     os_disk_creation_option = "FromImage"
│  574:     image_refernece = {
│  575:       offer     = "WindowsServer"
│  576:       publisher = "MicrosoftWindowsServer"
│  577:       sku       = "2019-Datacenter"
│  578:       version   = "latest"
│  579:     }
│  580:   },
│  581:   "dvkib2_rpa01" = {
│  582:     name                    = "DVKIB2-RPA01"
│  583:     size                    = "Standard_B8s_v2"
│  584:     nic_key                 = "dvkib2_rpa01"
│  585:     os_disk_key             = "dvkib2_rpa01"
│  586:     boot_diag_uri           = ""
│  587:     identity_type           = "SystemAssigned"
│  588:     os_disk_creation_option = "FromImage"
│  589:     image_refernece = {
│  590:       offer     = "WindowsServer"
│  591:       publisher = "MicrosoftWindowsServer"
│  592:       sku       = "2019-Datacenter"
│  593:       version   = "latest"
│  594:     }
│  595:   },
│  596:   "dvkib2_rpa02" = {
│  597:     name                    = "DVKIB2-RPA02"
│  598:     size                    = "Standard_B16s_v2"
│  599:     nic_key                 = "dvkib2_rpa02"
│  600:     os_disk_key             = "dvkib2_rpa02"
│  601:     boot_diag_uri           = ""
│  602:     identity_type           = "SystemAssigned"
│  603:     os_disk_creation_option = "FromImage"
│  604:     image_refernece = {
│  605:       offer     = "WindowsServer"
│  606:       publisher = "MicrosoftWindowsServer"
│  607:       sku       = "2019-Datacenter"
│  608:       version   = "latest"
│  609:     }
│  610:   }
│  611:   "dvkib2_web01" = {
│  612:     name                    = "DVKIB2-WEB01"
│  613:     size                    = "Standard_E2s_v4"
│  614:     nic_key                 = "dvkib2_web01"
│  615:     os_disk_key             = "dvkib2_web01"
│  616:     boot_diag_uri           = ""
│  617:     identity_type           = ""
│  618:     os_disk_creation_option = "FromImage"
│  619:     image_refernece = {
│  620:       offer     = "WindowsServer"
│  621:       publisher = "MicrosoftWindowsServer"
│  622:       sku       = "2019-Datacenter"
│  623:       version   = "latest"
│  624:     }
│  625:   }
│  626:   "dvkib2_web02" = {
│  627:     name                    = "DVKIB2-WEB02"
│  628:     size                    = "Standard_E2s_v4"
│  629:     nic_key                 = "dvkib2_web02"
│  630:     os_disk_key             = "dvkib2_web02"
│  631:     boot_diag_uri           = ""
│  632:     identity_type           = ""
│  633:     os_disk_creation_option = "FromImage"
│  634:     image_refernece = {
│  635:       offer     = "WindowsServer"
│  636:       publisher = "MicrosoftWindowsServer"
│  637:       sku       = "2019-Datacenter"
│  638:       version   = "latest"
│  639:     }
│  640:   },
│  641:   "dvkic1_pm01_test" = {
│  642:     name          = "DVKIC1-PM01-test"
│  643:     size          = "Standard_F2s_v2"
│  644:     nic_key       = "dvkic1_pm01_test"
│  645:     os_disk_key   = "dvkic1_pm01_test"
│  646:     boot_diag_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
│  647:     identity_type = "SystemAssigned"
│  648:   },
│  649:   "dvkic1_sql03_test" = {
│  650:     name          = "DVKIC1-SQL03-test"
│  651:     size          = "Standard_E4s_v3"
│  652:     nic_key       = "dvkic1_sql03_test"
│  653:     os_disk_key   = "dvkic1_sql03_test"
│  654:     boot_diag_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
│  655:     identity_type = "SystemAssigned"
│  656:   },
│  657:   "dvwgb2_ftp01" = {
│  658:     name                    = "DVWGB2-FTP01"
│  659:     size                    = "Standard_D2s_v4"
│  660:     nic_key                 = "dvwgb2_ftp01"
│  661:     os_disk_key             = "dvwgb2_ftp01"
│  662:     boot_diag_uri           = ""
│  663:     identity_type           = ""
│  664:     os_disk_creation_option = "FromImage"
│  665:     image_refernece = {
│  666:       offer     = "WindowsServer"
│  667:       publisher = "MicrosoftWindowsServer"
│  668:       sku       = "2019-Datacenter"
│  669:       version   = "latest"
│  670:     }
│  671:   },
│  672:   "keais_dev_test" = {
│  673:     name          = "KEAIS-DEV-test"
│  674:     size          = "Standard_E4s_v3"
│  675:     nic_key       = "keais_dev_test"
│  676:     os_disk_key   = "keais_dev_test"
│  677:     boot_diag_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
│  678:     identity_type = "SystemAssigned"
│  679:   }
│  680:   "keais_ship_test" = {
│  681:     name          = "KEAIS-SHIP-test"
│  682:     size          = "Standard_F4s_v2"
│  683:     nic_key       = "keais_ship_test"
│  684:     os_disk_key   = "keais_ship_test"
│  685:     boot_diag_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
│  686:     identity_type = "SystemAssigned"
│  687:   }
│  688:   "keais_winweb_test" = {
│  689:     name          = "KEAIS-WINWEB-test"
│  690:     size          = "Standard_F2s_v2"
│  691:     nic_key       = "keais_winweb_test"
│  692:     os_disk_key   = "keais_winweb_test"
│  693:     boot_diag_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
│  694:     identity_type = "SystemAssigned"
│  695:   },
│  696:   "kib2_nsb01" = {
│  697:     name                    = "KIB2-NSB01"
│  698:     size                    = "Standard_B4ms"
│  699:     nic_key                 = "kib2_nsb01"
│  700:     os_disk_key             = "kib2_nsb01"
│  701:     boot_diag_uri           = ""
│  702:     identity_type           = "SystemAssigned"
│  703:     os_disk_creation_option = "FromImage"
│  704:     image_refernece = {
│  705:       offer     = "WindowsServer"
│  706:       publisher = "MicrosoftWindowsServer"
│  707:       sku       = "2019-Datacenter"
│  708:       version   = "latest"
│  709:     }
│  710:   },
│  711:   "kic1_sec01_test" = {
│  712:     name          = "KIC1-SEC01-test"
│  713:     size          = "Standard_B2ms"
│  714:     nic_key       = "kic1_sec01_test"
│  715:     os_disk_key   = "kic1_sec01_test"
│  716:     boot_diag_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
│  717:     identity_type = "SystemAssigned"
│  718:   },
│  719:   "qa_mrfile_test" = {
│  720:     name          = "QA-MRFILE-test"
│  721:     size          = "Standard_D2ads_v5"
│  722:     nic_key       = "qa_mrfile_test"
│  723:     os_disk_key   = "qa_mrfile_test"
│  724:     boot_diag_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
│  725:     identity_type = "SystemAssigned"
│  726:   },
│  727:   "qakib2_opg01" = {
│  728:     name                    = "QAKIB2-OPG01"
│  729:     size                    = "Standard_E2s_v4"
│  730:     nic_key                 = "qakib2_opg01"
│  731:     os_disk_key             = "qakib2_opg01"
│  732:     boot_diag_uri           = ""
│  733:     identity_type           = ""
│  734:     os_disk_creation_option = "FromImage"
│  735:     image_refernece = {
│  736:       offer     = "WindowsServer"
│  737:       publisher = "MicrosoftWindowsServer"
│  738:       sku       = "2019-Datacenter"
│  739:       version   = "latest"
│  740:     }
│  741:   },
│  742:   "sca1_iisdev_test" = {
│  743:     name          = "SCA1-IISDEV-test"
│  744:     size          = "Standard_F2s_v2"
│  745:     nic_key       = "sca1_iisdev_test"
│  746:     os_disk_key   = "sca1_iisdev_test"
│  747:     boot_diag_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
│  748:     identity_type = "SystemAssigned"
│  749:   },
│  750:   "wgkib1_web02_test" = {
│  751:     name          = "WGKIB1-WEB02-test"
│  752:     size          = "Standard_B2ms"
│  753:     nic_key       = "wgkib1_web02_test"
│  754:     os_disk_key   = "wgkib1_web02_test"
│  755:     boot_diag_uri = "https://migrateffe5clsa87353.blob.core.windows.net"
│  756:     identity_type = "SystemAssigned"
│  757:   }
│  758: }
│
│ The given value is not suitable for var.vms declared at variables.tf:81,1-15: element "sca1_iisdev_test": attribute "os_disk_creation_option" is required.

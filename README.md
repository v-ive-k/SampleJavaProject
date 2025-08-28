 Error: Invalid value for input variable
│
│   on terraform.tfvars line 237:
│  237: vms = {
│  238:   "dvkib2_9" = {
│  239:     name                    = "dvkib2-9"
│  240:     size                    = "Standard_D4as_v5"
│  241:     nic_key                 = "dvkib2_9"
│  242:     os_disk_key             = "dvkib2_9"
│  243:     boot_diag_uri           = ""
│  244:     identity_type           = ""
│  245:     os_disk_creation_option = "FromImage"
│  246:     image_reference = {
│  247:       id = "/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/IT-Prod-RG/providers/Microsoft.Compute/galleries/Ont_Prod1_scus_scg/images/AVD-KI-MR8-Win11/versions/0.0.1"
│  248:     }
│  249:     os_profiles = {
│  250:       admin_username = "ontadmin"
│  251:       admin_password = ""
│  252:       computer_name  = "dvkib2-9"
│  253:     }
│  254:     windows_config = {
│  255:       provision_vm_agent        = true
│  256:       enable_automatic_upgrades = true
│  257:     }
│  258:   },
│  259:   "dvkib2_app01" = {
│  260:     name                    = "DVKIB2-APP01"
│  261:     size                    = "Standard_D2s_v4"
│  262:     nic_key                 = "dvkib2_app01"
│  263:     os_disk_key             = "dvkib2_app01"
│  264:     boot_diag_uri           = ""
│  265:     identity_type           = ""
│  266:     os_disk_creation_option = "FromImage"
│  267:     image_reference = {
│  268:       offer     = "WindowsServer"
│  269:       publisher = "MicrosoftWindowsServer"
│  270:       sku       = "2019-Datacenter"
│  271:       version   = "latest"
│  272:     }
│  273:     os_profiles = {
│  274:       admin_username = "ONTAdmin"
│  275:       admin_password = ""
│  276:       computer_name  = "DVKIB2-APP01"
│  277:     }
│  278:     windows_config = {
│  279:       provision_vm_agent        = true
│  280:       enable_automatic_upgrades = true
│  281:     }
│  282:   },
│  283:   "dvkib2_def01" = {
│  284:     name                    = "DVKIB2-DEF01"
│  285:     size                    = "Standard_B2s"
│  286:     nic_key                 = "dvkib2_def01"
│  287:     os_disk_key             = "dvkib2_def01"
│  288:     boot_diag_uri           = ""
│  289:     identity_type           = "SystemAssigned"
│  290:     os_disk_creation_option = "FromImage"
│  291:     image_reference = {
│  292:       offer     = "WindowsServer"
│  293:       publisher = "MicrosoftWindowsServer"
│  294:       sku       = "2019-datacenter-gensecond"
│  295:       version   = "latest"
│  296:     }
│  297:     os_profiles = {
│  298:       admin_username = "ONTAdmin"
│  299:       admin_password = ""
│  300:       computer_name  = "DVKIB2-DEF01"
│  301:     }
│  302:     windows_config = {
│  303:       provision_vm_agent        = true
│  304:       enable_automatic_upgrades = false
│  305:     }
│  306:   },
│  307:   "dvkib2_rpa01" = {
│  308:     name                    = "DVKIB2-RPA01"
│  309:     size                    = "Standard_B8s_v2"
│  310:     nic_key                 = "dvkib2_rpa01"
│  311:     os_disk_key             = "dvkib2_rpa01"
│  312:     boot_diag_uri           = ""
│  313:     identity_type           = "SystemAssigned"
│  314:     os_disk_creation_option = "FromImage"
│  315:     image_reference = {
│  316:       offer     = "WindowsServer"
│  317:       publisher = "MicrosoftWindowsServer"
│  318:       sku       = "2019-datacenter-gensecond"
│  319:       version   = "latest"
│  320:     }
│  321:     os_profiles = {
│  322:       admin_username = "ontadmin"
│  323:       admin_password = ""
│  324:       computer_name  = "DVKIB2-RPA01"
│  325:     }
│  326:     windows_config = {
│  327:       provision_vm_agent        = true
│  328:       enable_automatic_upgrades = true
│  329:     }
│  330:   },
│  331:   "dvkib2_rpa02" = {
│  332:     name                    = "DVKIB2-RPA02"
│  333:     size                    = "Standard_B16s_v2"
│  334:     nic_key                 = "dvkib2_rpa02"
│  335:     os_disk_key             = "dvkib2_rpa02"
│  336:     boot_diag_uri           = ""
│  337:     identity_type           = "SystemAssigned"
│  338:     os_disk_creation_option = "FromImage"
│  339:     image_reference = {
│  340:       offer     = "WindowsServer"
│  341:       publisher = "MicrosoftWindowsServer"
│  342:       sku       = "2019-datacenter-gensecond"
│  343:       version   = "latest"
│  344:     }
│  345:     os_profiles = {
│  346:       admin_username = "ontadmin"
│  347:       admin_password = ""
│  348:       computer_name  = "DVKIB2-RPA02"
│  349:     }
│  350:     windows_config = {
│  351:       provision_vm_agent        = true
│  352:       enable_automatic_upgrades = true
│  353:     }
│  354:   },
│  355:   "dvkib2_web01" = {
│  356:     name                    = "DVKIB2-WEB01"
│  357:     size                    = "Standard_E2s_v4"
│  358:     nic_key                 = "dvkib2_web01"
│  359:     os_disk_key             = "dvkib2_web01"
│  360:     boot_diag_uri           = ""
│  361:     identity_type           = ""
│  362:     os_disk_creation_option = "FromImage"
│  363:     image_reference = {
│  364:       offer     = "WindowsServer"
│  365:       publisher = "MicrosoftWindowsServer"
│  366:       sku       = "2019-Datacenter"
│  367:       version   = "latest"
│  368:     }
│  369:     os_profiles = {
│  370:       admin_username = "ONTAdmin"
│  371:       admin_password = ""
│  372:       computer_name  = "DVKIB2-WEB01"
│  373:     }
│  374:     windows_config = {
│  375:       provision_vm_agent        = true
│  376:       enable_automatic_upgrades = true
│  377:     }
│  378:   },
│  379:   "dvkib2_web02" = {
│  380:     name                    = "DVKIB2-WEB02"
│  381:     size                    = "Standard_E2s_v4"
│  382:     nic_key                 = "dvkib2_web02"
│  383:     os_disk_key             = "dvkib2_web02"
│  384:     boot_diag_uri           = ""
│  385:     identity_type           = ""
│  386:     os_disk_creation_option = "FromImage"
│  387:     image_reference = {
│  388:       offer     = "WindowsServer"
│  389:       publisher = "MicrosoftWindowsServer"
│  390:       sku       = "2019-Datacenter"
│  391:       version   = "latest"
│  392:     }
│  393:     os_profiles = {
│  394:       admin_username = "ONTAdmin"
│  395:       admin_password = ""
│  396:       computer_name  = "DVKIB2-WEB02"
│  397:     }
│  398:     windows_config = {
│  399:       provision_vm_agent        = true
│  400:       enable_automatic_upgrades = true
│  401:     }
│  402:   },
│  403:   "dvwgb2_ftp01" = {
│  404:     name                    = "DVWGB2-FTP01"
│  405:     size                    = "Standard_D2s_v4"
│  406:     nic_key                 = "dvwgb2_ftp01"
│  407:     os_disk_key             = "dvwgb2_ftp01"
│  408:     boot_diag_uri           = ""
│  409:     identity_type           = ""
│  410:     os_disk_creation_option = "FromImage"
│  411:     image_reference = {
│  412:       offer     = "WindowsServer"
│  413:       publisher = "MicrosoftWindowsServer"
│  414:       sku       = "2019-Datacenter"
│  415:       version   = "latest"
│  416:     }
│  417:     os_profiles = {
│  418:       admin_username = "ONTAdmin"
│  419:       admin_password = ""
│  420:       computer_name  = "DVWGB2-FTP01"
│  421:     }
│  422:     windows_config = {
│  423:       provision_vm_agent        = true
│  424:       enable_automatic_upgrades = true
│  425:     }
│  426:   },
│  427:   "kib2_nsb01" = {
│  428:     name                    = "KIB2-NSB01"
│  429:     size                    = "Standard_B4ms"
│  430:     nic_key                 = "kib2_nsb01"
│  431:     os_disk_key             = "kib2_nsb01"
│  432:     boot_diag_uri           = ""
│  433:     identity_type           = "SystemAssigned"
│  434:     os_disk_creation_option = "FromImage"
│  435:     image_reference = {
│  436:       offer     = "WindowsServer"
│  437:       publisher = "MicrosoftWindowsServer"
│  438:       sku       = "2019-datacenter-gensecond"
│  439:       version   = "latest"
│  440:     }
│  441:     os_profiles = {
│  442:       admin_username = "ONTAdmin"
│  443:       admin_password = ""
│  444:       computer_name  = "KIB2-NSB01"
│  445:     }
│  446:     windows_config = {
│  447:       provision_vm_agent        = true
│  448:       enable_automatic_upgrades = false
│  449:     }
│  450:   },
│  451:   "qakib2_opg01" = {
│  452:     name                    = "QAKIB2-OPG01"
│  453:     size                    = "Standard_E2s_v4"
│  454:     nic_key                 = "qakib2_opg01"
│  455:     os_disk_key             = "qakib2_opg01"
│  456:     boot_diag_uri           = ""
│  457:     identity_type           = ""
│  458:     os_disk_creation_option = "FromImage"
│  459:     image_reference = {
│  460:       offer     = "WindowsServer"
│  461:       publisher = "MicrosoftWindowsServer"
│  462:       sku       = "2019-Datacenter"
│  463:       version   = "latest"
│  464:     }
│  465:     os_profiles = {
│  466:       admin_username = "ONTAdmin"
│  467:       admin_password = ""
│  468:       computer_name  = "QAKIB2-OPG01"
│  469:     }
│  470:     windows_config = {
│  471:       provision_vm_agent        = true
│  472:       enable_automatic_upgrades = false
│  473:     }
│  474:   },
│  475:   "app02" = {
│  476:     name        = "DVKIB2-APP02"
│  477:     size        = "Standard_D2s_v5"
│  478:     nic_key     = "app02-nic"
│  479:     os_disk_key = "app02-os"
│  480:     image_reference = {
│  481:       publisher = "MicrosoftWindowsServer"
│  482:       offer     = "WindowsServer"
│  483:       sku       = "2019-Datacenter"
│  484:       version   = "latest"
│  485:     }
│  486:     os_profiles = {
│  487:       admin_username = "localadmin"
│  488:       admin_password = "CHANGE_ME_Str0ng!" # use a strong secret
│  489:       computer_name  = "DVKIB2-APP02"
│  490:     }
│  491:     windows_config = {
│  492:       provision_vm_agent        = true
│  493:       enable_automatic_upgrades = true
│  494:     }
│  495:   }
│  496: }
│
│ The given value is not suitable for var.vms declared at variables.tf:71,1-15: element "app02": attributes "boot_diag_uri", "identity_type", and "os_disk_creation_option" are       
│ required.

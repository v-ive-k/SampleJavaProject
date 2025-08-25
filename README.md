# azurerm_virtual_machine.vm["dvkib2_9"] must be replaced
-/+ resource "azurerm_virtual_machine" "vm" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      ~ id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/dvkib2-9" -> (known after apply)
      + license_type                     = (known after apply)
        name                             = "dvkib2-9"
      ~ tags                             = {
          - "Domain"             = "Keaisinc" -> null
          - "Owner"              = "Greg Johnson" -> null
          - "cm-resource-parent" = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.DesktopVirtualization/hostpools/MR8WVD-Dev-Automation-Bot-02" -> null
          + "domain"             = "Keais"
            "environment"        = "Development"
          + "managed by"         = "terraform"
          - "name"               = "Keaisinc" -> null
          + "owner"              = "Greg Johnson"
        }
      - zones                            = [] -> null
        # (4 unchanged attributes hidden)

      - additional_capabilities {}

      - boot_diagnostics {
          - enabled     = true -> null
            # (1 unchanged attribute hidden)
        }

      - os_profile { # forces replacement
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = true -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      ~ storage_data_disk (known after apply)

      - storage_image_reference {
          - id        = "/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/IT-Prod-RG/providers/Microsoft.Compute/galleries/Ont_Prod1_scus_scg/images/AVD-KI-MR8-Win11/versions/0.0.1" -> null
            # (4 unchanged attributes hidden)
        }
      + storage_image_reference {
          + id        = "/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/IT-Prod-RG/providers/Microsoft.Compute/galleries/Ont_Prod1_scus_scg/images/AVD-KI-MR8-Win11/versions/0.0.1"
          + version   = (known after apply)
            # (3 unchanged attributes hidden)
        }

      ~ storage_os_disk {
          ~ managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/dvkib2-9_OsDisk_1_b8676dfef855414197a5c687543010ec" -> (known after apply)
            name                      = "dvkib2-9_OsDisk_1_b8676dfef855414197a5c687543010ec"
            # (8 unchanged attributes hidden)
        }
    }

  # azurerm_virtual_machine.vm["dvkib2_app01"] must be replaced
-/+ resource "azurerm_virtual_machine" "vm" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      ~ id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-APP01" -> (known after apply)
      + license_type                     = (known after apply)
        name                             = "DVKIB2-APP01"
      ~ tags                             = {
          + "domain"      = "Keais"
          ~ "environment" = "development" -> "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      - zones                            = [] -> null
        # (4 unchanged attributes hidden)

      - boot_diagnostics {
          - enabled     = true -> null
            # (1 unchanged attribute hidden)
        }

      - os_profile { # forces replacement
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = true -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      ~ storage_data_disk (known after apply)

      ~ storage_os_disk {
          ~ managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/DVKIB2-APP01_OsDisk_1_8e1525feb7b1478f9e4ceda5c8f4be3b" -> (known after apply)
            name                      = "DVKIB2-APP01_OsDisk_1_8e1525feb7b1478f9e4ceda5c8f4be3b"
            # (8 unchanged attributes hidden)
        }

        # (1 unchanged block hidden)
    }

  # azurerm_virtual_machine.vm["dvkib2_def01"] must be replaced
-/+ resource "azurerm_virtual_machine" "vm" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      ~ id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-DEF01" -> (known after apply)
      + license_type                     = (known after apply)
        name                             = "DVKIB2-DEF01"
      ~ tags                             = {
          ~ "domain"      = "keaisinc" -> "Keais"
          ~ "environment" = "development" -> "Development"
          + "managed by"  = "terraform"
          ~ "owner"       = "Jaspinder Singh" -> "Greg Johnson"
        }
      - zones                            = [] -> null
        # (4 unchanged attributes hidden)

      - boot_diagnostics {
          - enabled     = true -> null
            # (1 unchanged attribute hidden)
        }

      ~ identity {
          - identity_ids = [] -> null
          ~ principal_id = "fab5ba7d-6e4d-49b5-b182-c6ecb54b7ae6" -> (known after apply)
          ~ tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502" -> (known after apply)
            # (1 unchanged attribute hidden)
        }

      - os_profile { # forces replacement
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = false -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      ~ storage_data_disk (known after apply)

      ~ storage_os_disk {
          ~ managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/DVKIB2-DEF01_osdisk1" -> (known after apply)
            name                      = "DVKIB2-DEF01_osdisk1"
            # (8 unchanged attributes hidden)
        }

        # (1 unchanged block hidden)
    }

  # azurerm_virtual_machine.vm["dvkib2_rpa01"] must be replaced
-/+ resource "azurerm_virtual_machine" "vm" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      ~ id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-RPA01" -> (known after apply)
      + license_type                     = (known after apply)
        name                             = "DVKIB2-RPA01"
      ~ tags                             = {
          - "Business Unit" = "Keais" -> null
          ~ "domain"        = "keaisinc" -> "Keais"
          ~ "environment"   = "development" -> "Development"
          + "managed by"    = "terraform"
            "owner"         = "Greg Johnson"
        }
      - zones                            = [] -> null
        # (4 unchanged attributes hidden)

      - boot_diagnostics {
          - enabled     = true -> null
            # (1 unchanged attribute hidden)
        }

      ~ identity {
          - identity_ids = [] -> null
          ~ principal_id = "63cc7c8d-966f-4519-b446-b6b8dc644d3b" -> (known after apply)
          ~ tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502" -> (known after apply)
            # (1 unchanged attribute hidden)
        }

      - os_profile { # forces replacement
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = true -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      ~ storage_data_disk {
          ~ managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/dvkib2-rpa01_datadisk01" -> "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/DVKIB2-RPA01_DataDisk01"
            name                      = "DVKIB2-RPA01_DataDisk01"
            # (7 unchanged attributes hidden)
        }

      ~ storage_os_disk {
          ~ managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/DVKIB2-RPA01_OsDisk_1_742f1b371716444f8dc0caacaef8d917" -> (known after apply)
            name                      = "DVKIB2-RPA01_OsDisk_1_742f1b371716444f8dc0caacaef8d917"
            # (8 unchanged attributes hidden)
        }

        # (1 unchanged block hidden)
    }

  # azurerm_virtual_machine.vm["dvkib2_rpa02"] must be replaced
-/+ resource "azurerm_virtual_machine" "vm" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      ~ id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-RPA02" -> (known after apply)
      + license_type                     = (known after apply)
        name                             = "DVKIB2-RPA02"
      ~ tags                             = {
          - "Business Unit" = "Keais" -> null
          ~ "domain"        = "keaisinc" -> "Keais"
          ~ "environment"   = "development" -> "Development"
          + "managed by"    = "terraform"
            "owner"         = "Greg Johnson"
        }
      - zones                            = [] -> null
        # (4 unchanged attributes hidden)

      - boot_diagnostics {
          - enabled     = true -> null
            # (1 unchanged attribute hidden)
        }

      ~ identity {
          - identity_ids = [] -> null
          ~ principal_id = "d7d174bb-1837-46a2-a066-98e390555b11" -> (known after apply)
          ~ tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502" -> (known after apply)
            # (1 unchanged attribute hidden)
        }

      - os_profile { # forces replacement
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = true -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      ~ storage_os_disk {
          ~ managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/DVKIB2-RPA02_OsDisk_1_b74846474fc644e7b0f2f0ba8ac0a700" -> (known after apply)
            name                      = "DVKIB2-RPA02_OsDisk_1_b74846474fc644e7b0f2f0ba8ac0a700"
            # (8 unchanged attributes hidden)
        }

        # (2 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["dvkib2_web01"] must be replaced
-/+ resource "azurerm_virtual_machine" "vm" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      ~ id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-WEB01" -> (known after apply)
      + license_type                     = (known after apply)
        name                             = "DVKIB2-WEB01"
      ~ tags                             = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      - zones                            = [] -> null
        # (4 unchanged attributes hidden)

      - boot_diagnostics {
          - enabled     = true -> null
            # (1 unchanged attribute hidden)
        }

      - os_profile { # forces replacement
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = true -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      ~ storage_data_disk (known after apply)

      ~ storage_os_disk {
          ~ managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/DVKIB2-WEB01_OsDisk_1_2983fb975b9d45bc806d054ea09c2dd7" -> (known after apply)
            name                      = "DVKIB2-WEB01_OsDisk_1_2983fb975b9d45bc806d054ea09c2dd7"
            # (8 unchanged attributes hidden)
        }

        # (1 unchanged block hidden)
    }

  # azurerm_virtual_machine.vm["dvkib2_web02"] must be replaced
-/+ resource "azurerm_virtual_machine" "vm" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      ~ id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIB2-WEB02" -> (known after apply)
      + license_type                     = (known after apply)
        name                             = "DVKIB2-WEB02"
      ~ tags                             = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      - zones                            = [] -> null
        # (4 unchanged attributes hidden)

      - boot_diagnostics {
          - enabled     = true -> null
            # (1 unchanged attribute hidden)
        }

      - os_profile { # forces replacement
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = true -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      ~ storage_data_disk (known after apply)

      ~ storage_os_disk {
          ~ managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/DVKIB2-WEB02_OsDisk_1_c3cb151d066246e88dee0e84a975e5f8" -> (known after apply)
            name                      = "DVKIB2-WEB02_OsDisk_1_c3cb151d066246e88dee0e84a975e5f8"
            # (8 unchanged attributes hidden)
        }

        # (1 unchanged block hidden)
    }

  # azurerm_virtual_machine.vm["dvkic1_pm01_test"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIC1-PM01-test"
        name                             = "DVKIC1-PM01-test"
      ~ tags                             = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (6 unchanged attributes hidden)

        # (3 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["dvkic1_sql03_test"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVKIC1-SQL03-test"
        name                             = "DVKIC1-SQL03-test"
      ~ tags                             = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (6 unchanged attributes hidden)

        # (5 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["dvwgb2_ftp01"] must be replaced
-/+ resource "azurerm_virtual_machine" "vm" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      ~ id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/DVWGB2-FTP01" -> (known after apply)
      + license_type                     = (known after apply)
        name                             = "DVWGB2-FTP01"
      ~ tags                             = {
          + "domain"      = "Keais"
          ~ "environment" = "development" -> "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      - zones                            = [] -> null
        # (4 unchanged attributes hidden)

      - boot_diagnostics {
          - enabled     = true -> null
            # (1 unchanged attribute hidden)
        }

      - os_profile { # forces replacement
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = true -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      ~ storage_data_disk (known after apply)

      ~ storage_os_disk {
          ~ managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/DVWGB2-FTP01_OsDisk_1_0c78f25d49004de5ab80fa6a95b15f2a" -> (known after apply)
            name                      = "DVWGB2-FTP01_OsDisk_1_0c78f25d49004de5ab80fa6a95b15f2a"
            # (8 unchanged attributes hidden)
        }

        # (1 unchanged block hidden)
    }

  # azurerm_virtual_machine.vm["keais_dev_test"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/KEAIS-DEV-test"
        name                             = "KEAIS-DEV-test"
      ~ tags                             = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (6 unchanged attributes hidden)

        # (5 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["keais_ship_test"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/KEAIS-SHIP-test"
        name                             = "KEAIS-SHIP-test"
      ~ tags                             = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (6 unchanged attributes hidden)

        # (3 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["keais_winweb_test"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/KEAIS-WINWEB-test"
        name                             = "KEAIS-WINWEB-test"
      ~ tags                             = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (6 unchanged attributes hidden)

        # (3 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["kib2_nsb01"] must be replaced
-/+ resource "azurerm_virtual_machine" "vm" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      ~ id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/KIB2-NSB01" -> (known after apply)
      + license_type                     = (known after apply)
        name                             = "KIB2-NSB01"
      ~ tags                             = {
          ~ "domain"      = "keaisinc" -> "Keais"
          ~ "environment" = "development" -> "Development"
          + "managed by"  = "terraform"
          ~ "owner"       = "Jaspinder Singh" -> "Greg Johnson"
          - "service"     = "NServiceBus" -> null
        }
      - zones                            = [] -> null
        # (4 unchanged attributes hidden)

      - boot_diagnostics {
          - enabled     = true -> null
            # (1 unchanged attribute hidden)
        }

      ~ identity {
          - identity_ids = [] -> null
          ~ principal_id = "76b968bc-de0e-4bf1-8df5-b50b21c6cb40" -> (known after apply)
          ~ tenant_id    = "e69ffd5c-8131-4a50-ac19-b4123a1e5502" -> (known after apply)
            # (1 unchanged attribute hidden)
        }

      - os_profile { # forces replacement
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = false -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      ~ storage_data_disk (known after apply)

      ~ storage_os_disk {
          ~ managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/KIB2-NSB01_osdisk1" -> (known after apply)  
            name                      = "KIB2-NSB01_osdisk1"
            # (8 unchanged attributes hidden)
        }

        # (1 unchanged block hidden)
    }

  # azurerm_virtual_machine.vm["kic1_sec01_test"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/KIC1-SEC01-test"
        name                             = "KIC1-SEC01-test"
      ~ tags                             = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (6 unchanged attributes hidden)

        # (4 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["qa_mrfile_test"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/QA-MRFILE-test"
        name                             = "QA-MRFILE-test"
      ~ tags                             = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (6 unchanged attributes hidden)

        # (5 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["qakib2_opg01"] must be replaced
-/+ resource "azurerm_virtual_machine" "vm" {
      + availability_set_id              = (known after apply)
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
      ~ id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/QAKIB2-OPG01" -> (known after apply)
      + license_type                     = (known after apply)
        name                             = "QAKIB2-OPG01"
      ~ tags                             = {
          + "domain"      = "Keais"
          ~ "environment" = "development" -> "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
      - zones                            = [] -> null
        # (4 unchanged attributes hidden)

      - boot_diagnostics {
          - enabled     = true -> null
            # (1 unchanged attribute hidden)
        }

      - os_profile { # forces replacement
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = false -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      ~ storage_data_disk (known after apply)

      ~ storage_os_disk {
          ~ managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/QAKIB2-OPG01_OsDisk_1_2ee33f23ad8f46a3b8950669b134e049" -> (known after apply)
            name                      = "QAKIB2-OPG01_OsDisk_1_2ee33f23ad8f46a3b8950669b134e049"
            # (8 unchanged attributes hidden)
        }

        # (1 unchanged block hidden)
    }

  # azurerm_virtual_machine.vm["sca1_iisdev_test"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/SCA1-IISDEV-test"
        name                             = "SCA1-IISDEV-test"
      ~ tags                             = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (6 unchanged attributes hidden)

        # (3 unchanged blocks hidden)
    }

  # azurerm_virtual_machine.vm["wgkib1_web02_test"] will be updated in-place
  ~ resource "azurerm_virtual_machine" "vm" {
      + delete_data_disks_on_termination = false
      + delete_os_disk_on_termination    = false
        id                               = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/virtualMachines/WGKIB1-WEB02-test"
        name                             = "WGKIB1-WEB02-test"
      ~ tags                             = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (6 unchanged attributes hidden)

        # (3 unchanged blocks hidden)
    }

  # azurerm_virtual_network.main_vnet will be updated in-place
  ~ resource "azurerm_virtual_network" "main_vnet" {
        id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/mr8-dev-scus-vnet"
        name                           = "mr8-dev-scus-vnet"
      ~ tags                           = {
          + "domain"      = "Keais"
            "environment" = "Development"
          + "managed by"  = "terraform"
          ~ "owner"       = "Jaspinder Singh" -> "Greg Johnson"
        }
        # (10 unchanged attributes hidden)
    }

  # azurerm_virtual_network.temp_vnet will be updated in-place
  ~ resource "azurerm_virtual_network" "temp_vnet" {
        id                             = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Network/virtualNetworks/temp-dev-vnet-01"
        name                           = "temp-dev-vnet-01"
      ~ tags                           = {
          + "domain"      = "Keais"
          + "environment" = "Development"
          + "managed by"  = "terraform"
          + "owner"       = "Greg Johnson"
        }
        # (10 unchanged attributes hidden)

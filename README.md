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

      - os_profile {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      - os_profile_windows_config {
          - enable_automatic_upgrades = true -> null
          - provision_vm_agent        = true -> null
            # (1 unchanged attribute hidden)
        }

      ~ storage_data_disk (known after apply)

      - storage_image_reference { # forces replacement
          - id        = "/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/IT-Prod-RG/providers/Microsoft.Compute/galleries/Ont_Prod1_scus_scg/images/AVD-KI-MR8-Win11/versions/0.0.1" -> null
            # (4 unchanged attributes hidden)
        }
      + storage_image_reference { # forces replacement
            id        = null
          + offer     = "office-365"
          + publisher = "microsoftwindowsdesktop"
          + sku       = "win11-24h2-avd-m365-ki"
          + version   = "latest"
        }

      ~ storage_os_disk {
          ~ managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/dvkib2-9_OsDisk_1_b8676dfef855414197a5c687543010ec" -> (known after apply)
            name                      = "dvkib2-9_OsDisk_1_b8676dfef855414197a5c687543010ec"
            # (8 unchanged attributes hidden)
        }
    }

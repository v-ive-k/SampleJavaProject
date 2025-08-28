os_disks = {
  "dvkib2_9" = {
    name                 = "dvkib2-9_OsDisk_1_b8676dfef855414197a5c687543010ec"
    disk_size_gb         = 256
    storage_account_type = "StandardSSD_LRS"
    os_type              = "Windows"
    hyper_v_generation   = "V2"
  },


"dvkib2_9" = {
    name                    = "dvkib2-9"
    size                    = "Standard_D4as_v5"
    nic_key                 = "dvkib2_9"
    os_disk_key             = "dvkib2_9"
    boot_diag_uri           = ""
    identity_type           = ""
    os_disk_creation_option = "Attach"
    image_reference = {
      id = "/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/IT-Prod-RG/providers/Microsoft.Compute/galleries/Ont_Prod1_scus_scg/images/AVD-KI-MR8-Win11/versions/0.0.1"
    }
    os_profiles = {
      admin_username = "ontadmin"
      admin_password = ""
      computer_name  = "dvkib2-9"
    }
    windows_config = {
      provision_vm_agent        = true
      enable_automatic_upgrades = true
    }



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
      + os_profile {
          # At least one attribute in this block is (or was) sensitive,
          # so its contents will not be displayed.
        }

      ~ storage_data_disk (known after apply)

      ~ storage_image_reference (known after apply)
      - storage_image_reference {
          - id        = "/subscriptions/58e2361d-344c-4e85-b45b-c7435e9e2a42/resourceGroups/IT-Prod-RG/providers/Microsoft.Compute/galleries/Ont_Prod1_scus_scg/images/AVD-KI-MR8-Win11/versions/0.0.1" -> null
            # (4 unchanged attributes hidden)
        }

      ~ storage_os_disk {
          ~ create_option             = "FromImage" -> "Attach"
          ~ managed_disk_id           = "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/MR8-DEV-RG/providers/Microsoft.Compute/disks/dvkib2-9_OsDisk_1_b8676dfef855414197a5c687543010ec" -> "/subscriptions/ffe5c17f-a5cd-46d5-8137-b8c02ee481af/resourceGroups/mr8-dev-rg/providers/Microsoft.Compute/disks/dvkib2-9_OsDisk_1_b8676dfef855414197a5c687543010ec" # forces replacement
            name                      = "dvkib2-9_OsDisk_1_b8676dfef855414197a5c687543010ec"
            # (7 unchanged attributes hidden)
        }

        # (1 unchanged block hidden)

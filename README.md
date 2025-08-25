dynamic "storage_image_reference" {
    for_each = each.value.os_disk_creation_option == "FromImage" ? [true] : []
    content {
      # If an image ID is provided, use it; otherwise use P/O/S/V.
      id        = try(each.value.image_reference.id, null)
      publisher = try(each.value.image_reference.publisher, null)
      offer     = try(each.value.image_reference.offer, null)
      sku       = try(each.value.image_reference.sku, null)
      version   = try(each.value.image_reference.version, null)
    }
  }

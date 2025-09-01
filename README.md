dynamic "os_profile" {
  for_each = try(each.value.os_profiles, null) != null ? [each.value.os_profiles] : []
  content {
    computer_name  = lookup(os_profile.value, "computer_name", null)
    admin_username = os_profile.value.admin_username

    # Prefer generated KV-backed password (when use_kv_password=true),
    # else use non-empty admin_password from tfvars, else null
    admin_password = coalesce(
      try(random_password.vm_pw[each.key].result, null),
      (
        length(trimspace(lookup(os_profile.value, "admin_password", ""))) > 0
      ) ? lookup(os_profile.value, "admin_password", "") : null
    )
  }
}

admin_password = (
  try(length(trimspace(each.value.os_profiles.admin_password)) > 0, false)
  ? each.value.os_profiles.admin_password
  : random_password.new_vm_pw[each.key].result
)

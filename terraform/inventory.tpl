[inception]
${ip_address} ansible_user=${ssh_user} ansible_ssh_private_key_file=${replace(ssh_key, ".pub", "")} ansible_ssh_common_args='-o StrictHostKeyChecking=no'
output "vm_public_ip" {
  value       = google_compute_address.static_ip.address
  description = "Public IP address of the Inception VM"
}

output "vm_name" {
  value = google_compute_instance.vm_instance.name
}
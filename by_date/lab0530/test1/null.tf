data "template_file" "haproxy_cfg" {
  template = file("${path.module}/templates/haproxy.cfg.tpl")
  vars = {
    backend_ips = join("\n", [
        for web in openstack_compute_instance_v2.web :
        "   server ${web.name} ${web.network[0].fixed_ip_v4}:80 check"
    ])
  }
}

resource "null_resource" "configure_haproxy" {
  provisioner "file" {
    content = data.template_file.haproxy_cfg.rendered
    destination = "/tmp/haproxy.cfg"

    connection {
      type = "ssh"
      host = openstack_networking_floatingip_v2.haproxyfip.address
      user = "ubuntu"
      private_key = tls_private_key.private_key.private_key_pem
    }
  }

  provisioner "remote-exec" {
    inline = [
        "sudo apt-get update && sudo apt update",
        "sudo apt install -y haproxy git",
        "sudo mv /tmp/haproxy.cfg /etc/haproxy/haproxy.cfg",
        "sudo systemctl restart haproxy"
    ]

    connection {
      type = "ssh"
      host = openstack_networking_floatingip_v2.haproxyfip.address
      user = "ubuntu"
      private_key = tls_private_key.private_key.private_key_pem
    }
  }

  depends_on = [ openstack_compute_floatingip_associate_v2.haproxyfip_asso ]
}
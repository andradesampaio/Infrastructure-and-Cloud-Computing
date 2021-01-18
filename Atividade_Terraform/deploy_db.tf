resource "time_sleep" "wait_30_seconds" {
  depends_on = [azurerm_linux_virtual_machine.vmdb]
  create_duration = "30s"
}

resource "null_resource" "upload_db" {
    provisioner "file" {
        connection {
            type = "ssh"
            user = var.user
            password = var.password
            host = data.azurerm_public_ip.ip_data_db.ip_address
        }
        source = "mysql"
        destination = "/home/asampaio"
    }

    depends_on = [ time_sleep.wait_30_seconds ]
}

resource "null_resource" "deploy_db" {
    triggers = {
        order = null_resource.upload_db.id
    }
    provisioner "remote-exec" {
        connection {
            type = "ssh"
            user = var.user
            password = var.password
            host = data.azurerm_public_ip.ip_data_db.ip_address
        }
        inline = [
            "sudo apt-get update",
            "sudo apt-get install -y puppet=5.4.0-2ubuntu3",
            "sudo mkdir -p /etc/puppet/modules",
            "sudo puppet module install puppetlabs/mysql --version 10.8.0",
            "sudo puppet apply /home/asampaio/mysql/mysql_plugin.pp",
        ]
    }
}
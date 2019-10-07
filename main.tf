resource "aws_instance" "web" {
    ami = "ami-c55673a0"
    instance_type = "${var.turbonomic_instance_size}"
    key_name = "${var.aws_key_name}"

    tags = {
        Terraform = "true"
        ProvisionedBy = "Project Terra"
        Turbonomic = "true"
    }
}


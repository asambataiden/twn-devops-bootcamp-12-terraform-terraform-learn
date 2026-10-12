vpc_cidr_block = "10.0.0.0/16"

private_subnet_cidr_blocks = [
  "10.0.1.0/24",
  "10.0.2.0/24",
  "10.0.3.0/24",
]

public_subnet_cidr_blocks = [
  "10.0.101.0/24",
  "10.0.102.0/24",
  "10.0.103.0/24",
]
subnet_cidr_block = "10.0.10.0/24"
availability_zone = "eu-north-1a"
env_prefix = "dev"
my_ip = "92.75.249.142/32"
instance_type = "t3.micro"
ssh-key-name = "server-key-pair"
public_key_location = "/Users/aiden-it-consulting/.ssh/id_ed25519_github_asambataiden.pub"
user_data_script_location = "./modules/webserver/scripts/entry-script.sh"
image-name = "al2023-ami-*-kernel-6.18-x86_64"
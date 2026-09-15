## Introduction
In this module I am expanding what I learned in Module 3. There I created a new VPC, internet gateway, subnet, route table, route table association, and an EC2 instance. Here I am expanding the scope by creating two subnets and placing an EC2 instance in each of these subnets, followed by adding an elastic load balancer to load balance the traffic between the two instances. I also attach a public DNS record with the load balancer.

## Updates made
- Added another subnet address space to the variables file, which is referenced while creating the extra subnet in `main.tf`.
- A new resource `aws_subnet` was added that uses a different address space and a separate availability zone.
- A new resource `aws_route_table_association` was added for the new subnet.
- A new resource `aws_security_group` was added for the new elastic load balancer with correct ingress and egress rules.
- The existing ingress rule for the `aws_security_group` for `nginx-sg` was updated to point to `var.network_address_space` to allow traffic from the internal network address space of the VPC. This allows the load balancer to reach it.
- A new resource `aws_elb` was added, provided with values for which subnets to associate with the load balancer, which security groups to attach, the instances to associate (which service the incoming requests), and the listener.
- A new resource `aws_instance` placed in the second subnet, serving up a different message on the index page.

## To use this code
Rename the `terraform.tfvars.example` file to `terraform.tfvars` and update the values of the variables. Prior to running `terraform init`, ensure a key-pair is created in the same location that you have in the `terraform.tfvars` (in my case it is us-east-2, so the key-pair was created in the same region).

I ran the below commands from the same location where the `.tf` files were stored:

```bash
terraform init
terraform fmt   # optional
terraform plan -out elasticlp.tfplan
terraform apply "elasticlp.tfplan"
```

Once done, I was able to launch the webpage. After I was convinced this was working as expected, I destroyed the resources using the command:

```bash
terraform destroy
```

## Observation
I did not receive any errors this time. However, I did observe that after getting the output of the `aws_elb_public_dns`, it took a little while to get a response in the browser (warm-up). Then each refresh kept toggling the response between the blue team and the green team and back.

> This is an early learning example that authenticates with long-lived IAM user keys and an EC2 key-pair; see [`add-github-oidc-role`](../add-github-oidc-role/ReadMe.md) for the OpenID Connect approach that avoids static keys.

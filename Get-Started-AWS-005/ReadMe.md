## Introduction
In this module I am expanding what I learned in Module 3. There I created a new vpc, internet gateway, subnet, route table, route table association, and an ec2 instance. Here I am expanding the scope by creating two subnets and placing an ec2 instance in each of these subnets followed by adding an elastic load balancer to load balance the traffic between the two instances. Also attach a public dns record with the load balancer.

## Updates made
I added another subnet address space to the variables file which is referenced while creating the extra subnet in main.tf
</br>A new resource "aws_subnet" was added that is using a different address space and a separate availability zone.
</br>A new resource "aws_route_table_assocation" was added for the new subnet
</br>A new resource "aws_security_group" was added for the new elastic load balancer with correct ingress and egress rules.
</br>The existing ingress rule for the "aws_security_group" for nginx-sg was updated to point to var.network_address_space to allow traffic from the internal network address space of the vpc. This will allow the load-balancer to get to it.
</br>A new resource "aws_elb" was added where it was provided with values for what subnets to associate with that load balancer, what security groups to attach with the load-balancer, the instances to associate with the load-balancer which will service the requests coming in, and the listner.
</br>A new resource "aws_instance" placed in the second subnet and serving up a different message on the index page.

## To use this code
Rename the terraform.tfvars.example file to terraform.tfvars and update the values of the variables. Prior to running <code>terraform init</code> ensure a key-pair is created in the same location that you have in the terraform.tfvars (in my case it is us-east-2 so the key-pair was created in the same region).</br> I ran below commands from the same location where the .tf files were stored.</br>
<code>terraform init</code></br>
<code>terraform fmt</code> (this is optional)</br>
<code>terraform plan -out elasticlp.tfplan</code></br>
<code>terraform apply "elasticlp.tfplan"</code></br>
Once done, I was launch the webpage.
</br> After I was convinced this was working as expected, I destroyed the resouces using the command: <code>terraform destroy</code>

## Observation
I did not receive any errors this time, however I did observe that after getting the output of the "aws_elb_public_dns", it took a little while to get a response in the browser. Warm-up. And then each refresh kept toggling the response from the blue team to the green team and back.
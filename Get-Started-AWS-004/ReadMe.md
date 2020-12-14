## Introduction
The contents of this folder is just picking up from the previous one [AWS-003]. In the previous module I leart how to create a new vpc, internet gateway, subnet, route table and route table association. In this module, I am utilizing the existing default vpc.

## To use this code
Rename the terraform.tfvars.example file to terraform.tfvars and update the values of the variables. Prior to running <code>terraform init</code> ensure a key-pair is created in the same location that you have in the terraform.tfvars (in my case it is us-east-2 so the key-pair was created in the same region).</br> I ran below commands from the same location where the .tf files were stored.</br>
<code>terraform init</code></br>
<code>terraform fmt</code> (this is optional)</br>
<code>terraform plan -out ec2provision.tfplan</code></br>
<code>terraform apply "ec2provision.tfplan"</code></br>
Once done, I was able to login to the machine with the value provided in the outputs, the public_dns of the machine.
</br> After I was convinced this was working as expected, I destroyed the resouces using the command: <code>terraform destroy</code>
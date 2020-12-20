## Introduction
In this module I am going to explore using <code>terraform workspace</code>



## To use this code
Rename the terraform.tfvars.example file to terraform.tfvars and update the values of the variables. Prior to running <code>terraform init</code> ensure a key-pair is created in the same location that you have in the terraform.tfvars (in my case it is us-east-2 so the key-pair was created in the same region).</br> I ran below commands from the same location where the .tf files were stored.</br>
<code>terraform init</code></br>
<code>terraform fmt</code> (this is optional)</br>
<code>terraform workspace list</code>(this displays a list of workspaces available. By default, the 'default' workspace is selected. An * next to it</br>
To create a new workspace named "Development" and switch to that workspace use the command: <code>terraform workspace new Development</code></br>
<code>terraform plan -out globodeploy.tfplan</code></br>
<code>terraform apply "globodeploy.tfplan"</code></br>
Once done, I was launch the webpage from the output of the aws_elb_publich_dns.
</br> After I was convinced this was working as expected, I destroyed the resouces using the command: <code>terraform destroy</code>

## Observation/Errors

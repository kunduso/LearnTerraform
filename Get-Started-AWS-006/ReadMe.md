## Introduction
In module 5, I had two ec2 instances running in two subnets in different availability groups inside a vpc. And these two ec2 instances were serving requests coming in from an elastic load balancer. In this module, we are adding a s3 bucket to the infrastructure. The s3 bucket will host the website files and the two ec2 instances will pull the website files from the s3 bucket and publish them out. We will need to give permission to the two ec2 instances to be able to pull information out of the s3 bucket (IAM-Role). Also the logs from the ec2 instances will get stored in the s3 bucket. Hence the two ec2 instances need read and write permission to the s3 bucket. I will also tag these resources to be able to uniquely identify them.



## To use this code
Rename the terraform.tfvars.example file to terraform.tfvars and update the values of the variables. Prior to running <code>terraform init</code> ensure a key-pair is created in the same location that you have in the terraform.tfvars (in my case it is us-east-2 so the key-pair was created in the same region).</br> I ran below commands from the same location where the .tf files were stored.</br>
<code>terraform init</code></br>
<code>terraform fmt</code> (this is optional)</br>
<code>terraform plan -out globodeploy.tfplan</code></br>
<code>terraform apply "globodeploy.tfplan"</code></br>
Once done, I was launch the webpage from the output of the aws_elb_publich_dns.
</br> After I was convinced this was working as expected, I destroyed the resouces using the command: <code>terraform destroy</code>

## Observation/Errors
The first time I ran <code>terraform apply</code> I got a strange error on the nginx code that was running on the ec2 instances as part of running the <code>remote-exec</code> provisioner. The output statement was not verbose, just that error occured on line 1 of nginx, line 2 of nginx etc. I checked that the web page lauched correctly so it was not that the ec2 instances were having some issues trying to reach out to the s3 bucket. I logged in to my AWS console and found that there was no folder with the name "nginx" in the "globo-dev-xxxxx" bucket. There was only one folder -"website". So that gave me some more hint and the first few statements in the <code>provisioner "remote-exec"</code> block were actually to copy the logs. I checked ned1313's readme about more info and found an interesting detail about [line-endings](https://github.com/ned1313/Getting-Started-Terraform#line-endings). I made that change and reran and this time there were no errors. Also the "nginx" folder was listed inside the bucket.
</br>When I tried to commit this code, on <code>git add .</code> I got a warning message that <code>LF will be replaced by CRLF in Get-Started-AWS-006/ec2.tf.</code> I got this message for all the files. So I'll have to remember to update that before I rerun this code.
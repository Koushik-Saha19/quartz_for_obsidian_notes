

## Important commands
----
**terraform init** - It initializes terraform working directory and downloads the provider plugins. Once we run this command it will create .terraform directory.

- **terraform validate**
- terraform plan
- terraform apply
	- terraform apply --auto-approve
- terraform destroy
	- terraform destroy --auto-approve

### terraform import
------------------
The `terraform import` command is used to **bring an existing real-world infrastructure resource under Terraform management**.
Example:
You manually created an AWS EC2 instance, but now you want Terraform to manage it. Instead of destroying and recreating it via Terraform, you **import** it into your state.

#### What it does:

- **Adds a mapping** between your Terraform resource block and the existing real-world resource in the state file (`terraform.tfstate`).
- **Does NOT create or modify** any resource.
- You must already have the corresponding `.tf` code written — or write it after import to match the imported resource.


#### Example:

`terraform import aws_instance.my_server i-1234567890abcdef0`

This tells Terraform:

> “Hey, the EC2 instance with ID `i-1234567890abcdef0` should be tracked as `aws_instance.my_server`.”
#### 🚨 Important:

- After import, **Terraform knows about the resource**, but it doesn't write the `.tf` code for you — you must create the matching resource block manually.
- If `.tf` code doesn't match the real resource, `terraform plan` may show unexpected changes.


### terraform out
----------
To retrieve information from any existing resource


### terraform refresh 
-----------------
- When we do any manual changes in the resources from portal (where resource was deployed by terraform), in that case if we directly run the terraform code, all those changes will be destroyed.
- To avoid this, we need to two things -
	1. To reflect that changes in state file we need to run "terraform refresh". 
	2. And after that we need to manually implement the changes in terraform files, Otherwise there will be difference in current state (your terraform files) and desired state (your state file or .tfstate file). As your state file is already updated so you need to match the state file (current state) with desired state (that is your config mentioned in .tf files)


### terraform state mv
-------------
When we change any resource name in terraform files, then to reflect that change in terraform state file we need to run this command. Here the context is, we are not changing any real world infra name (which might exist in your cloud like Azure or AWS, etc.), but we are changing the logical name which we used to point that resource. In variable or tfvars files we won't change the original name which we want to give the resource (or the name that will be visible in web portals).

When you **change the name** of a resource in your Terraform code (e.g., from `aws_instance.old_name` to `aws_instance.new_name`), Terraform doesn't automatically recognize it as the same resource — it will think the old one was deleted and a new one needs to be created.

To **preserve the existing infrastructure** and **update the state file** to reflect the new name **without recreating the resource**, you use:


`terraform state mv aws_instance.old_name aws_instance.new_name`

#### 🔍 Why use it?
- It updates the Terraform **state file** to point the new logical name to the existing resource.
- **Prevents unnecessary destruction and recreation** of infrastructure.

The **real-world resource remains untouched and unaffected**. 

When you run:

`terraform state mv aws_instance.old_name aws_instance.new_name`

You're only telling Terraform:

> “Hey, this existing resource (already provisioned) should now be tracked under this new name in the state file.”

#### 🔒 What happens internally:

- **No changes** are made to the actual cloud resource (e.g., EC2 instance, S3 bucket, etc.).
- Only the **Terraform state file** (`terraform.tfstate`) is updated to reflect the new logical name.
- During the next `terraform plan`, Terraform sees **no changes needed** for that resource.
#### 🔄 Without `state mv`, Terraform would:

- Think the old resource was **deleted**.
- Try to **create a new** one with the new name.
- Result: Unnecessary **resource recreation** and potential **downtime**.
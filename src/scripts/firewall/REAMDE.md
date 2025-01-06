# Scripts for allocating and deallocating an azure firewall

The azure firewall is by far the most costly component of the infrastructure, and costs approximately 250kr per day. It is therefore preferred if the firewall is deallocated (i.e. not running/accumulating cost) when you are not actively using the environment. This could for example be on the weekends, during vacations or when you are focusing on other aspects of your thesis.

** These scripts should be run in the azure cloud shell, in powershell mode **

Replace the placeholders for resource group, firewall, virtual network, firewall policy and public ip addresses with their respective names.

Run "deallocate.ps1" in order to stop costs from running when you are not using the test environment.

The script will take approximately 6 minutes to complete. It will not provide any progress before it is finished.

When you are ready to use the test environment again, simply run "allocate.ps1" from the azure cloud shell. This will again take approx. 6 minutes, and will not provide any progress until it is finished.

## Kubeadm Lab Azure Infra Setup
This repo contains IaC scripts to quickly bootstrap an environemnt in Azure, with one master and two nodes, ready for the kubeadm lab.  
All three VMs are created with equal resources: Standard_D2as_v4 tier of Ubuntu 18.04-LTS.  

*Note: Remeber to stop the VMs when not used.*

To deploy resource in terraform:
```
> terraform init
> terraform plan -out res.tfplan
> terraform apply res.tfplan
```

#### Todo
- [x] Powershell to stop all VMs
- [ ] Ansible to stop all VMs - Pending by Ansible issue with Azure Cloud Shell
- [ ] Check port requirements for NSG during the kubeadm lab

## Kubeadm Lab in Azure
This repo contains IaC scripts to quickly bootstrap an environemnt in Azure, with one master and two worker nodes, ready for the kubeadm lab. 

###  Infra Setup
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
- [x] DIY jumpbox to replace Azure Bastion
- ~~[ ] Ansible to stop all VMs - Blocked by Ansible issue with Azure Cloud Shell~~
- [x] Check port requirements for NSG during the kubeadm lab

---

### Kubeadm lab
*Note: All VMs means master and nodes.*
#### Step 1 SSH into master and nodes
Establish SSH connection to master and nodes VMs using jumpbox. eg. using putty to create 3 sessions.

#### Step 2 Update apt packages and PPAs, then install Docker CE (All VMs)
```
sudo apt-get update
sudo apt install docker.io -y
sudo systemctl enable docker
```

#### Step 3 Add Kubeadm repo and install kubeadm, kubectl and kubelet (All VMs)
```
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt install -y kubeadm=1.18.1-00 kubelet=1.18.1-00 kubectl=1.18.1-00
```

#### Step 4 Initialize Kubeadm on master (Master only)
```
sudo kubeadm init --kubernetes-version=1.18.1
```
Keep the generated command: eg.
```
kubeadm join 10.0.0.4:6443 --token t299v2.c8vcbm33kfi1x0nt \
    --discovery-token-ca-cert-hash sha256:a5b1372829885851ca72ec1502414460c2ed5124e83704c8c07b3d49b137a229
```

### Step 5 Enable `kubectl` command on master without root access (Master only)
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

### Step 6 Join worker nodes to cluster (Nodes only)
```
sudo kubeadm join 10.0.0.4:6443 --token t299v2.c8vcbm33kfi1x0nt \
    --discovery-token-ca-cert-hash sha256:a5b1372829885851ca72ec1502414460c2ed5124e83704c8c07b3d49b137a229
```

### Step 7 Install one of the CNI plugin on master (Master only)
#### Option: Calico
```
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```
#### Option: Weave net CNI
```
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```

### Step 8 Verify K8s working (Master only)
```
[watch] kubectl get nodes
[watch] kubectl get pods --all-namespaces
```

### References
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
- https://docs.projectcalico.org/getting-started/kubernetes/quickstart
- https://help.mayadata.io/hc/en-us/articles/360036744451-Creating-an-unmanaged-Kubernetes-cluster-in-Azure-using-kubeadm
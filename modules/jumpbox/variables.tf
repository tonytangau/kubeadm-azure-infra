variable "rg" {
    description = "The name of resource group"
    default     = "k8s-rg"
}

variable "location" {
    description = "The location of resource group"
    default     = "southeastasia"
}

variable "subnetId" {
    description = "The subnet ID to place jumpbox"
}
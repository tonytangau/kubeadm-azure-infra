$RG = "k8s-rg"

Get-AzVM -ResourceGroupName $RG | Foreach-Object { 
    Stop-AzVM -ResourceGroupName $RG -Name $_.Name -Force -ErrorAction SilentlyContinue 
}
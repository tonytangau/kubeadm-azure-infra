$RG = "k8s-rg"

Get-AzVM -ResourceGroupName $RG | Foreach-Object { 
    Start-AzVM -ResourceGroupName $RG -Name $_.Name -ErrorAction SilentlyContinue 
}
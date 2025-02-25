# Author: William Lam
# Website: www.williamlam.com
# Contributors: Abbed Sedkaoui
# Website: www.strivevirtually.net

# vCenter Server used to deploy vSphere with Kubernetes Lab
$VIServer = "192.168.1.51"
$VIUsername = "administrator@vsphere.local"
$VIPassword = "VMware1!"

# Full Path to both the Nested ESXi 8.0 VA, Extracted VCSA 8.0 ISO & NSX-T 4.1.1 OVAs
$NestedESXiApplianceOVA = "N:\ISOs\vsphere-with-tanzu-nsxt-automated-lab-deployment-nsx4\Nested_ESXi8.0u2_Appliance_Template_v2.ova"
$VCSAInstallerPath = "N:\ISOs\vsphere-with-tanzu-nsxt-automated-lab-deployment-nsx4\VMware-VCSA-all-8.0.2-22617221"
$NSXTManagerOVA = "N:\ISOs\vsphere-with-tanzu-nsxt-automated-lab-deployment-nsx4\nsx-unified-appliance-4.1.2.1.0.22667865-le.ova"
$NSXTEdgeOVA = "N:\ISOs\vsphere-with-tanzu-nsxt-automated-lab-deployment-nsx4\nsx-edge-4.1.2.1.0.22667870-le.ova"

# TKG Content Library URL
$TKGContentLibraryName = "TKG-Content-Library"
$TKGContentLibraryURL = "https://wp-content.vmware.com/v2/latest/lib.json"

# Nested ESXi VMs to deploy
$NestedESXiHostnameToIPs = @{
	"tanzu-esxi-7" = "172.17.31.113"
	#"tanzu-esxi-8" = "172.17.31.114"
	#"tanzu-esxi-9" = "172.17.31.115"
	}

# Nested ESXi VM Resources
$NestedESXivCPU = "4"
$NestedESXivMEM = "28" #GB
$NestedESXiCachingvDisk = "8" #GB
$NestedESXiCapacityvDisk = "400" #GB
$NestedESXiBootDisk = "32" #GB

# VCSA Deployment Configuration
$VCSADeploymentSize = "tiny"
$VCSADisplayName = "tanzu-vcsa-4"
$VCSAIPAddress = "172.17.31.112"
$VCSAHostname = "tanzu-vcsa-4.abidi.systems" #Change to IP if you don't have valid DNS
$VCSAPrefix = "24"
$VCSASSODomainName = "vsphere.local"
$VCSASSOPassword = "VMware1!"
$VCSARootPassword = "VMware1!"
$VCSASSHEnable = "true"

# General Deployment Configuration for Nested ESXi, VCSA & NSX VMs
$VMDatacenter = "TLS-Datacenter"
$VMCluster = "Cluster-01"
$VMNetwork = "VMTRUNK" # This Outer portgroup needs be created before running script with VLAN 4095
$NestedVMNetwork = "VM Network" 
$NestedVMNetworkVLanId = "1731"
$vmk0VLanId = "1731" # The vmk0 will be migrated to VDS $NewVCVDSName in PortGroup $NewVCDVPGName
$MGMTNetwork = "1731-Network" # This Outer portgroup needs be created before running script with same VLAN as $NestedVMNetworkVLanId and will ne used by VCSA, NSX Manager and NSX Edges for Management Network
$VMDatastore = "datastore1"
$VMNetmask = "255.255.255.0"
$VMGateway = "172.17.31.253" #This interface vlan IP should be created on virtual router with vlan $NestedVMNetworkVLanId
$VMDNS = "192.168.1.100"
$VMNTP = "pool.ntp.org"
$VMPassword = "VMware1!"
$VMDomain = "abidi.systems"
$VMSyslog = "172.17.31.112"
$VMFolder = "Tanzu"
# Applicable to Nested ESXi only
$VMSSH = "true"
$VMVMFS = "false"

# Name of new vSphere Datacenter/Cluster when VCSA is deployed
$NewVCDatacenterName = "Tanzu-Datacenter"
$NewVCVSANClusterName = "Workload-Cluster-1"
$NewVCVDSName = "Tanzu-VDS1"
$NewVCDVPGName = "DVPG-Management Network"
$NewVCVDSName2 = "Tanzu-VDS2"
$vsanDatastoreName = "vsanDatastore-1"

# Tanzu Configuration
$StoragePolicyName = "tanzu-gold-storage-policy"
$StoragePolicyTagCategory = "tanzu-demo-tag-category"
$StoragePolicyTagName = "tanzu-demo-storage"
$hostFailuresToTolerate = 0 # 0-3, number of host failure to tolerate, default is 1 failure with 3 nodes, 0 allow single node VSAN
$DevOpsUsername = "devops-1"
$DevOpsPassword = "VMware1!"

# NSX-T Configuration
$NSXLicenseKey = ""
$NSXRootPassword = "VMware1!VMware1!"
$NSXAdminUsername = "admin"
$NSXAdminPassword = "VMware1!VMware1!"
$NSXAuditUsername = "audit"
$NSXAuditPassword = "VMware1!VMware1!"
$NSXSSHEnable = "true"
$NSXEnableRootLogin = "true"
$NSXVTEPNetwork = "VMTRUNK" # This portgroup needs be created before running script on a separate vswitch with MTU 1700

# Transport Node Profile
$TransportNodeProfileName = "Tanzu-Host-Transport-Node-Profile"

# TEP IP Pool
$TunnelEndpointName = "TEP-IP-Pool"
$TunnelEndpointDescription = "Tunnel Endpoint for Transport Nodes"
$TunnelEndpointIPRangeStart = "172.30.1.10"
$TunnelEndpointIPRangeEnd = "172.30.1.30"
$TunnelEndpointCIDR = "172.30.1.0/24"
$TunnelEndpointGateway = "172.30.1.253" #This interface vlan IP should be created on virtul router with vlan $ESXiUplinkProfileTransportVLAN and MTU 1700

# Transport Zones
$OverlayTransportZoneName = "TZ-Overlay"
$OverlayTransportZoneHostSwitchName = "nsxHostSwitch2"
$VlanTransportZoneHostSwitchName = "nsxHostSwitch1"
$VlanTransportZoneName = "TZ-VLAN"
$VlanTransportZoneNameHostSwitchName = "edgeswitch"

# Network Segment
$NetworkSegmentName = "Tanzu-Segment"
$NetworkSegmentVlan = "1751"

# T0 Gateway
$T0GatewayName = "Tanzu-T0-Gateway"
$T0GatewayInterfaceAddresses = "172.17.51.121","172.17.51.122"#,"172.17.51.123","172.17.51.124" # should be a routable address, one per edge nodes
$T0GatewayInterfacePrefix = "24"
$T0GatewayInterfaceStaticRouteName = "Tanzu-Static-Route"
$T0GatewayInterfaceStaticRouteNetwork = "0.0.0.0/0"
$T0GatewayInterfaceStaticRouteAddress = "172.17.51.253" #This interface vlan IP should be created on virtual router with vlan $EdgeUplinkProfileTransportVLAN/$NetworkSegmentVlan

# Project ,Public Ip Block, Private Ip Block
$ProjectName = "Project-2" # Up to 5 T0 VRF per Project with Internet access via Public IP and NAT from Private IP Blocks
$ShortId = "PRJ2"
$ProjectPUBipblockName = "VRF-1683-192-168-3-0-26"
$ProjectPUBcidr = "192.168.3.0/26" # Maximum 5 Public Ip Block per Project
$VpcProjectPRIVipblockName = "VRF-1683-10-10-160-0-23"
$VpcProjectPRIVcidr = "10.10.160.0/23"

# VPC, Public Subnet, Private Subnet
$VpcName = "VPC-360"
$VpcPublicSubnet = "192-168-3-32-28"
$VpcPublicSubnetIpaddresses = "192.168.3.32/28" # Must be subset of Project Public cidr, and can't use the first or last subnet block size 
$VpcPublicSubnetSize = 16 # Minimum 16
$VpcPrivateSubnet = "10-10-160-0-24"
$VpcPrivateSubnetIpaddresses = "10.10.160.0/24" # Must be subset of Project Private cidr
$VpcPrivateSubnetSize = 256 # Minimum 16


# T0 VRF Gateway
$VRFAccessVlanID = "1683" #any integer from 1-4094 (Equivalent of "allowed vlan" in trunk switchport on the underlay)
$NetworkSegmentVlanProjectVRF = "1683-1687" #Trunk require minimum 2 vlans even if the second isn't used at the moment
$NetworkSegmentProjectVRF = "T0-VRF-$NetworkSegmentVlanProjectVRF-$ProjectName" #"UPLINK-TRUNK"



$T0GatewayVRFName = "T0-VRF-$VRFAccessVlanID-$ProjectName-Gateway"
$T0GatewayVRFInterfaceAddresses = "192.168.3.121","192.168.3.122"#,"192.168.3.123","192.168.3.124" # should be a routable address on the vrf's vlan, one per edge nodes
$T0GatewayVRFInterfacePrefix = "24"
$T0GatewayVRFInterfaceStaticRouteName = "T0-VRF-$VRFAccessVlanID-$ProjectName-Static-Route"
$T0GatewayVRFInterfaceStaticRouteNetwork = "0.0.0.0/0"
$T0GatewayVRFInterfaceStaticRouteAddress = "192.168.3.253" #This interface vlan IP should be created on virtual router with vlan $VRFAccessVlanID

# Which T0 to use for the Project External connectivity : $T0GatewayName or $T0GatewayVRFName
$ProjectT0 = $T0GatewayVRFName

# Uplink Profiles
$ESXiUplinkProfileName = "ESXi-Host-Uplink-Profile"
$ESXiUplinkProfilePolicy = "LOADBALANCE_SRCID"
$ESXiUplinkNames = @("uplink1","uplink2")
$ESXiUplinkProfileTransportVLAN = "301"

$EdgeUplinkProfileName = "Edge-Uplink-Profile"
$EdgeUplinkProfilePolicy = "LOADBALANCE_SRCID"
$EdgeOverlayUplinkNames = @("uplink1","uplink2")
$EdgeOverlayUplinkProfileActivepNICs = "fp-eth0","fp-eth3"
$EdgeUplinkNames = @("tep-uplink-1","tep-uplink-2")
$EdgeUplinkProfileActivepNICs = "fp-eth1","fp-eth2"
$EdgeUplinkProfileTransportVLAN = "1751"


$EdgeUplinkProfileMTU = "1700"


$Orgs = "default"


# Edge Cluster
$EdgeClusterName = "Edge-Cluster-01"

# NSX-T Manager Configurations
$NSXTMgrDeploymentSize = "small"
$NSXTMgrvCPU = "6" #override default size
$NSXTMgrvMEM = "24" #override default size
$NSXTMgrDisplayName = "tanzu-nsx-4"
$NSXTMgrHostname = "tanzu-nsx-4.abidi.systems"
$NSXTMgrIPAddress = "172.17.31.118"

# NSX-T Edge Configuration
$NSXTEdgeDeploymentSize = "medium"
$NSXTEdgevCPU = "4" #override default size
$NSXTEdgevMEM = "8" #override default size
$NSXTEdgeHostnameToIPs = @{
	"tanzu-nsx-edge1-4a" = "172.17.31.116"
	"tanzu-nsx-edge2-4a" = "172.17.31.117"
	#"tanzu-nsx-edge3-4a" = "172.17.31.119"
	#"tanzu-nsx-edge4-4a" = "172.17.31.120"
}
$NSXTEdgeAmdZenPause = 0 # Pause the script to workaround for AMD Zen DPDK FastPath Capable following https://williamlam.com/2020/05/configure-nsx-t-edge-to-run-on-amd-ryzen-cpu.html

# Advanced Configurations
# Set to 1 only if you have DNS (forward/reverse) for ESXi hostnames
$addHostByDnsName = 1

#### DO NOT EDIT BEYOND HERE ####

$debug = $true
$verboseLogFile = "vsphere-with-tanzu-nsxt-lab-deployment.log"
$random_string = -join ((65..90) + (97..122) | Get-Random -Count 8 | % {[char]$_})
$VAppName = "Nested-vSphere-with-Tanzu-NSX-T-Lab-$random_string"

$preCheck = 1
$confirmDeployment = 1
$deployNestedESXiVMs = 1
$setVLanId = 1
$deployVCSA = 1
$setupNewVC = 1
$addESXiHostsToVC = 1
$configureVSANDiskGroup = 1
$configureVDS1 = 1
$configureVDS2 = 1
$clearVSANHealthCheckAlarm = 1
$setupTanzuStoragePolicy = 1
$setupTKGContentLibrary = 1
$deployNSXManager = 1
$deployNSXEdge = 1
$postDeployNSXConfig = 1
$setupTanzu = 1
$moveVMsIntovAp = 1

$deployProjectExternalIPBlocksConfig = 0
$deployProject = 0
$deployVpc = 0
$deployVpcSubnetPublic = 0
$deployVpcSubnetPrivate = 0
$vcsaSize2MemoryStorageMap = @{
"tiny"=@{"cpu"="2";"mem"="12";"disk"="415"};
"small"=@{"cpu"="4";"mem"="19";"disk"="480"};
"medium"=@{"cpu"="8";"mem"="28";"disk"="700"};
"large"=@{"cpu"="16";"mem"="37";"disk"="1065"};
"xlarge"=@{"cpu"="24";"mem"="56";"disk"="1805"}
}

$nsxStorageMap = @{
"manager"="200";
"edge"="200"
}

$esxiTotalCPU = 0
$vcsaTotalCPU = 0
$nsxManagerTotalCPU = 0
$nsxEdgeTotalCPU = 0
$esxiTotalMemory = 0
$vcsaTotalMemory = 0
$nsxManagerTotalMemory = 0
$nsxEdgeTotalMemory = 0
$esxiTotalStorage = 0
$vcsaTotalStorage = 0
$nsxManagerTotalStorage = 0
$nsxEdgeTotalStorage = 0

$StartTime = Get-Date

Function Get-SSLThumbprint {
    param(
    [Parameter(
        Position=0,
        Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true)
    ]
    [Alias('FullName')]
    [String]$URL
    )

    $Code = @'
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
namespace CertificateCapture
{
    public class Utility
    {
        public static Func<HttpRequestMessage,X509Certificate2,X509Chain,SslPolicyErrors,Boolean> ValidationCallback =
            (message, cert, chain, errors) => {
                var newCert = new X509Certificate2(cert);
                var newChain = new X509Chain();
                newChain.Build(newCert);
                CapturedCertificates.Add(new CapturedCertificate(){
                    Certificate =  newCert,
                    CertificateChain = newChain,
                    PolicyErrors = errors,
                    URI = message.RequestUri
                });
                return true;
            };
        public static List<CapturedCertificate> CapturedCertificates = new List<CapturedCertificate>();
    }
    public class CapturedCertificate
    {
        public X509Certificate2 Certificate { get; set; }
        public X509Chain CertificateChain { get; set; }
        public SslPolicyErrors PolicyErrors { get; set; }
        public Uri URI { get; set; }
    }
}
'@
    if ($PSEdition -ne 'Core'){
        Add-Type -AssemblyName System.Net.Http
        if (-not ("CertificateCapture" -as [type])) {
            try { Add-Type $Code -ReferencedAssemblies System.Net.Http } catch {}
        }
    } else {
        if (-not ("CertificateCapture" -as [type])) {
            try { Add-Type $Code -ErrorAction SilentlyContinue } catch {}
        }
    }

    $Certs = [CertificateCapture.Utility]::CapturedCertificates

    $Handler = [System.Net.Http.HttpClientHandler]::new()
    $Handler.ServerCertificateCustomValidationCallback = [CertificateCapture.Utility]::ValidationCallback
    $Client = [System.Net.Http.HttpClient]::new($Handler)
    $Result = $Client.GetAsync($Url).Result

    $sha1 = [Security.Cryptography.SHA1]::Create()
    $certBytes = $Certs[-1].Certificate.GetRawCertData()
    $hash = $sha1.ComputeHash($certBytes)
    $thumbprint = [BitConverter]::ToString($hash).Replace('-',':')
    return $thumbprint.toLower()
}

Function Get-SSLThumbprint256 {
    param(
    [Parameter(
        Position=0,
        Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true)
    ]
    [Alias('FullName')]
    [String]$URL
    )

    $Code = @'
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;

namespace CertificateCapture
{
    public class Utility
    {
        public static Func<HttpRequestMessage,X509Certificate2,X509Chain,SslPolicyErrors,Boolean> ValidationCallback =
            (message, cert, chain, errors) => {
                var newCert = new X509Certificate2(cert);
                var newChain = new X509Chain();
                newChain.Build(newCert);
                CapturedCertificates.Add(new CapturedCertificate(){
                    Certificate =  newCert,
                    CertificateChain = newChain,
                    PolicyErrors = errors,
                    URI = message.RequestUri
                });
                return true;
            };
        public static List<CapturedCertificate> CapturedCertificates = new List<CapturedCertificate>();
    }

    public class CapturedCertificate
    {
        public X509Certificate2 Certificate { get; set; }
        public X509Chain CertificateChain { get; set; }
        public SslPolicyErrors PolicyErrors { get; set; }
        public Uri URI { get; set; }
    }
}
'@
    if ($PSEdition -ne 'Core'){
        Add-Type -AssemblyName System.Net.Http
        if (-not ("CertificateCapture" -as [type])) {
            try { Add-Type $Code -ReferencedAssemblies System.Net.Http } catch {}
        }
    } else {
        if (-not ("CertificateCapture" -as [type])) {
            try { Add-Type $Code -ErrorAction SilentlyContinue } catch {}
        }
    }

    $Certs = [CertificateCapture.Utility]::CapturedCertificates

    $Handler = [System.Net.Http.HttpClientHandler]::new()
    $Handler.ServerCertificateCustomValidationCallback = [CertificateCapture.Utility]::ValidationCallback
    $Client = [System.Net.Http.HttpClient]::new($Handler)
    $Result = $Client.GetAsync($Url).Result

    $sha256 = [Security.Cryptography.SHA256]::Create()
    $certBytes = $Certs[-1].Certificate.GetRawCertData()
    $hash = $sha256.ComputeHash($certBytes)
    $thumbprint = [BitConverter]::ToString($hash).Replace('-',':')
    return $thumbprint
}

Function My-Logger {
    param(
    [Parameter(Mandatory=$true)]
    [String]$message
    )

    $timeStamp = Get-Date -Format "MM-dd-yyyy_hh:mm:ss"

    Write-Host -NoNewline -ForegroundColor White "[$timestamp]"
    Write-Host -ForegroundColor Green " $message"
    $logMessage = "[$timeStamp] $message"
    $logMessage | Out-File -Append -LiteralPath $verboseLogFile
}

Function URL-Check([string] $url) {
    $isWorking = $true

    try {
        $request = [System.Net.WebRequest]::Create($url)
        $request.Method = "HEAD"
        $request.UseDefaultCredentials = $true

        $response = $request.GetResponse()
        $httpStatus = $response.StatusCode

        $isWorking = ($httpStatus -eq "OK")
    }
    catch {
        $isWorking = $false
    }
    return $isWorking
}

if($preCheck -eq 1) {
    if(!(Test-Path $NestedESXiApplianceOVA)) {
        Write-Host -ForegroundColor Red "`nUnable to find $NestedESXiApplianceOVA ...`n"
        exit
    }

    if(!(Test-Path $VCSAInstallerPath)) {
        Write-Host -ForegroundColor Red "`nUnable to find $VCSAInstallerPath ...`n"
        exit
    }

    if(!(Test-Path $NSXTManagerOVA) -and $deployNSXManager -eq 1) {
        Write-Host -ForegroundColor Red "`nUnable to find $NSXTManagerOVA ...`n"
        exit
    }

    if(!(Test-Path $NSXTEdgeOVA) -and $deployNSXEdge -eq 1) {
        Write-Host -ForegroundColor Red "`nUnable to find $NSXTEdgeOVA ...`n"
        exit
    }

    if($PSVersionTable.PSEdition -ne "Core") {
        Write-Host -ForegroundColor Red "`tPowerShell Core was not detected, please install that before continuing ... `n"
        exit
    }

    # pre-check VTEP Network exists
    $viConnection = Connect-VIServer $VIServer -User $VIUsername -Password $VIPassword -WarningAction SilentlyContinue
    if(! (Get-VirtualNetwork $NSXVTEPNetwork -ErrorAction 'silentlycontinue')) {
        Write-Host -ForegroundColor Red "`tUnable to locate $NSXVTEPNetwork portgroup, please create this network before continuing ... `n"
        exit
    }
    Disconnect-VIServer $viConnection -Confirm:$false

    if($NSXLicenseKey -eq "") {
        Write-Host -ForegroundColor Red "`tNSX-T License is required, please fill out `$NSXLicenseKey variable...`n"
        exit
    }
}

if($confirmDeployment -eq 1) {
    Write-Host -ForegroundColor Magenta "`nPlease confirm the following configuration will be deployed:`n"

    Write-Host -ForegroundColor Yellow "---- vSphere with Tanzu using NSX-T Automated Lab Deployment Configuration ---- "
    Write-Host -NoNewline -ForegroundColor Green "Nested ESXi Image Path: "
    Write-Host -ForegroundColor White $NestedESXiApplianceOVA
    Write-Host -NoNewline -ForegroundColor Green "VCSA Image Path: "
    Write-Host -ForegroundColor White $VCSAInstallerPath

    if($deployNSXManager -eq 1) {
        Write-Host -NoNewline -ForegroundColor Green "NSX-T Manager Image Path: "
        Write-Host -ForegroundColor White $NSXTManagerOVA
    }
    if($deployNSXEdge -eq 1) {
        Write-Host -NoNewline -ForegroundColor Green "NSX-T Edge Image Path: "
        Write-Host -ForegroundColor White $NSXTEdgeOVA
    }

    Write-Host -ForegroundColor Yellow "`n---- vCenter Server Deployment Target Configuration ----"
    Write-Host -NoNewline -ForegroundColor Green "vCenter Server Address: "
    Write-Host -ForegroundColor White $VIServer
    Write-Host -NoNewline -ForegroundColor Green "VM Network: "
    Write-Host -ForegroundColor White $VMNetwork
    Write-Host -NoNewline -ForegroundColor Green "Nested VM Network, Vlan, Vmk0 Vlan : "
    Write-Host -ForegroundColor White $MGMTNetwork $NestedVMNetworkVLanId $vmk0VLanId

    if($deployNSXManager -eq 1 -or $deployNSXEdge -eq 1) {
        Write-Host -NoNewline -ForegroundColor Green "NSX-T VTEP Network: "
        Write-Host -ForegroundColor White $NSXVTEPNetwork
    }

    Write-Host -NoNewline -ForegroundColor Green "VM Storage: "
    Write-Host -ForegroundColor White $VMDatastore
    Write-Host -NoNewline -ForegroundColor Green "VM Cluster: "
    Write-Host -ForegroundColor White $VMCluster
    Write-Host -NoNewline -ForegroundColor Green "VM vApp: "
    Write-Host -ForegroundColor White $VAppName
	
	if($deployNestedESXiVMs -eq 1) {
		Write-Host -ForegroundColor Yellow "`n---- vESXi Configuration ----"
		Write-Host -NoNewline -ForegroundColor Green "# of Nested ESXi VMs: "
		Write-Host -ForegroundColor White $NestedESXiHostnameToIPs.count
		Write-Host -NoNewline -ForegroundColor Green "vCPU: "
		Write-Host -ForegroundColor White $NestedESXivCPU
		Write-Host -NoNewline -ForegroundColor Green "vMEM: "
		Write-Host -ForegroundColor White "$NestedESXivMEM GB"
		Write-Host -NoNewline -ForegroundColor Green "Caching VMDK: "
		Write-Host -ForegroundColor White "$NestedESXiCachingvDisk GB"
		Write-Host -NoNewline -ForegroundColor Green "Capacity VMDK: "
		Write-Host -ForegroundColor White "$NestedESXiCapacityvDisk GB"
		Write-Host -NoNewline -ForegroundColor Green "Hostname(s): "
		Write-Host -ForegroundColor White ($NestedESXiHostnameToIPs.Keys | Sort-Object)
		Write-Host -NoNewline -ForegroundColor Green "IP Address(s): "
		Write-Host -ForegroundColor White ($NestedESXiHostnameToIPs.Values | Sort-Object)
		Write-Host -NoNewline -ForegroundColor Green "Netmask "
		Write-Host -ForegroundColor White $VMNetmask
		Write-Host -NoNewline -ForegroundColor Green "Gateway: "
		Write-Host -ForegroundColor White $VMGateway
		Write-Host -NoNewline -ForegroundColor Green "DNS: "
		Write-Host -ForegroundColor White $VMDNS
		Write-Host -NoNewline -ForegroundColor Green "NTP: "
		Write-Host -ForegroundColor White $VMNTP
		Write-Host -NoNewline -ForegroundColor Green "Syslog: "
		Write-Host -ForegroundColor White $VMSyslog
		Write-Host -NoNewline -ForegroundColor Green "Enable SSH: "
		Write-Host -ForegroundColor White $VMSSH
		Write-Host -NoNewline -ForegroundColor Green "Create VMFS Volume: "
		Write-Host -ForegroundColor White $VMVMFS
	}

	if($deployVCSA -eq 1) {
		Write-Host -ForegroundColor Yellow "`n---- VCSA Configuration ----"
		Write-Host -NoNewline -ForegroundColor Green "Deployment Size: "
		Write-Host -ForegroundColor White $VCSADeploymentSize
		Write-Host -NoNewline -ForegroundColor Green "SSO Domain: "
		Write-Host -ForegroundColor White $VCSASSODomainName
		Write-Host -NoNewline -ForegroundColor Green "Enable SSH: "
		Write-Host -ForegroundColor White $VCSASSHEnable
		Write-Host -NoNewline -ForegroundColor Green "Hostname: "
		Write-Host -ForegroundColor White $VCSAHostname
		Write-Host -NoNewline -ForegroundColor Green "IP Address: "
		Write-Host -ForegroundColor White $VCSAIPAddress
		Write-Host -NoNewline -ForegroundColor Green "Netmask "
		Write-Host -ForegroundColor White $VMNetmask
		Write-Host -NoNewline -ForegroundColor Green "Gateway: "
		Write-Host -ForegroundColor White $VMGateway
	}
	
	if($setupNewVC -eq 1) {
		Write-Host -ForegroundColor Yellow "`n---- VCSA Setup ----"
		Write-Host -NoNewline -ForegroundColor Green "VDSwitch: "
		Write-Host -ForegroundColor White $NewVCVDSName
		Write-Host -NoNewline -ForegroundColor Green "VDPortgroup: "
		Write-Host -ForegroundColor White $NewVCDVPGName
  		Write-Host -NoNewline -ForegroundColor Green "VDSwitch: "
		Write-Host -ForegroundColor White $NewVCVDSName2
		Write-Host -NoNewline -ForegroundColor Green "Cluster: "
		Write-Host -ForegroundColor White $NewVCVSANClusterName
		Write-Host -NoNewline -ForegroundColor Green "Datastore: "
		Write-Host -ForegroundColor White $vsanDatastoreName
	}

    if($deployNSXManager -eq 1 -or $deployNSXEdge -eq 1) {
        Write-Host -ForegroundColor Yellow "`n---- NSX-T Configuration ----"
        Write-Host -NoNewline -ForegroundColor Green "NSX Manager Hostname: "
        Write-Host -ForegroundColor White $NSXTMgrHostname
        Write-Host -NoNewline -ForegroundColor Green "NSX Manager IP Address: "
        Write-Host -ForegroundColor White $NSXTMgrIPAddress

        if($deployNSXEdge -eq 1) {
            Write-Host -NoNewline -ForegroundColor Green "# of NSX Edge VMs: "
            Write-Host -NoNewline -ForegroundColor White $NSXTEdgeHostnameToIPs.count
            Write-Host -NoNewline -ForegroundColor Green " IP Address(s): "
            Write-Host -ForegroundColor White ($NSXTEdgeHostnameToIPs.Values | Sort-Object)
        }

        Write-Host -NoNewline -ForegroundColor Green "Netmask: "
        Write-Host -ForegroundColor White $VMNetmask
        Write-Host -NoNewline -ForegroundColor Green "Gateway: "
        Write-Host -ForegroundColor White $VMGateway
        Write-Host -NoNewline -ForegroundColor Green "Enable SSH: "
        Write-Host -ForegroundColor White $NSXSSHEnable
        Write-Host -NoNewline -ForegroundColor Green "Enable Root Login: "
        Write-Host -ForegroundColor White $NSXEnableRootLogin
    }
	
	if($ProjectT0 -eq $T0GatewayName -or $ProjectT0 -eq $T0GatewayVRFName -and $deployProject -eq 1){
		Write-Host -ForegroundColor Yellow "`n---- T0/VRF Configuration ----"
		if($ProjectT0 -eq $T0GatewayName) {
        	Write-Host -NoNewline -ForegroundColor Green "T0 Gateway Name: "
        	Write-Host -ForegroundColor White $T0GatewayName
		Write-Host -NoNewline -ForegroundColor Green "T0 Gateway Interface: "
		Write-Host -ForegroundColor White $T0GatewayInterfaceAddresses
		Write-Host -NoNewline -ForegroundColor Green "T0 Gateway Static Route Address: "
		Write-Host -ForegroundColor White $T0GatewayInterfaceStaticRouteAddress
		}
		
		if($ProjectT0 -eq $T0GatewayVRFName -and $deployProject -eq 1) {
			Write-Host -NoNewline -ForegroundColor Green "VRF Vlan: "
			Write-Host -NoNewline -ForegroundColor White $VRFAccessVlanID
			Write-Host -NoNewline -ForegroundColor Green " VRF Vlans Trunk: "
			Write-Host -ForegroundColor White $NetworkSegmentVlanProjectVRF
			Write-Host -NoNewline -ForegroundColor Green "NSX Trunk Uplink VRF Segment: "
			Write-Host -ForegroundColor White $NetworkSegmentProjectVRF
			Write-Host -NoNewline -ForegroundColor Green "T0 VRF Gateway Name: "
            		Write-Host -ForegroundColor White $T0GatewayVRFName
			Write-Host -NoNewline -ForegroundColor Green "T0 VRF Gateway Interfaces: "
			Write-Host -ForegroundColor White $T0GatewayVRFInterfaceAddresses
			Write-Host -NoNewline -ForegroundColor Green "T0 VRF Gateway Static Route Address: "
			Write-Host -ForegroundColor White $T0GatewayVRFInterfaceStaticRouteAddress
		}
}
	
	if($deployProject -eq 1 -and $deployProjectExternalIPBlocksConfig -eq 1 -or $deployVpc -eq 1) {
		Write-Host -ForegroundColor Yellow "`n---- NSX Project and VPC Configuration ----"
        	Write-Host -NoNewline -ForegroundColor Green "NSX Project Name: "
        	Write-Host -ForegroundColor White $ProjectName
        	Write-Host -NoNewline -ForegroundColor Green "NSX Project Public IP Address(s): "
        	Write-Host -NoNewline -ForegroundColor White $ProjectPUBcidr
		Write-Host -NoNewline -ForegroundColor Green " NSX Project Private IP Address(s): "
       		Write-Host -ForegroundColor White $VpcProjectPRIVcidr
		
		if($deployVpc -eq 1 -and $deployVpcSubnetPublic -eq 1 -and $deployVpcSubnetPrivate -eq 1) {
            		Write-Host -NoNewline -ForegroundColor Green "NSX VPC Name: "
            		Write-Host -ForegroundColor White $VpcName
            		Write-Host -NoNewline -ForegroundColor Green "NSX VPC Public IP Address(s):     "
            		Write-Host -NoNewline -ForegroundColor White $VpcPublicSubnetIpaddresses
			Write-Host -NoNewline -ForegroundColor Green " NSX VPC Private IP Address(s):     "
            		Write-Host -ForegroundColor White $VpcPrivateSubnetIpaddresses
		}
	}


    $esxiTotalCPU = $NestedESXiHostnameToIPs.count * [int]$NestedESXivCPU
    $esxiTotalMemory = $NestedESXiHostnameToIPs.count * [int]$NestedESXivMEM
    $esxiTotalStorage = ($NestedESXiHostnameToIPs.count * [int]$NestedESXiCachingvDisk) + ($NestedESXiHostnameToIPs.count * [int]$NestedESXiCapacityvDisk)
    $vcsaTotalCPU = $vcsaSize2MemoryStorageMap.$VCSADeploymentSize.cpu
    $vcsaTotalMemory = $vcsaSize2MemoryStorageMap.$VCSADeploymentSize.mem
    $vcsaTotalStorage = $vcsaSize2MemoryStorageMap.$VCSADeploymentSize.disk

    Write-Host -ForegroundColor Yellow "`n---- Resource Requirements ----"
    Write-Host -NoNewline -ForegroundColor Green "ESXi     VM CPU: "
    Write-Host -NoNewline -ForegroundColor White $esxiTotalCPU
    Write-Host -NoNewline -ForegroundColor Green " ESXi     VM Memory: "
    Write-Host -NoNewline -ForegroundColor White $esxiTotalMemory "GB "
    Write-Host -NoNewline -ForegroundColor Green "ESXi     VM Storage: "
    Write-Host -ForegroundColor White $esxiTotalStorage "GB"
    Write-Host -NoNewline -ForegroundColor Green "VCSA     VM CPU: "
    Write-Host -NoNewline -ForegroundColor White $vcsaTotalCPU
    Write-Host -NoNewline -ForegroundColor Green " VCSA     VM Memory: "
    Write-Host -NoNewline -ForegroundColor White $vcsaTotalMemory "GB "
    Write-Host -NoNewline -ForegroundColor Green "VCSA     VM Storage: "
    Write-Host -ForegroundColor White $vcsaTotalStorage "GB"

    if($deployNSXManager -eq 1 -or $deployNSXEdge -eq 1) {
        if($deployNSXManager -eq 1) {
            $nsxManagerTotalCPU += [int]$NSXTMgrvCPU
            $nsxManagerTotalMemory += [int]$NSXTMgrvMEM
            $nsxManagerTotalStorage += [int]$nsxStorageMap["manager"]

            Write-Host -NoNewline -ForegroundColor Green "NSX-UA   VM CPU: "
            Write-Host -NoNewline -ForegroundColor White $nsxManagerTotalCPU
            Write-Host -NoNewline -ForegroundColor Green " NSX-UA   VM Memory: "
            Write-Host -NoNewline -ForegroundColor White $nsxManagerTotalMemory "GB "
            Write-Host -NoNewline -ForegroundColor Green " NSX-UA   VM Storage: "
            Write-Host -ForegroundColor White $nsxManagerTotalStorage "GB"
        }

        if($deployNSXEdge -eq 1) {
            $nsxEdgeTotalCPU += $NSXTEdgeHostnameToIPs.count * [int]$NSXTEdgevCPU
            $nsxEdgeTotalMemory += $NSXTEdgeHostnameToIPs.count * [int]$NSXTEdgevMEM
            $nsxEdgeTotalStorage += $NSXTEdgeHostnameToIPs.count * [int]$nsxStorageMap["edge"]

            Write-Host -NoNewline -ForegroundColor Green "NSX-Edge VM CPU: "
            Write-Host -NoNewline -ForegroundColor White $nsxEdgeTotalCPU
            Write-Host -NoNewline -ForegroundColor Green " NSX-Edge VM Memory: "
            Write-Host -NoNewline -ForegroundColor White $nsxEdgeTotalMemory "GB "
            Write-Host -NoNewline -ForegroundColor Green " NSX-Edge VM Storage: "
            Write-Host -ForegroundColor White $nsxEdgeTotalStorage "GB"
        }
    }

	
    Write-Host -ForegroundColor White "---------------------------------------------"
    Write-Host -NoNewline -ForegroundColor Green "Total CPU: "
    Write-Host -ForegroundColor White ($esxiTotalCPU + $vcsaTotalCPU + $nsxManagerTotalCPU + $nsxEdgeTotalCPU)
    Write-Host -NoNewline -ForegroundColor Green "Total Memory: "
    Write-Host -ForegroundColor White ($esxiTotalMemory + $vcsaTotalMemory + $nsxManagerTotalMemory + $nsxEdgeTotalMemory) "GB"
    Write-Host -NoNewline -ForegroundColor Green "Total Storage: "
    Write-Host -ForegroundColor White ($esxiTotalStorage + $vcsaTotalStorage + $nsxManagerTotalStorage + $nsxEdgeTotalStorage) "GB"

    Write-Host -ForegroundColor Magenta "`nWould you like to proceed with this deployment?`n"
    $answer = Read-Host -Prompt "Do you accept (Y or N)"
    if($answer -ne "Y" -or $answer -ne "y") {
        exit
    }
    Clear-Host
}

if( $deployNestedESXiVMs -eq 1 -or $deployVCSA -eq 1 -or $deployNSXManager -eq 1 -or $deployNSXEdge -eq 1) {
    My-Logger "Connecting to Management vCenter Server $VIServer ..."
    $viConnection = Connect-VIServer $VIServer -User $VIUsername -Password $VIPassword -WarningAction SilentlyContinue

    $datastore = Get-Datastore -Server $viConnection -Name $VMDatastore | Select -First 1
    $cluster = Get-Cluster -Server $viConnection -Name $VMCluster
    $datacenter = $cluster | Get-Datacenter
    $vmhost = $cluster | Get-VMHost | Select -First 1
}

if($deployNestedESXiVMs -eq 1) {
    $NestedESXiHostnameToIPs.GetEnumerator() | Sort-Object -Property Value | Foreach-Object {
        $VMName = $_.Key
        $VMIPAddress = $_.Value

        $ovfconfig = Get-OvfConfiguration $NestedESXiApplianceOVA
        $networkMapLabel = ($ovfconfig.ToHashTable().keys | where {$_ -Match "NetworkMapping"}).replace("NetworkMapping.","").replace("-","_").replace(" ","_")
        $ovfconfig.NetworkMapping.$networkMapLabel.value = $VMNetwork

        $ovfconfig.common.guestinfo.hostname.value = $VMName
        $ovfconfig.common.guestinfo.ipaddress.value = $VMIPAddress
        $ovfconfig.common.guestinfo.netmask.value = $VMNetmask
        $ovfconfig.common.guestinfo.gateway.value = $VMGateway
        $ovfconfig.common.guestinfo.dns.value = $VMDNS
        $ovfconfig.common.guestinfo.domain.value = $VMDomain
        $ovfconfig.common.guestinfo.ntp.value = $VMNTP
        $ovfconfig.common.guestinfo.syslog.value = $VMSyslog
        $ovfconfig.common.guestinfo.password.value = $VMPassword
        if($VMSSH -eq "true") {
            $VMSSHVar = $true
        } else {
            $VMSSHVar = $false
        }
        $ovfconfig.common.guestinfo.ssh.value = $VMSSHVar

        if($configureVSANDiskGroup -eq 0) {
            $ovfconfig.common.guestinfo.createvmfs.value = $true
        }


        My-Logger "Setting Ignore Invalid vCenter SSL Certificates ..."
        Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false 

        My-Logger "Deploying Nested ESXi VM $VMName ..."
        $vm = Import-VApp -Source $NestedESXiApplianceOVA -OvfConfiguration $ovfconfig -Name $VMName -Location $cluster -VMHost $vmhost -Datastore $datastore -DiskStorageFormat thin

		My-Logger "Adding vmnic2/vmnic3 to $NSXVTEPNetwork ..."
        	New-NetworkAdapter -VM $vm -Type Vmxnet3 -NetworkName $NSXVTEPNetwork -StartConnected -confirm:$false | Out-File -Append -LiteralPath $verboseLogFile
        	New-NetworkAdapter -VM $vm -Type Vmxnet3 -NetworkName $NSXVTEPNetwork -StartConnected -confirm:$false | Out-File -Append -LiteralPath $verboseLogFile

        	$vm | New-AdvancedSetting -name "ethernet2.filter4.name" -value "dvfilter-maclearn" -confirm:$false -ErrorAction SilentlyContinue | Out-File -Append -LiteralPath $verboseLogFile
        	$vm | New-AdvancedSetting -Name "ethernet2.filter4.onFailure" -value "failOpen" -confirm:$false -ErrorAction SilentlyContinue | Out-File -Append -LiteralPath $verboseLogFile

        	$vm | New-AdvancedSetting -name "ethernet3.filter4.name" -value "dvfilter-maclearn" -confirm:$false -ErrorAction SilentlyContinue | Out-File -Append -LiteralPath $verboseLogFile
        	$vm | New-AdvancedSetting -Name "ethernet3.filter4.onFailure" -value "failOpen" -confirm:$false -ErrorAction SilentlyContinue | Out-File -Append -LiteralPath $verboseLogFile

        My-Logger "Updating vCPU Count to $NestedESXivCPU & vMEM to $NestedESXivMEM GB ..."
        Set-VM -Server $viConnection -VM $vm -NumCpu $NestedESXivCPU -MemoryGB $NestedESXivMEM -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile

        if($configureVSANDiskGroup -eq 1) {
            My-Logger "Updating vSAN Cache VMDK size to $NestedESXiCachingvDisk GB & Capacity VMDK size to $NestedESXiCapacityvDisk GB ..."
            Get-HardDisk -Server $viConnection -VM $vm -Name "Hard disk 2" | Set-HardDisk -CapacityGB $NestedESXiCachingvDisk -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile
            Get-HardDisk -Server $viConnection -VM $vm -Name "Hard disk 3" | Set-HardDisk -CapacityGB $NestedESXiCapacityvDisk -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile
			
			My-Logger "Updating vSAN Boot Disk size to $NestedESXiBootDisk GB ..."
            Get-HardDisk -Server $viConnection -VM $vm -Name "Hard disk 1" | Set-HardDisk -CapacityGB $NestedESXiBootDisk -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile
			
        } else {
            Get-HardDisk -Server $viConnection -VM $vm -Name "Hard disk 3" | Set-HardDisk -CapacityGB $NestedESXiCapacityvDisk -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile
        }

        My-Logger "Powering On $vmname ..."
        $vm | Start-Vm -RunAsync | Out-Null
	Start-Sleep -Seconds 180
    }
}

if($setVLanId -eq 1) {
	$NestedESXiHostnameToIPs.GetEnumerator() | Sort-Object -Property Value | Foreach-Object {
        	$VMName = $_.Key
		$VMIPAddress = $_.Value
            	$targetVMHost = $VMIPAddress
			My-Logger "Connecting to Nested ESXi VM $VMName ..."
			$viConnectionESXi = Connect-VIServer $targetVMHost -User "root" -Password $VMPassword -WarningAction SilentlyContinue # | Out-File -Append -LiteralPath $verboseLogFile
			My-Logger "Setting VLAN ID $NestedVMNetworkVLanId for $NestedVMNetwork"
			$NestedVMNetwork = Get-VirtualPortgroup -Name "VM Network"
			Set-VirtualPortgroup -VirtualPortGroup $NestedVMNetwork -VLanId $NestedVMNetworkVLanId | Out-File -Append -LiteralPath $verboseLogFile
			Disconnect-VIServer -Server $viConnectionESXi  -Force -Confirm:$false
	}
}

if($deployNSXManager -eq 1) {
    # Deploy NSX Manager
    $nsxMgrOvfConfig = Get-OvfConfiguration $NSXTManagerOVA
    $nsxMgrOvfConfig.DeploymentOption.Value = $NSXTMgrDeploymentSize
    $nsxMgrOvfConfig.NetworkMapping.Network_1.value = $MGMTNetwork

    $nsxMgrOvfConfig.Common.nsx_role.Value = "NSX Manager"
    $nsxMgrOvfConfig.Common.nsx_hostname.Value = $NSXTMgrHostname
    $nsxMgrOvfConfig.Common.nsx_ip_0.Value = $NSXTMgrIPAddress
    $nsxMgrOvfConfig.Common.nsx_netmask_0.Value = $VMNetmask
    $nsxMgrOvfConfig.Common.nsx_gateway_0.Value = $VMGateway
    $nsxMgrOvfConfig.Common.nsx_dns1_0.Value = $VMDNS
    $nsxMgrOvfConfig.Common.nsx_domain_0.Value = $VMDomain
    $nsxMgrOvfConfig.Common.nsx_ntp_0.Value = $VMNTP

    if($NSXSSHEnable -eq "true") {
        $NSXSSHEnableVar = $true
    } else {
        $NSXSSHEnableVar = $false
    }
    $nsxMgrOvfConfig.Common.nsx_isSSHEnabled.Value = $NSXSSHEnableVar
    if($NSXEnableRootLogin -eq "true") {
        $NSXRootPasswordVar = $true
    } else {
        $NSXRootPasswordVar = $false
    }
    $nsxMgrOvfConfig.Common.nsx_allowSSHRootLogin.Value = $NSXRootPasswordVar

    $nsxMgrOvfConfig.Common.nsx_passwd_0.Value = $NSXRootPassword
    $nsxMgrOvfConfig.Common.nsx_cli_username.Value = $NSXAdminUsername
    $nsxMgrOvfConfig.Common.nsx_cli_passwd_0.Value = $NSXAdminPassword
    $nsxMgrOvfConfig.Common.nsx_cli_audit_username.Value = $NSXAuditUsername
    $nsxMgrOvfConfig.Common.nsx_cli_audit_passwd_0.Value = $NSXAuditPassword

    My-Logger "Deploying NSX Manager VM $NSXTMgrDisplayName ..."
    $nsxmgr_vm = Import-VApp -Source $NSXTManagerOVA -OvfConfiguration $nsxMgrOvfConfig -Name $NSXTMgrDisplayName -Location $cluster -VMHost $vmhost -Datastore $datastore -DiskStorageFormat thin -Force

    My-Logger "Updating vCPU Count to $NSXTMgrvCPU & vMEM to $NSXTMgrvMEM GB ..."
    Set-VM -Server $viConnection -VM $nsxmgr_vm -NumCpu $NSXTMgrvCPU -MemoryGB $NSXTMgrvMEM -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile

    My-Logger "Disabling vCPU Reservation ..."
    Get-VM -Server $viConnection -Name $nsxmgr_vm | Get-VMResourceConfiguration | Set-VMResourceConfiguration -CpuReservationMhz 0 | Out-File -Append -LiteralPath $verboseLogFile

    My-Logger "Powering On $NSXTMgrDisplayName ..."
    $nsxmgr_vm | Start-Vm -RunAsync | Out-Null
}

if($deployVCSA -eq 1) {
        if($IsWindows) {
            $config = (Get-Content -Raw "$($VCSAInstallerPath)\vcsa-cli-installer\templates\install\embedded_vCSA_on_VC.json") | ConvertFrom-Json
        } else {
            $config = (Get-Content -Raw "$($VCSAInstallerPath)/vcsa-cli-installer/templates/install/embedded_vCSA_on_VC.json") | ConvertFrom-Json
        }
        $config.'new_vcsa'.vc.hostname = $VIServer
        $config.'new_vcsa'.vc.username = $VIUsername
        $config.'new_vcsa'.vc.password = $VIPassword
        $config.'new_vcsa'.vc.deployment_network = $MGMTNetwork
        $config.'new_vcsa'.vc.datastore = $datastore
        $config.'new_vcsa'.vc.datacenter = $datacenter.name
        $config.'new_vcsa'.vc.target = $VMCluster
        $config.'new_vcsa'.appliance.thin_disk_mode = $true
        $config.'new_vcsa'.appliance.deployment_option = $VCSADeploymentSize
        $config.'new_vcsa'.appliance.name = $VCSADisplayName
        $config.'new_vcsa'.network.ip_family = "ipv4"
        $config.'new_vcsa'.network.mode = "static"
        $config.'new_vcsa'.network.ip = $VCSAIPAddress
        $config.'new_vcsa'.network.dns_servers[0] = $VMDNS
        $config.'new_vcsa'.network.prefix = $VCSAPrefix
        $config.'new_vcsa'.network.gateway = $VMGateway
        $config.'new_vcsa'.os.ntp_servers = $VMNTP
        $config.'new_vcsa'.network.system_name = $VCSAHostname
        $config.'new_vcsa'.os.password = $VCSARootPassword
        if($VCSASSHEnable -eq "true") {
            $VCSASSHEnableVar = $true
        } else {
            $VCSASSHEnableVar = $false
        }
        $config.'new_vcsa'.os.ssh_enable = $VCSASSHEnableVar
        $config.'new_vcsa'.sso.password = $VCSASSOPassword
        $config.'new_vcsa'.sso.domain_name = $VCSASSODomainName

        if($IsWindows) {
            My-Logger "Creating VCSA JSON Configuration file for deployment ..."
            $config | ConvertTo-Json -WarningAction Ignore | Set-Content -Path "$($ENV:Temp)\jsontemplate.json"

            My-Logger "Deploying the VCSA ..."
            Invoke-Expression "$($VCSAInstallerPath)\vcsa-cli-installer\win32\vcsa-deploy.exe install --no-esx-ssl-verify --accept-eula --acknowledge-ceip $($ENV:Temp)\jsontemplate.json"| Out-File -Append -LiteralPath $verboseLogFile
        } elseif($IsMacOS) {
            My-Logger "Creating VCSA JSON Configuration file for deployment ..."
            $config | ConvertTo-Json -WarningAction Ignore | Set-Content -Path "$($ENV:TMPDIR)jsontemplate.json"

            My-Logger "Deploying the VCSA ..."
            Invoke-Expression "$($VCSAInstallerPath)/vcsa-cli-installer/mac/vcsa-deploy install --no-esx-ssl-verify --accept-eula --acknowledge-ceip $($ENV:TMPDIR)jsontemplate.json"| Out-File -Append -LiteralPath $verboseLogFile
        } elseif ($IsLinux) {
            My-Logger "Creating VCSA JSON Configuration file for deployment ..."
            $config | ConvertTo-Json -WarningAction Ignore | Set-Content -Path "/tmp/jsontemplate.json"

            My-Logger "Deploying the VCSA ..."
            Invoke-Expression "$($VCSAInstallerPath)/vcsa-cli-installer/lin64/vcsa-deploy install --no-esx-ssl-verify --accept-eula --acknowledge-ceip /tmp/jsontemplate.json"| Out-File -Append -LiteralPath $verboseLogFile
        }
}

if($deployNSXEdge -eq 1) {
    My-Logger "Setting up NSX-T Edge to join NSX-T Management Plane ..."
    if(!(Connect-NsxtServer -Server $NSXTMgrHostname -Username $NSXAdminUsername -Password $NSXAdminPassword -WarningAction SilentlyContinue)) {
        Write-Host -ForegroundColor Red "Unable to connect to NSX-T Manager, please check the deployment"
        exit
    } else {
        My-Logger "Successfully logged into NSX-T Manager $NSXTMgrHostname  ..."
    }

    # Retrieve NSX Manager Thumbprint which will be needed later
    My-Logger "Retrieving NSX Manager Thumbprint ..."
    $nsxMgrID = ((Get-NsxtService -Name "com.vmware.nsx.cluster.nodes").list().results | where {$_.manager_role -ne $null}).id
    $nsxMgrCertThumbprint = (Get-NsxtService -Name "com.vmware.nsx.cluster.nodes").get($nsxMgrID).manager_role.api_listen_addr.certificate_sha256_thumbprint

    My-Logger "Accepting NSX Manager EULA ..."
    $eulaService = Get-NsxtService -Name "com.vmware.nsx.eula.accept"
    $eulaService.create()

    $LicenseService = Get-NsxtService -Name "com.vmware.nsx.licenses"
    $LicenseSpec = $LicenseService.Help.create.license.Create()
    $LicenseSpec.license_key = $NSXLicenseKey
    $LicenseResult = $LicenseService.create($LicenseSpec)

    My-Logger "Disconnecting from NSX-T Manager ..."
    Disconnect-NsxtServer -Confirm:$false

    # Deploy Edges
    $nsxEdgeOvfConfig = Get-OvfConfiguration $NSXTEdgeOVA
    $NSXTEdgeHostnameToIPs.GetEnumerator() | Sort-Object -Property Value | Foreach-Object {
        $VMName = $_.Key
        $VMIPAddress = $_.Value
        $VMHostname = "$VMName" + "." + $VMDomain

        $nsxEdgeOvfConfig.DeploymentOption.Value = $NSXTEdgeDeploymentSize
        $nsxEdgeOvfConfig.NetworkMapping.Network_0.value = $MGMTNetwork
        $nsxEdgeOvfConfig.NetworkMapping.Network_1.value = $NSXVTEPNetwork
        $nsxEdgeOvfConfig.NetworkMapping.Network_2.value = $VMNetwork
        $nsxEdgeOvfConfig.NetworkMapping.Network_3.value = $VMNetwork
	$nsxEdgeOvfConfig.NetworkMapping.Network_4.value = $NSXVTEPNetwork

        $nsxEdgeOvfConfig.Common.nsx_hostname.Value = $VMHostname
        $nsxEdgeOvfConfig.Common.nsx_ip_0.Value = $VMIPAddress
        $nsxEdgeOvfConfig.Common.nsx_netmask_0.Value = $VMNetmask
        $nsxEdgeOvfConfig.Common.nsx_gateway_0.Value = $VMGateway
        $nsxEdgeOvfConfig.Common.nsx_dns1_0.Value = $VMDNS
        $nsxEdgeOvfConfig.Common.nsx_domain_0.Value = $VMDomain
        $nsxEdgeOvfConfig.Common.nsx_ntp_0.Value = $VMNTP

        $nsxEdgeOvfConfig.Common.mpUser.Value = $NSXAdminUsername
        $nsxEdgeOvfConfig.Common.mpPassword.Value = $NSXAdminPassword
        $nsxEdgeOvfConfig.Common.mpIp.Value = $NSXTMgrIPAddress
        $nsxEdgeOvfConfig.Common.mpThumbprint.Value = $nsxMgrCertThumbprint

        if($NSXSSHEnable -eq "true") {
            $NSXSSHEnableVar = $true
        } else {
            $NSXSSHEnableVar = $false
        }
        $nsxEdgeOvfConfig.Common.nsx_isSSHEnabled.Value = $NSXSSHEnableVar
        if($NSXEnableRootLogin -eq "true") {
            $NSXRootPasswordVar = $true
        } else {
            $NSXRootPasswordVar = $false
        }
        $nsxEdgeOvfConfig.Common.nsx_allowSSHRootLogin.Value = $NSXRootPasswordVar

        $nsxEdgeOvfConfig.Common.nsx_passwd_0.Value = $NSXRootPassword
        $nsxEdgeOvfConfig.Common.nsx_cli_username.Value = $NSXAdminUsername
        $nsxEdgeOvfConfig.Common.nsx_cli_passwd_0.Value = $NSXAdminPassword
        $nsxEdgeOvfConfig.Common.nsx_cli_audit_username.Value = $NSXAuditUsername
        $nsxEdgeOvfConfig.Common.nsx_cli_audit_passwd_0.Value = $NSXAuditPassword

        My-Logger "Deploying NSX Edge VM $VMName ..."
        $nsxedge_vm = Import-VApp -Source $NSXTEdgeOVA -OvfConfiguration $nsxEdgeOvfConfig -Name $VMName -Location $cluster -VMHost $vmhost -Datastore $datastore -DiskStorageFormat thin -Force

        My-Logger "Updating vCPU Count to $NSXTEdgevCPU & vMEM to $NSXTEdgevMEM GB ..."
        Set-VM -Server $viConnection -VM $nsxedge_vm -NumCpu $NSXTEdgevCPU -MemoryGB $NSXTEdgevMEM -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile

        My-Logger "Powering On $VMName ..."
        $nsxedge_vm | Start-Vm -RunAsync | Out-Null
    }
}

if($moveVMsIntovApp -eq 1) {
    # Check whether DRS is enabled as that is required to create vApp
    if((Get-Cluster -Server $viConnection $cluster).DrsEnabled) {
        if(-Not (Get-VApp -Name $VAppName -ErrorAction Ignore)) {
			My-Logger "Creating vApp $VAppName ..."
			$rp = Get-ResourcePool -Name Resources -Location $cluster
			$VApp = New-VApp -Name $VAppName -Server $viConnection -Location $cluster
			} else {
				$VApp = $VAppName
		}
        if(-Not (Get-Folder $VMFolder -ErrorAction Ignore)) {
            My-Logger "Creating VM Folder $VMFolder ..."
            $folder = New-Folder -Name $VMFolder -Server $viConnection -Location (Get-Datacenter $VMDatacenter | Get-Folder vm)
        }

        if($deployNestedESXiVMs -eq 1) {
            My-Logger "Moving Nested ESXi VMs into $VAppName vApp ..."
            $NestedESXiHostnameToIPs.GetEnumerator() | Sort-Object -Property Value | Foreach-Object {
                $vm = Get-VM -Name $_.Key -Server $viConnection -Location $cluster | where{$_.ResourcePool.Id -eq $rp.Id}
                Move-VM -VM $vm -Server $viConnection -Destination $VApp -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile
            }
        }

        if($deployVCSA -eq 1) {
            $vcsaVM = Get-VM -Name $VCSADisplayName -Server $viConnection -Location $cluster | where{$_.ResourcePool.Id -eq $rp.Id}
            My-Logger "Moving $VCSADisplayName into $VAppName vApp ..."
            Move-VM -VM $vcsaVM -Server $viConnection -Destination $VApp -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile
        }

        if($deployNSXManager -eq 1) {
            $nsxMgrVM = Get-VM -Name $NSXTMgrDisplayName -Server $viConnection -Location $cluster | where{$_.ResourcePool.Id -eq $rp.Id}
            My-Logger "Moving $NSXTMgrDisplayName into $VAppName vApp ..."
            Move-VM -VM $nsxMgrVM -Server $viConnection -Destination $VApp -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile
        }

        if($deployNSXEdge -eq 1) {
            My-Logger "Moving NSX Edge VMs into $VAppName vApp ..."
            $NSXTEdgeHostnameToIPs.GetEnumerator() | Sort-Object -Property Value | Foreach-Object {
                $nsxEdgeVM = Get-VM -Name $_.Key -Server $viConnection -Location $cluster | where{$_.ResourcePool.Id -eq $rp.Id}
                Move-VM -VM $nsxEdgeVM -Server $viConnection -Destination $VApp -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile
            }
        }

        My-Logger "Moving $VAppName to VM Folder $VMFolder ..."
        Move-VApp -Server $viConnection $VAppName -Destination (Get-Folder -Server $viConnection $VMFolder) | Out-File -Append -LiteralPath $verboseLogFile
    } else {
        My-Logger "vApp $VAppName will NOT be created as DRS is NOT enabled on vSphere Cluster ${cluster} ..."
    }
}

if( $deployNestedESXiVMs -eq 1 -or $deployVCSA -eq 1 -or $deployNSXManager -eq 1 -or $deployNSXEdge -eq 1) {
    My-Logger "Disconnecting from $VIServer ..."
    Disconnect-VIServer -Server $viConnection -Confirm:$false
}

if($setupNewVC -eq 1) {
    My-Logger "Connecting to the new VCSA ..."
    $vc = Connect-VIServer $VCSAIPAddress -User "administrator@$VCSASSODomainName" -Password $VCSASSOPassword -WarningAction SilentlyContinue

    $d = Get-Datacenter -Server $vc $NewVCDatacenterName -ErrorAction Ignore
    if( -Not $d) {
        My-Logger "Creating Datacenter $NewVCDatacenterName ..."
        New-Datacenter -Server $vc -Name $NewVCDatacenterName -Location (Get-Folder -Type Datacenter -Server $vc) | Out-File -Append -LiteralPath $verboseLogFile
    }

    $c = Get-Cluster -Server $vc $NewVCVSANClusterName -ErrorAction Ignore
    if( -Not $c) {
        if($configureVSANDiskGroup -eq 1) {
            My-Logger "Creating VSAN Cluster $NewVCVSANClusterName ..."
            New-Cluster -Server $vc -Name $NewVCVSANClusterName -Location (Get-Datacenter -Name $NewVCDatacenterName -Server $vc) -DrsEnabled -HAEnabled -VsanEnabled | Out-File -Append -LiteralPath $verboseLogFile
        } else {
            My-Logger "Creating vSphere Cluster $NewVCVSANClusterName ..."
            New-Cluster -Server $vc -Name $NewVCVSANClusterName -Location (Get-Datacenter -Name $NewVCDatacenterName -Server $vc) -DrsEnabled -HAEnabled | Out-File -Append -LiteralPath $verboseLogFile
        }
        (Get-Cluster $NewVCVSANClusterName) | New-AdvancedSetting -Name "das.ignoreRedundantNetWarning" -Type ClusterHA -Value $true -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile
    }

    if($addESXiHostsToVC -eq 1) {
        $NestedESXiHostnameToIPs.GetEnumerator() | Sort-Object -Property Value | Foreach-Object {
            $VMName = $_.Key
            $VMIPAddress = $_.Value

            $targetVMHost = $VMIPAddress
            if($addHostByDnsName -eq 1) {
                $targetVMHost = "$VMName" + "." + $VMDomain
            }
            My-Logger "Adding ESXi host $targetVMHost to Cluster ..."
            Add-VMHost -Server $vc -Location (Get-Cluster -Name $NewVCVSANClusterName) -User "root" -Password $VMPassword -Name $targetVMHost -Force | Out-File -Append -LiteralPath $verboseLogFile
        }
		
		$haRuntime = (Get-Cluster $NewVCVSANClusterName).ExtensionData.RetrieveDasAdvancedRuntimeInfo
        $totalHaHosts = $haRuntime.TotalHosts
        $totalHaGoodHosts = $haRuntime.TotalGoodHosts
        while($totalHaGoodHosts -ne $totalHaHosts) {
            My-Logger "Waiting for vSphere HA configuration to complete ..."
            Start-Sleep -Seconds 60
            $haRuntime = (Get-Cluster $NewVCVSANClusterName).ExtensionData.RetrieveDasAdvancedRuntimeInfo
            $totalHaHosts = $haRuntime.TotalHosts
            $totalHaGoodHosts = $haRuntime.TotalGoodHosts
        }
    }

    if($configureVSANDiskGroup -eq 1) {
        My-Logger "Enabling VSAN & disabling VSAN Health Check ..."
        Get-VsanClusterConfiguration -Server $vc -Cluster $NewVCVSANClusterName | Set-VsanClusterConfiguration -HealthCheckIntervalMinutes 0 | Out-File -Append -LiteralPath $verboseLogFile

        foreach ($vmhost in Get-Cluster -Name $NewVCVSANClusterName -Server $vc | Get-VMHost) {
            $luns = $vmhost | Get-ScsiLun | select CanonicalName, CapacityGB

            My-Logger "Querying ESXi host disks to create VSAN Diskgroups ..."
            foreach ($lun in $luns) {
                if(([int]($lun.CapacityGB)).toString() -eq "$NestedESXiCachingvDisk") {
                    $vsanCacheDisk = $lun.CanonicalName
                }
                if(([int]($lun.CapacityGB)).toString() -eq "$NestedESXiCapacityvDisk") {
                    $vsanCapacityDisk = $lun.CanonicalName
                }
            }
	    Start-Sleep 120
            My-Logger "Creating VSAN DiskGroup for $vmhost ..."
            New-VsanDiskGroup -Server $vc -VMHost $vmhost -SsdCanonicalName $vsanCacheDisk -DataDiskCanonicalName $vsanCapacityDisk | Out-File -Append -LiteralPath $verboseLogFile
        }
		$vsanDatastoreCreatedName = ((Get-Cluster -Name $NewVCVSANClusterName -Server $vc | Get-VMHost | Select -First 1 | Get-Datastore) | where {$_.type -eq "VSAN"}).Name
		My-Logger "Renaming $vsanDatastoreCreatedName as $vsanDatastoreName"
		((Get-Cluster -Name $NewVCVSANClusterName -Server $vc | Get-VMHost | Select -First 1 | Get-Datastore) | where {$_.type -eq "VSAN"}) | Set-Datastore -Name $vsanDatastoreName | Out-File -Append -LiteralPath $verboseLogFile
    } else {
        foreach ($vmhost in Get-Cluster -Name $NewVCVSANClusterName -Server $vc | Get-VMHost) {
            $localDS = ($vmhost | Get-Datastore) | where {$_.type -eq "VMFS"}
            $localDS | Set-Datastore -Server $vc -Name "not-supported-datastore" | Out-File -Append -LiteralPath $verboseLogFile
        }
    }

    if($configureVDS1 -eq 1) {
		$vds = Get-VDSwitch -Name $NewVCVDSName -Location (Get-Datacenter -Name $NewVCDatacenterName) -ErrorAction Ignore
		if( -Not $vds) {
			$vds = New-VDSwitch -Server $vc -Name $NewVCVDSName -Location (Get-Datacenter -Name $NewVCDatacenterName) -Mtu 9000
		}
			
		$p = Get-VDPortgroup -Server $vc -Name $NewVCDVPGName -VDSwitch $NewVCVDSName -ErrorAction Ignore
		if( -Not $p) {
			New-VDPortgroup -Server $vc -Name $NewVCDVPGName -VDSwitch $vds -VlanId $vmk0VLanId | Out-File -Append -LiteralPath $verboseLogFile
		}
			
		foreach ($vmhost in Get-Cluster -Name $NewVCVSANClusterName -Server $vc | Get-VMHost) {
			My-Logger "Adding $vmhost to $NewVCVDSName"
			$vds | Add-VDSwitchVMHost -VMHost $vmhost | Out-Null
				
			$vmhostNetworkAdapter1 = Get-VMHost $vmhost | Get-VMHostNetworkAdapter -Physical -Name vmnic1
			$vds | Add-VDSwitchPhysicalNetworkAdapter -VMHostNetworkAdapter $vmhostNetworkAdapter1 -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile #add vmnic1 to Tanzu-VDS1 as uplink1
			$vmk = Get-VMHostNetworkAdapter -Name vmk0 -VMHost $vmhost
			Set-VMHostNetworkAdapter -PortGroup $NewVCDVPGName -VirtualNic $vmk -confirm:$false | Out-File -Append -LiteralPath $verboseLogFile #migrate vmk0 to Tanzu-VDS1 in $NewVCDVPGName
			$vmhostNetworkAdapter0 = Get-VMHost $vmhost | Get-VMHostNetworkAdapter -Physical -Name vmnic0
			$vds | Add-VDSwitchPhysicalNetworkAdapter -VMHostNetworkAdapter $vmhostNetworkAdapter0 -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile #add vmnic0 to Tanzu-VDS1 as uplink1
			
			# Remove old vSwitch0
			$vswitch = Get-VirtualSwitch -VMHost $vmhost -Name vSwitch0
			My-Logger "Removing $vswitch on $vmhost"
			Remove-VirtualSwitch -VirtualSwitch $vswitch -Confirm:$false  | Out-File -Append -LiteralPath $verboseLogFile
        	}
		
		Start-Sleep 60
    }

    if($configureVDS2 -eq 1) {
		$vds = Get-VDSwitch -Name $NewVCVDSName2 -Location (Get-Datacenter -Name $NewVCDatacenterName) -ErrorAction Ignore
		if( -Not $vds) {
			$vds = New-VDSwitch -Server $vc -Name $NewVCVDSName2 -Location (Get-Datacenter -Name $NewVCDatacenterName) -Mtu 1700
		}
			
		foreach ($vmhost in Get-Cluster -Name $NewVCVSANClusterName -Server $vc | Get-VMHost) {
			My-Logger "Adding $vmhost to $NewVCVDSName2"
			$vds | Add-VDSwitchVMHost -VMHost $vmhost | Out-Null
				
			$vmhostNetworkAdapter2 = Get-VMHost $vmhost | Get-VMHostNetworkAdapter -Physical -Name vmnic2
			$vmhostNetworkAdapter3 = Get-VMHost $vmhost | Get-VMHostNetworkAdapter -Physical -Name vmnic3
			$vds | Add-VDSwitchPhysicalNetworkAdapter -VMHostNetworkAdapter $vmhostNetworkAdapter2 -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile #add vmnic2 to Tanzu-VDS2 as uplink1
			$vds | Add-VDSwitchPhysicalNetworkAdapter -VMHostNetworkAdapter $vmhostNetworkAdapter3 -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile #add vmnic3 to Tanzu-VDS2 as uplink2

        	}
		Start-Sleep 60
    }
    

    if($clearVSANHealthCheckAlarm -eq 1) {
        My-Logger "Clearing default VSAN Health Check Alarms, not applicable in Nested ESXi env ..."
        $alarmMgr = Get-View AlarmManager -Server $vc
        Get-Cluster -Name $NewVCVSANClusterName -Server $vc | where {$_.ExtensionData.TriggeredAlarmState} | %{
            $cluster = $_
            $Cluster.ExtensionData.TriggeredAlarmState | %{
                $alarmMgr.AcknowledgeAlarm($_.Alarm,$cluster.ExtensionData.MoRef)
            }
        }
        $alarmSpec = New-Object VMware.Vim.AlarmFilterSpec
        $alarmMgr.ClearTriggeredAlarms($alarmSpec)
        
        Set-VsanClusterConfiguration -Configuration $NewVCVSANClusterName -AddSilentHealthCheck controlleronhcl,vumconfig,vumrecommendation -PerformanceServiceEnabled $true | Out-File -Append -LiteralPath $verboseLogFile
    }

    # Final configure and then exit maintanence mode in case patching was done earlier
    foreach ($vmhost in Get-Cluster -Name $NewVCVSANClusterName -Server $vc | Get-VMHost) {
        # Disable Core Dump Warning
        Get-AdvancedSetting -Entity $vmhost -Name UserVars.SuppressCoredumpWarning | Set-AdvancedSetting -Value 1 -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile

        # Enable vMotion traffic
        $vmhost | Get-VMHostNetworkAdapter -VMKernel | Set-VMHostNetworkAdapter -VMotionEnabled $true -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile

        if($vmhost.ConnectionState -eq "Maintenance") {
            Set-VMHost -VMhost $vmhost -State Connected -RunAsync -Confirm:$false | Out-File -Append -LiteralPath $verboseLogFile
        }
    }

    if($setupTanzuStoragePolicy) {
        if($configureVSANDiskGroup -eq 1) {
            $datastoreName = "$vsanDatastoreName"
        } else {
            $datastoreName = ((Get-Cluster -Name $NewVCVSANClusterName -Server $vc | Get-VMHost | Select -First 1 | Get-Datastore) | where {$_.type -eq "VMFS"}).name
        }
        My-Logger "Creating Tanzu Storage Policies and attaching to $datastoreName ..."
		$tc = Get-TagCategory -Server $vc -Name $StoragePolicyTagCategory -ErrorAction Ignore
		if( -Not $tc) {
			New-TagCategory -Server $vc -Name $StoragePolicyTagCategory -Cardinality single -EntityType Datastore | Out-File -Append -LiteralPath $verboseLogFile
		}
		
		$t = Get-Tag -Server $vc -Name $StoragePolicyTagName -Category $StoragePolicyTagCategory -ErrorAction Ignore
		if( -Not $t) {
			New-Tag -Server $vc -Name $StoragePolicyTagName -Category $StoragePolicyTagCategory | Out-File -Append -LiteralPath $verboseLogFile
		}
        Get-Datastore -Server $vc -Name $datastoreName -ErrorAction Ignore | New-TagAssignment -Server $vc -Tag $StoragePolicyTagName | Out-File -Append -LiteralPath $verboseLogFile
		
		$sp = Get-SpbmStoragePolicy -Server $vc -Name $StoragePolicyName -ErrorAction Ignore
		if( -Not $sp) {
			New-SpbmStoragePolicy -Server $vc -Name $StoragePolicyName -AnyOfRuleSets (New-SpbmRuleSet -Name "tanzu-ruleset" -AllOfRules (New-SpbmRule -AnyOfTags (Get-Tag $StoragePolicyTagName)),(New-SpbmRule -Capability (Get-SpbmCapability -Name "VSAN.hostFailuresToTolerate") -Value $hostFailuresToTolerate),(New-SpbmRule -Capability (Get-SpbmCapability -Name "VSAN.forceProvisioning") -Value $true)) | Out-File -Append -LiteralPath $verboseLogFile
		}
		Get-SpbmEntityConfiguration -StoragePolicy $StoragePolicyName
		Set-SpbmEntityConfiguration -Configuration (Get-SpbmEntityConfiguration $datastoreName) -StoragePolicy $StoragePolicyName | Out-File -Append -LiteralPath $verboseLogFile
    }

    if ($setupTKGContentLibrary -eq 1) {
        My-Logger "Creating TKG Subscribed Content Library $TKGContentLibraryName ..."
        $clScheme = ([System.Uri]$TKGContentLibraryURL).scheme
        $clHost = ([System.Uri]$TKGContentLibraryURL).host
        $clPort = ([System.Uri]$TKGContentLibraryURL).port
        $clThumbprint = Get-SSLThumbprint -Url "${clScheme}://${clHost}:${clPort}"

        New-ContentLibrary -Server $vc -Name $TKGContentLibraryName -Description "Subscribed TKG Content Library" -Datastore (Get-Datastore -Server $vc "$vsanDatastoreName") -AutomaticSync -DownloadContentOnDemand -SubscriptionUrl $TKGContentLibraryURL -SslThumbprint $clThumbprint -ErrorAction Ignore | Out-File -Append -LiteralPath $verboseLogFile
    }

    My-Logger "Disconnecting from new VCSA ..."
    Disconnect-VIServer $vc -Confirm:$false
}

if($postDeployNSXConfig -eq 1) {
    My-Logger "Connecting to NSX-T Manager for post-deployment configuration ..."
    if(!(Connect-NsxtServer -Server $NSXTMgrHostname -Username $NSXAdminUsername -Password $NSXAdminPassword -WarningAction SilentlyContinue)) {
        Write-Host -ForegroundColor Red "Unable to connect to NSX-T Manager, please check the deployment"
        exit
    } else {
        My-Logger "Successfully logged into NSX-T Manager $NSXTMgrHostname  ..."
    }

    $runHealth=$true
    $runCEIP=$true
    $runAddVC=$true
    $runIPPool=$true
    $runTransportZone=$true
    $runUplinkProfile=$true
    $runTransportNodeProfile=$true
    $runAddEsxiTransportNode=$true
    $runAddEdgeTransportNode=$true
    $runAddEdgeCluster=$true
    $runNetworkSegment=$true
    $runT0Gateway=$true
    $runT0StaticRoute=$true
    $registervCenterOIDC=$false

    if($runHealth) {
        My-Logger "Verifying health of all NSX Manager/Controller Nodes ..."
        $clusterNodeService = Get-NsxtService -Name "com.vmware.nsx.cluster.nodes"
        $clusterNodeStatusService = Get-NsxtService -Name "com.vmware.nsx.cluster.nodes.status"
        $nodes = $clusterNodeService.list().results
        $mgmtNodes = $nodes | where { $_.controller_role -eq $null }
        $controllerNodes = $nodes | where { $_.manager_role -eq $null }

        foreach ($mgmtNode in $mgmtNodes) {
            $mgmtNodeId = $mgmtNode.id
            $mgmtNodeName = $mgmtNode.appliance_mgmt_listen_addr

            if($debug) { My-Logger "Check health status of Mgmt Node $mgmtNodeName ..." }
            while ( $clusterNodeStatusService.get($mgmtNodeId).mgmt_cluster_status.mgmt_cluster_status -ne "CONNECTED") {
                if($debug) { My-Logger "$mgmtNodeName is not ready, sleeping 20 seconds ..." }
                Start-Sleep 20
            }
        }

        foreach ($controllerNode in $controllerNodes) {
            $controllerNodeId = $controllerNode.id
            $controllerNodeName = $controllerNode.controller_role.control_plane_listen_addr.ip_address

            if($debug) { My-Logger "Checking health of Ctrl Node $controllerNodeName ..." }
            while ( $clusterNodeStatusService.get($controllerNodeId).control_cluster_status.control_cluster_status -ne "CONNECTED") {
                if($debug) { My-Logger "$controllerNodeName is not ready, sleeping 20 seconds ..." }
                Start-Sleep 20
            }
        }
    }

    if($runCEIP) {
        My-Logger "Accepting CEIP Agreement ..."
        $ceipAgreementService = Get-NsxtService -Name "com.vmware.nsx.telemetry.agreement"
        $ceipAgreementSpec = $ceipAgreementService.get()
        $ceipAgreementSpec.telemetry_agreement_displayed = $true
        $agreementResult = $ceipAgreementService.update($ceipAgreementSpec)
    }

    if($runAddVC) {
        My-Logger "Adding vCenter Server Compute Manager ..."
        $computeManagerService = Get-NsxtService -Name "com.vmware.nsx.fabric.compute_managers"
        $computeManagerStatusService = Get-NsxtService -Name "com.vmware.nsx.fabric.compute_managers.status"

        $computeManagerSpec = $computeManagerService.help.create.compute_manager.Create()
        $credentialSpec = $computeManagerService.help.create.compute_manager.credential.username_password_login_credential.Create()
        $VCUsername = "administrator@$VCSASSODomainName"
        $VCURL = "https://" + $VCSAHostname + ":443"
        $VCThumbprint = Get-SSLThumbprint256 -URL $VCURL
        $credentialSpec.username = $VCUsername
        $credentialSpec.password = $VCSASSOPassword
        $credentialSpec.thumbprint = $VCThumbprint
        $computeManagerSpec.server = $VCSAHostname
        $computeManagerSpec.origin_type = "vCenter"
        $computeManagerSpec.display_name = $VCSAHostname
        $computeManagerSpec.credential = $credentialSpec
        $computeManagerSpec.create_service_account = $true
        $computeManagerSpec.set_as_oidc_provider = $true
        $computeManagerResult = $computeManagerService.create($computeManagerSpec)

        if($debug) { My-Logger "Waiting for VC registration to complete ..." }
            while ( $computeManagerStatusService.get($computeManagerResult.id).registration_status -ne "REGISTERED") {
                if($debug) { My-Logger "$VCSAHostname is not ready, sleeping 30 seconds ..." }
                Start-Sleep 30
        }
    }

    if($runIPPool) {
        My-Logger "Creating Tunnel Endpoint IP Pool ..."
        $ipPoolService = Get-NsxtService -Name "com.vmware.nsx.pools.ip_pools"
        $ipPoolSpec = $ipPoolService.help.create.ip_pool.Create()
        $subNetSpec = $ipPoolService.help.create.ip_pool.subnets.Element.Create()
        $allocationRangeSpec = $ipPoolService.help.create.ip_pool.subnets.Element.allocation_ranges.Element.Create()

        $allocationRangeSpec.start = $TunnelEndpointIPRangeStart
        $allocationRangeSpec.end = $TunnelEndpointIPRangeEnd
        $addResult = $subNetSpec.allocation_ranges.Add($allocationRangeSpec)
        $subNetSpec.cidr = $TunnelEndpointCIDR
        $subNetSpec.gateway_ip = $TunnelEndpointGateway
        $ipPoolSpec.display_name = $TunnelEndpointName
        $ipPoolSpec.description = $TunnelEndpointDescription
        $addResult = $ipPoolSpec.subnets.Add($subNetSpec)
        $ipPool = $ipPoolService.create($ipPoolSpec)
    }

    if($runTransportZone) {
        My-Logger "Creating Overlay & VLAN Transport Zones ..."

        $transportZoneService = Get-NsxtService -Name "com.vmware.nsx.transport_zones"
        $overlayTZSpec = $transportZoneService.help.create.transport_zone.Create()
        $overlayTZSpec.display_name = $OverlayTransportZoneName
        #$overlayTZSpec.host_switch_name = $OverlayTransportZoneHostSwitchName # "host_switch_name" is removed in transport zone from nsx4 API
        $overlayTZSpec.transport_type = "OVERLAY"
	$overlayTZSpec.is_default = "True"
        $overlayTZ = $transportZoneService.create($overlayTZSpec)

        $vlanTZSpec = $transportZoneService.help.create.transport_zone.Create()
        $vlanTZSpec.display_name = $VLANTransportZoneName
        #$vlanTZSpec.host_switch_name = $VlanTransportZoneNameHostSwitchName # "host_switch_name" is removed in transport zone from nsx4 API
        $vlanTZSpec.transport_type = "VLAN"
	$vlanTZSpec.is_default = "True"
        $vlanTZ = $transportZoneService.create($vlanTZSpec)
    }

    if($runUplinkProfile) {
        $hostSwitchProfileService = Get-NsxtService -Name "com.vmware.nsx.host_switch_profiles"

        My-Logger "Creating ESXi Uplink Profile ..."
        $ESXiUplinkProfileSpec = $hostSwitchProfileService.help.create.base_host_switch_profile.uplink_host_switch_profile.Create()
		foreach ($ESXiUplinkName in $ESXiUplinkNames) {
			$activeUplinkSpec = $hostSwitchProfileService.help.create.base_host_switch_profile.uplink_host_switch_profile.teaming.active_list.Element.Create()
			$activeUplinkSpec.uplink_name = $ESXiUplinkName
			$activeUplinkSpec.uplink_type = "PNIC"
			$ESXiUplinkProfileSpec.display_name = $ESXiUplinkProfileName
			$ESXiUplinkProfileSpec.transport_vlan = $ESXiUplinkProfileTransportVLAN
			$addActiveUplink = $ESXiUplinkProfileSpec.teaming.active_list.Add($activeUplinkSpec)
		}
        $ESXiUplinkProfileSpec.teaming.policy = $ESXiUplinkProfilePolicy
        $ESXiUplinkProfile = $hostSwitchProfileService.create($ESXiUplinkProfileSpec)

        My-Logger "Creating Edge Uplink Profile ..."
        $EdgeUplinkProfileSpec = $hostSwitchProfileService.help.create.base_host_switch_profile.uplink_host_switch_profile.Create()
		foreach ($EdgeUplinkName in $EdgeUplinkNames) {
			$activeUplinkSpec = $hostSwitchProfileService.help.create.base_host_switch_profile.uplink_host_switch_profile.teaming.active_list.Element.Create()
			$activeUplinkSpec.uplink_name = $EdgeUplinkName
			$activeUplinkSpec.uplink_type = "PNIC"
			$EdgeUplinkProfileSpec.display_name = $EdgeUplinkProfileName
			$EdgeUplinkProfileSpec.mtu = $EdgeUplinkProfileMTU
			$EdgeUplinkProfileSpec.transport_vlan = $EdgeUplinkProfileTransportVLAN
			$addActiveUplink = $EdgeUplinkProfileSpec.teaming.active_list.Add($activeUplinkSpec)
		}
        $EdgeUplinkProfileSpec.teaming.policy = $EdgeUplinkProfilePolicy
        $EdgeUplinkProfile = $hostSwitchProfileService.create($EdgeUplinkProfileSpec)

 	Start-Sleep 30
    }		

    if($runTransportNodeProfile) {
    	$transportNodeProfileService = Get-NsxtService -Name "com.vmware.nsx.transport_node_profiles"
	$tnp = $transportNodeProfileService.list().results | where {$_.display_name -eq $TransportNodeProfileName} -ErrorAction Ignore
		if( -Not $tnp) {
			
			$vc = Connect-VIServer $VCSAIPAddress -User "administrator@$VCSASSODomainName" -Password $VCSASSOPassword -WarningAction SilentlyContinue
			# Retrieve VDS1 UUID from vCenter Server
			$VDS1 = (Get-VDSwitch -Server $vc -Name $NewVCVDSName).ExtensionData
			$VDS1Uuid = $VDS1.Uuid

			# Retrieve VDS2 UUID from vCenter Server
			$VDS2 = (Get-VDSwitch -Server $vc -Name $NewVCVDSName2).ExtensionData
			$VDS2Uuid = $VDS2.Uuid
			Disconnect-VIServer $vc -Confirm:$false

			$hostswitchProfileService = Get-NsxtService -Name "com.vmware.nsx.host_switch_profiles"

			$ipPool = (Get-NsxtService -Name "com.vmware.nsx.pools.ip_pools").list().results | where { $_.display_name -eq $TunnelEndpointName }			
			$VlanTZ = (Get-NsxtService -Name "com.vmware.nsx.transport_zones").list().results | where { $_.display_name -eq $VlanTransportZoneName }
			$OverlayTZ = (Get-NsxtService -Name "com.vmware.nsx.transport_zones").list().results | where { $_.display_name -eq $OverlayTransportZoneName }
			$ESXiUplinkProfile = $hostswitchProfileService.list().results | where { $_.display_name -eq $ESXiUplinkProfileName }
			

			$esxiIpAssignmentSpec = [pscustomobject] @{
				"resource_type" = "StaticIpPoolSpec";
				"ip_pool_id" = $ipPool.id;
			}

			$edgeIpAssignmentSpec = [pscustomobject] @{
				"resource_type" = "AssignedByDhcp";
			}
		
			$VDS1hostTransportZoneEndpoints = @(@{"transport_zone_id"=$VlanTZ.id})
			$VDS2hostTransportZoneEndpoints = @(@{"transport_zone_id"=$OverlayTZ.id})
			
			$esxiHostswitch1Spec = [pscustomobject] @{
				"host_switch_name" = $VlanTransportZoneHostSwitchName;
				"host_switch_mode" = "STANDARD";
				"host_switch_type" = "VDS";
				"host_switch_id" = $VDS1Uuid;
				"uplinks" = @(
								@{"uplink_name"=$ESXiUplinkNames.Get(0);"vds_uplink_name"=$ESXiUplinkNames.Get(0)},
								@{"uplink_name"=$ESXiUplinkNames.Get(1);"vds_uplink_name"=$ESXiUplinkNames.Get(1)}
								)
				"ip_assignment_spec" = $esxiIpAssignmentSpec;
				"host_switch_profile_ids" = @(@{"key"="UplinkHostSwitchProfile";"value"=$ESXiUplinkProfile.id})				
				"transport_zone_endpoints" = $VDS1hostTransportZoneEndpoints;
			}

			$esxiHostswitch2Spec = [pscustomobject] @{
				"host_switch_name" = $OverlayTransportZoneHostSwitchName;
				"host_switch_mode" = "STANDARD";
				"host_switch_type" = "VDS";
				"host_switch_id" = $VDS2Uuid;
				"uplinks" = @(
								@{"uplink_name"=$ESXiUplinkNames.Get(0);"vds_uplink_name"=$ESXiUplinkNames.Get(0)},
								@{"uplink_name"=$ESXiUplinkNames.Get(1);"vds_uplink_name"=$ESXiUplinkNames.Get(1)}
								)
				"ip_assignment_spec" = $esxiIpAssignmentSpec;
				"host_switch_profile_ids" = @(@{"key"="UplinkHostSwitchProfile";"value"=$ESXiUplinkProfile.id})
				"transport_zone_endpoints" = $VDS2hostTransportZoneEndpoints;
			}

			$json = [pscustomobject] @{
				"resource_type" = "TransportNodeProfile";
				"display_name" = $TransportNodeProfileName;
				"host_switch_spec" = [pscustomobject] @{
					"host_switches" = @($esxiHostswitch1Spec,$esxiHostswitch2Spec)
					"resource_type" = "StandardHostSwitchSpec";
				}
			}

			$body = $json | ConvertTo-Json -Depth 10

			$pair = "${NSXAdminUsername}:${NSXAdminPassword}"
			$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
			$base64 = [System.Convert]::ToBase64String($bytes)

			$headers = @{
				"Authorization"="basic $base64"
				"Content-Type"="application/json"
				"Accept"="application/json"
			}

			$transportNodeUrl = "https://$NSXTMgrHostname/api/v1/transport-node-profiles"

			if($debug) {
				"URL: $transportNodeUrl" | Out-File -Append -LiteralPath $verboseLogFile
				"Headers: $($headers | Out-String)" | Out-File -Append -LiteralPath $verboseLogFile
				"Body: $body" | Out-File -Append -LiteralPath $verboseLogFile
			}

			try {
				My-Logger "Creating Transport Node Profile $TransportNodeProfileName ..."
				if($PSVersionTable.PSEdition -eq "Core") {
					$requests = Invoke-WebRequest -Uri $transportNodeUrl -Body $body -Method POST -Headers $headers -SkipCertificateCheck
				} else {
					$requests = Invoke-WebRequest -Uri $transportNodeUrl -Body $body -Method POST -Headers $headers
				}
			} catch {
				Write-Error "Error in creating NSX-T Transport Node Profile"
				Write-Error "`n($_.Exception.Message)`n"
				break
			}

			if($requests.StatusCode -eq 201) {
				My-Logger "Successfully Created Transport Node Profile"
			} else {
				My-Logger "Unknown State: $requests"
			}
   		}
    }


    if($runAddEsxiTransportNode) {
        $transportNodeCollectionService = Get-NsxtService -Name "com.vmware.nsx.transport_node_collections"
        $transportNodeCollectionStateService = Get-NsxtService -Name "com.vmware.nsx.transport_node_collections.state"
        $computeCollectionService = Get-NsxtService -Name "com.vmware.nsx.fabric.compute_collections"
        $transportNodeProfileService = Get-NsxtService -Name "com.vmware.nsx.transport_node_profiles"

        $computeCollectionId = ($computeCollectionService.list().results | where {$_.display_name -eq $NewVCVSANClusterName}).external_id
        $transportNodeProfileId = ($transportNodeProfileService.list().results | where {$_.display_name -eq $TransportNodeProfileName}).id

        $transportNodeCollectionSpec = $transportNodeCollectionService.help.create.transport_node_collection.Create()
        $transportNodeCollectionSpec.display_name = "ESXi Transport Node Collection"
        $transportNodeCollectionSpec.compute_collection_id = $computeCollectionId
        $transportNodeCollectionSpec.transport_node_profile_id = $transportNodeProfileId
        My-Logger "Applying Transport Node Profile to ESXi Transport Nodes ..."
        $transportNodeCollection = $transportNodeCollectionService.create($transportNodeCollectionSpec)

        My-Logger "Waiting for ESXi transport node configurations to complete ..."
        while ( $transportNodeCollectionStateService.get(${transportNodeCollection}.id).state -ne "SUCCESS") {
            $percent = $transportNodeCollectionStateService.get(${transportNodeCollection}.id).aggregate_progress_percentage
            if($debug) { My-Logger "ESXi transport node is still being configured (${percent}% Completed), sleeping for 30 seconds ..." }
            Start-Sleep 30
        }
    }
	
	if($NSXTEdgeAmdZenPause -eq 1) {
		Write-Host "Press any key to continue..."
		$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
	}

    if($runAddEdgeTransportNode) {
        $transportNodeService = Get-NsxtService -Name "com.vmware.nsx.transport_nodes"
        $hostswitchProfileService = Get-NsxtService -Name "com.vmware.nsx.host_switch_profiles"
        $transportNodeStateService = Get-NsxtService -Name "com.vmware.nsx.transport_nodes.state"

        # Retrieve all Edge Host Nodes
        $edgeNodes = $transportNodeService.list().results | where {$_.node_deployment_info.resource_type -eq "EdgeNode"}
        $ipPool = (Get-NsxtService -Name "com.vmware.nsx.pools.ip_pools").list().results | where { $_.display_name -eq $TunnelEndpointName }
        $OverlayTZ = (Get-NsxtService -Name "com.vmware.nsx.transport_zones").list().results | where { $_.display_name -eq $OverlayTransportZoneName }
        $VlanTZ = (Get-NsxtService -Name "com.vmware.nsx.transport_zones").list().results | where { $_.display_name -eq $VlanTransportZoneName }
        $ESXiUplinkProfile = $hostswitchProfileService.list().results | where { $_.display_name -eq $ESXiUplinkProfileName }
        $EdgeUplinkProfile = $hostswitchProfileService.list().results | where { $_.display_name -eq $EdgeUplinkProfileName }
        $NIOCProfile = $hostswitchProfileService.list($null,"VIRTUAL_MACHINE","NiocProfile",$true,$null,$null,$null).results | where {$_.display_name -eq "nsx-default-nioc-hostswitch-profile"}
        $LLDPProfile = $hostswitchProfileService.list($null,"VIRTUAL_MACHINE","LldpHostSwitchProfile",$true,$null,$null,$null).results | where {$_.display_name -eq "LLDP [Send Packet Enabled]"}

        foreach ($edgeNode in $edgeNodes) {
            $overlayIpAssignmentSpec = [pscustomobject] @{
                "resource_type" = "StaticIpPoolSpec";
                "ip_pool_id" = $ipPool.id;
            }

            $edgeIpAssignmentSpec = [pscustomobject] @{
                "resource_type" = "AssignedByDhcp";
            }

            $OverlayTransportZoneEndpoints = @(@{"transport_zone_id"=$OverlayTZ.id})
            $EdgeTransportZoneEndpoints = @(@{"transport_zone_id"=$VlanTZ.id})

            $overlayHostswitchSpec = [pscustomobject]  @{
                "host_switch_name" = $OverlayTransportZoneHostSwitchName;
                "host_switch_mode" = "STANDARD";
                "ip_assignment_spec" = $overlayIpAssignmentSpec
                "pnics" = @(
							@{"device_name"=$EdgeOverlayUplinkProfileActivepNICs.Get(0);"uplink_name"=$EdgeOverlayUplinkNames.Get(0);},
							@{"device_name"=$EdgeOverlayUplinkProfileActivepNICs.Get(1);"uplink_name"=$EdgeOverlayUplinkNames.Get(1);}
							)
                "host_switch_profile_ids" = @(@{"key"="UplinkHostSwitchProfile";"value"=$ESXiUplinkProfile.id})
                "transport_zone_endpoints" = $OverlayTransportZoneEndpoints;
            }

            $edgeHostswitchSpec = [pscustomobject]  @{
                "host_switch_name" = $VlanTransportZoneNameHostSwitchName;
                "host_switch_mode" = "STANDARD";
                "pnics" = @(
							@{"device_name"=$EdgeUplinkProfileActivepNICs.Get(0);"uplink_name"=$EdgeUplinkNames.Get(0);},
							@{"device_name"=$EdgeUplinkProfileActivepNICs.Get(1);"uplink_name"=$EdgeUplinkNames.Get(1);}
							)
                "ip_assignment_spec" = $edgeIpAssignmentSpec
                "host_switch_profile_ids" = @(@{"key"="UplinkHostSwitchProfile";"value"=$EdgeUplinkProfile.id})
                "transport_zone_endpoints" = $EdgeTransportZoneEndpoints;
            }

            $json = [pscustomobject] @{
                "resource_type" = "TransportNode";
                "node_id" = $edgeNode.node_id;
                "display_name" = $edgeNode.display_name;
                "host_switch_spec" = [pscustomobject] @{
                    "host_switches" = @($overlayHostswitchSpec,$edgeHostswitchSpec)
                    "resource_type" = "StandardHostSwitchSpec";
                };
            }

            $body = $json | ConvertTo-Json -Depth 10

            $pair = "${NSXAdminUsername}:${NSXAdminPassword}"
            $bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
            $base64 = [System.Convert]::ToBase64String($bytes)

            $headers = @{
                "Authorization"="basic $base64"
                "Content-Type"="application/json"
                "Accept"="application/json"
            }

            $transportNodeUrl = "https://$NSXTMgrHostname/api/v1/transport-nodes"

            if($debug) {
                "URL: $transportNodeUrl" | Out-File -Append -LiteralPath $verboseLogFile
                "Headers: $($headers | Out-String)" | Out-File -Append -LiteralPath $verboseLogFile
                "Body: $body" | Out-File -Append -LiteralPath $verboseLogFile
            }

            try {
                My-Logger "Creating NSX-T Edge Transport Node for $($edgeNode.display_name) ..."
                if($PSVersionTable.PSEdition -eq "Core") {
                    $requests = Invoke-WebRequest -Uri $transportNodeUrl -Body $body -Method POST -Headers $headers -SkipCertificateCheck
                } else {
                    $requests = Invoke-WebRequest -Uri $transportNodeUrl -Body $body -Method POST -Headers $headers
                }
            } catch {
                Write-Error "Error in creating NSX-T Edge Transport Node"
                Write-Error "`n($_.Exception.Message)`n"
                break
            }

            if($requests.StatusCode -eq 201) {
                My-Logger "Successfully Created NSX-T Edge Transport Node "
                $edgeTransPortNodeId = ($requests.Content | ConvertFrom-Json).node_id
            } else {
                My-Logger "Unknown State: $requests"
                break
            }

            My-Logger "Waiting for Edge transport node configurations to complete ..."
            while ($transportNodeStateService.get($edgeTransPortNodeId).state -ne "success") {
                if($debug) { My-Logger "Edge transport node is still being configured, sleeping for 30 seconds ..." }
                Start-Sleep 30
            }
        }
    }

    if($runAddEdgeCluster) {
		$transportNodeService = Get-NsxtService -Name "com.vmware.nsx.transport_nodes"
		$edgeNodes = $transportNodeService.list().results | where {$_.node_deployment_info.resource_type -eq "EdgeNode"}
		##$transportNodes = (Get-NsxtService -Name "com.vmware.nsx.transport_nodes").list().results
		##$edgeNodes = $transportNodes.node_deployment_info | where { $_.resource_type -eq "EdgeNode" }
        #$edgeNodes = (Get-NsxtService -Name "com.vmware.nsx.fabric.nodes").list().results | where { $_.resource_type -eq "EdgeNode" } #fabric is removed from nsx4 API
        $edgeClusterService = Get-NsxtService -Name "com.vmware.nsx.edge_clusters"
        $edgeClusterStateService = Get-NsxtService -Name "com.vmware.nsx.edge_clusters.state"
        $edgeNodeMembersSpec = $edgeClusterService.help.create.edge_cluster.members.Create()

        My-Logger "Creating Edge Cluster $EdgeClusterName and adding Edge Hosts ..."

        foreach ($edgeNode in $edgeNodes) {
            $edgeNodeMemberSpec = $edgeClusterService.help.create.edge_cluster.members.Element.Create()
            $edgeNodeMemberSpec.transport_node_id = $edgeNode.id
            $edgeNodeMemberAddResult = $edgeNodeMembersSpec.Add($edgeNodeMemberSpec)
        }

        $edgeClusterSpec = $edgeClusterService.help.create.edge_cluster.Create()
        $edgeClusterSpec.display_name = $EdgeClusterName
        $edgeClusterSpec.members = $edgeNodeMembersSpec
        $edgeCluster = $edgeClusterService.Create($edgeClusterSpec)

        $edgeState = $edgeClusterStateService.get($edgeCluster.id)
        $maxCount=5
        $count=0
        while($edgeState.state -ne "in_sync") {
            My-Logger "Edge Cluster has not been realized, sleeping for 10 seconds ..."
            Start-Sleep -Seconds 10
            $edgeState = $edgeClusterStateService.get($edgeCluster.id)

            if($count -eq $maxCount) {
                Write-Host "Edge Cluster has not been realized! exiting ..."
                break
            } else {
                $count++
            }
        }
        # Need to force Policy API sync to ensure Edge Cluster details are available for later use
        $reloadOp = (Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.sites.enforcement_points").reload("default","default")
        My-Logger "Edge Cluster has been realized"
    }

    if($runNetworkSegment) {
        My-Logger "Creating Network Segment $NetworkSegmentName ..."

        $transportZonePolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.sites.enforcement_points.transport_zones"
        $segmentPolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.segments"

        $tzPath = ($transportZonePolicyService.list("default","default").results | where {$_.display_name -eq $VlanTransportZoneName}).path

        $segmentSpec = $segmentPolicyService.help.update.segment.Create()
        $segmentSpec.transport_zone_path = $tzPath
        $segmentSpec.display_name = $NetworkSegmentName
        $segmentSpec.vlan_ids = @($NetworkSegmentVlan)

        $segment = $segmentPolicyService.update($NetworkSegmentName,$segmentSpec)
    }
	
    if($runT0Gateway) {
        My-Logger "Creating T0 Gateway $T0GatewayName ..."

        $t0GatewayPolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.tier0s"
        $t0GatewayLocalePolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.tier_0s.locale_services"
        $t0GatewayInterfacePolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.tier_0s.locale_services.interfaces"
        $edgeClusterPolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.sites.enforcement_points.edge_clusters"
        $edgeClusterService = Get-NsxtService -Name "com.vmware.nsx.edge_clusters"

        $edgeCluster = ($edgeClusterService.list().results | where {$_.display_name -eq $EdgeClusterName})
        $edgeClusterMembers = ($edgeClusterService.get($edgeCluster.id)).members
        if($debug) { "EdgeClusterMember: $edgeClusterMembers" | Out-File -Append -LiteralPath $verboseLogFile }

        $policyEdgeCluster = ($edgeClusterPolicyService.list("default","default").results | where {$_.display_name -eq $EdgeClusterName})
        $policyEdgeClusterPath = $policyEdgeCluster.path
        if($debug) { "EdgeClusterPath: $policyEdgeClusterPath" | Out-File -Append -LiteralPath $verboseLogFile }

        $t0GatewaySpec = $t0GatewayPolicyService.help.patch.tier0.Create()
        $t0GatewaySpec.display_name = $T0GatewayName
        $t0GatewaySpec.ha_mode = "ACTIVE_ACTIVE"
        #$t0GatewaySpec.failover_mode = "NON_PREEMPTIVE" # Not used in Active-Active HA mode
        $t0Gateway = $t0GatewayPolicyService.update($T0GatewayName,$t0GatewaySpec)

        $localeServiceSpec = $t0GatewayLocalePolicyService.help.patch.locale_services.create()
        $localeServiceSpec.display_name = "default"
        $localeServiceSpec.edge_cluster_path = $policyEdgeClusterPath
        $localeService = $t0GatewayLocalePolicyService.patch($T0GatewayName,"default",$localeServiceSpec)

        My-Logger "Creating External T0 Gateway Interface ..."

        foreach ($edgeClusterMember in @($edgeClusterMembers.member_index)) {
			$t0GatewayInterfaceSpec = $t0GatewayInterfacePolicyService.help.update.tier0_interface.Create()
			$t0GatewayInterfaceId = ([guid]::NewGuid()).Guid
			$subnetSpec = $t0GatewayInterfacePolicyService.help.update.tier0_interface.subnets.Element.Create()
			$subnetSpec.ip_addresses = @($T0GatewayInterfaceAddresses.Get($edgeClusterMember))
			$subnetSpec.prefix_len = $T0GatewayInterfacePrefix
			$t0GatewayInterfaceSpec.segment_path = "/infra/segments/$NetworkSegmentName"
			$t0GatewayInterfaceAddResult = $t0GatewayInterfaceSpec.subnets.Add($subnetSpec)
			$t0GatewayInterfaceSpec.type = "EXTERNAL"
			$edgeClusterNodePaths = $policyEdgeClusterPath + "/edge-nodes/" + $edgeClusterMember
			if($debug) { "EdgeClusterNodePath: $edgeClusterNodePaths" | Out-File -Append -LiteralPath $verboseLogFile }
			$t0GatewayInterfaceSpec.edge_path = $edgeClusterNodePaths
			$t0GatewayInterfaceSpec.resource_type = "Tier0Interface"
			$t0GatewayInterface = $t0GatewayInterfacePolicyService.update($T0GatewayName,"default",$t0GatewayInterfaceId,$t0GatewayInterfaceSpec)
		}
    }

    if($runT0StaticRoute) {
        My-Logger "Adding Static Route on T0 Gateway Interface from $T0GatewayInterfaceStaticRouteNetwork to $T0GatewayInterfaceStaticRouteAddress ..."

        $staticRoutePolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.tier_0s.static_routes"
        $t0GatewayInterfacePolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.tier_0s.locale_services.interfaces"

        $scopePath = ($t0GatewayInterfacePolicyService.list($T0GatewayName,"default").results | where {$_.resource_type -eq "Tier0Interface"}).path

        $nextHopSpec = $staticRoutePolicyService.help.patch.static_routes.next_hops.Element.Create()
        $nextHopSpec.admin_distance = "1"
        $nextHopSpec.ip_address = $T0GatewayInterfaceStaticRouteAddress
        $nextHopSpec.scope = @($scopePath)

        $staticRouteSpec = $staticRoutePolicyService.help.patch.static_routes.Create()
        $staticRouteSpec.display_name = $T0GatewayInterfaceStaticRouteName
        $staticRouteSpec.network = $T0GatewayInterfaceStaticRouteNetwork
        $nextHopeAddResult = $staticRouteSpec.next_hops.Add($nextHopSpec)

        $staticRoute = $staticRoutePolicyService.patch($T0GatewayName,$T0GatewayInterfaceStaticRouteName,$staticRouteSpec)
    }
	
    if($registervCenterOIDC) {
        My-Logger "Registering vCenter Server OIDC Endpoint with NSX-T Manager ..."

        $oidcService = Get-NsxtService -Name "com.vmware.nsx.trust_management.oidc_uris"

        $vcThumbprint = (Get-SSLThumbprint256 -URL https://${VCSAHostname}) -replace ":",""

        $oidcSpec = $oidcService.help.create.oidc_end_point.Create()
        $oidcSpec.oidc_uri = "https://${VCSAHostname}/openidconnect/${VCSASSODomainName}/.well-known/openid-configuration"
        $oidcSpec.thumbprint = $vcThumbprint
        $oidcSpec.oidc_type = "vcenter"
        $oidcCreate = $oidcService.create($oidcSpec)
    }

    My-Logger "Disconnecting from NSX-T Manager ..."
    Disconnect-NsxtServer -Confirm:$false
}

if($setupTanzu -eq 1) {
    My-Logger "Connecting to Management vCenter Server $VIServer for enabling Tanzu ..."
    Connect-VIServer $VIServer -User $VIUsername -Password $VIPassword -WarningAction SilentlyContinue | Out-Null

    My-Logger "Creating local $DevOpsUsername User in vCenter Server ..."
    $devopsUserCreationCmd = "/usr/lib/vmware-vmafd/bin/dir-cli user create --account $DevOpsUsername --first-name `"Dev`" --last-name `"Ops`" --user-password `'$DevOpsPassword`' --login `'administrator@$VCSASSODomainName`' --password `'$VCSASSOPassword`'"
    Invoke-VMScript -ScriptText $devopsUserCreationCmd -vm (Get-VM -Name $VCSADisplayName) -GuestUser "root" -GuestPassword "$VCSARootPassword" | Out-File -Append -LiteralPath $verboseLogFile

    My-Logger "Disconnecting from Management vCenter ..."
    Disconnect-VIServer * -Confirm:$false | Out-Null
}

if($ProjectT0 -eq $T0GatewayVRFName -and $deployProject -eq 1){
	$deployT0VRFconfig = 1
}

if($deployT0VRFconfig -eq 1) {
	My-Logger "Connecting to NSX-T Manager for T0 VRF Gateway deployment configuration via VMware.Sdk.Nsx.Policy PowerCLI Module ..."
    if(!(Connect-NsxServer -Server $NSXTMgrHostname -Username $NSXAdminUsername -Password $NSXAdminPassword -WarningAction SilentlyContinue)) {
        Write-Host -ForegroundColor Red "Unable to connect to NSX-T Manager, please check the deployment"
        exit
    } else {
        My-Logger "Successfully logged into NSX-T Manager $NSXTMgrHostname  ..."
    }
	
	$runNetworkSegmentProjectVRF=$true
	$runT0GatewayVRF=$true
	$runT0VRFStaticRoute=$true
	
	if($runNetworkSegmentProjectVRF) {
        My-Logger "Creating/Updating Network Segment $NetworkSegmentProjectVRF with vlan $NetworkSegmentVlanProjectVRF ..."
		$tzPath = ((Invoke-ListTransportZonesForEnforcementPoint -siteId "default" -enforcementpointId "default").Results | where {$_.DisplayName -eq $VlanTransportZoneName}).Path
		$Segment = Initialize-Segment -DisplayName $NetworkSegmentProjectVRF -TransportZonePath $tzPath -VlanIds $NetworkSegmentVlanProjectVRF
		Invoke-PatchInfraSegment -segmentId $NetworkSegmentProjectVRF -segment $Segment
	}
	
	My-Logger "Connecting to NSX-T Manager for T0 VRF Gateway deployment configuration ..."
    if(!(Connect-NsxtServer -Server $NSXTMgrHostname -Username $NSXAdminUsername -Password $NSXAdminPassword -WarningAction SilentlyContinue)) {
        Write-Host -ForegroundColor Red "Unable to connect to NSX-T Manager, please check the deployment"
        exit
    } else {
        My-Logger "Successfully logged into NSX-T Manager $NSXTMgrHostname  ..."
    }
	
    if($runT0GatewayVRF) {
		My-Logger "Creating T0 VRF Gateway $T0GatewayVRFName ..."
		
		$t0GatewayVRFPolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.tier0s"
        $t0GatewayLocalePolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.tier_0s.locale_services"
        $t0GatewayVRFInterfacePolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.tier_0s.locale_services.interfaces"
        $edgeClusterPolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.sites.enforcement_points.edge_clusters"
        $edgeClusterService = Get-NsxtService -Name "com.vmware.nsx.edge_clusters"

        $edgeCluster = ($edgeClusterService.list().results | where {$_.display_name -eq $EdgeClusterName})
        $edgeClusterMembers = ($edgeClusterService.get($edgeCluster.id)).members
        if($debug) { "EdgeClusterMember: ${edgeClusterMembers}" | Out-File -Append -LiteralPath $verboseLogFile }

        $policyEdgeCluster = ($edgeClusterPolicyService.list("default","default").results | where {$_.display_name -eq $EdgeClusterName})
        $policyEdgeClusterPath = $policyEdgeCluster.path
        if($debug) { "EdgeClusterPath: $policyEdgeClusterPath" | Out-File -Append -LiteralPath $verboseLogFile }

		
        $t0GatewayVRFSpec = $t0GatewayVRFPolicyService.help.patch.tier0.Create()
        $t0GatewayVRFSpec.display_name = $T0GatewayVRFName
	$t0GatewayVRFSpec.vrf_config.tier0_path = "/infra/tier-0s/$T0GatewayName" #only new line between T0 and T0 VRF is it need the path to parent T0
        $t0GatewayVRFSpec.ha_mode = "ACTIVE_ACTIVE"
        #$t0GatewayVRFSpec.failover_mode = "NON_PREEMPTIVE"
        $t0GatewayVRF = $t0GatewayVRFPolicyService.update($T0GatewayVRFName,$t0GatewayVRFSpec)

        $localeServiceSpec = $t0GatewayLocalePolicyService.help.patch.locale_services.create()
        $localeServiceSpec.display_name = "default"
        $localeServiceSpec.edge_cluster_path = $policyEdgeClusterPath
        $localeService = $t0GatewayLocalePolicyService.patch($T0GatewayVRFName,"default",$localeServiceSpec)

        My-Logger "Creating External T0 VRF Gateway Interface ..."		

        foreach ($edgeClusterMember in @($edgeClusterMembers.member_index)) {
			$t0GatewayVRFInterfaceSpec = $t0GatewayVRFInterfacePolicyService.help.update.tier0_interface.Create()
			$t0GatewayVRFInterfaceId = ([guid]::NewGuid()).Guid
			$subnetSpec = $t0GatewayVRFInterfacePolicyService.help.update.tier0_interface.subnets.Element.Create()
			$subnetSpec.ip_addresses = @($T0GatewayVRFInterfaceAddresses.Get($edgeClusterMember))
			$subnetSpec.prefix_len = $T0GatewayVRFInterfacePrefix
			$t0GatewayVRFInterfaceSpec.segment_path = "/infra/segments/$NetworkSegmentProjectVRF"
			$t0GatewayVRFInterfaceSpec.access_vlan_id = $VRFAccessVlanID #only new line to use vlan for vrf and diferentiate it in the trunk vlan segment (.vlan_ids)
			$t0GatewayVRFInterfaceAddResult = $t0GatewayVRFInterfaceSpec.subnets.Add($subnetSpec)
			$t0GatewayVRFInterfaceSpec.type = "EXTERNAL"
			$edgeClusterNodePaths = $policyEdgeClusterPath + "/edge-nodes/" + $edgeClusterMember
			if($debug) { "EdgeClusterNodePath: $edgeClusterNodePaths" | Out-File -Append -LiteralPath $verboseLogFile }
			$t0GatewayVRFInterfaceSpec.edge_path = $edgeClusterNodePaths
			$t0GatewayVRFInterfaceSpec.resource_type = "Tier0Interface"
			$t0GatewayVRFInterface = $t0GatewayVRFInterfacePolicyService.patch($T0GatewayVRFName,"default",$t0GatewayVRFInterfaceId,$t0GatewayVRFInterfaceSpec)
		}
    }
    
    if($runT0VRFStaticRoute) {
        My-Logger "Adding default Static Route with nexthop $T0GatewayVRFInterfaceStaticRouteAddress and scope T0 VRF Gateway Interfaces $T0GatewayVRFInterfaceAddresses"

        $staticRoutePolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.tier_0s.static_routes"
		$t0GatewayVRFInterfacePolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.tier_0s.locale_services.interfaces"
		$t0GatewayVRFPolicyService = Get-NsxtPolicyService -Name "com.vmware.nsx_policy.infra.tier0s"

        #$scopePath = ($t0GatewayInterfacePolicyService.list().results | where {$_.display_name -eq $T0GatewayVRFName}).path
		$scopePath = ($t0GatewayVRFInterfacePolicyService.list($T0GatewayVRFName,"default").results).path

        $nextHopSpec = $staticRoutePolicyService.help.patch.static_routes.next_hops.Element.Create()
        $nextHopSpec.admin_distance = "1"
        $nextHopSpec.ip_address = $T0GatewayVRFInterfaceStaticRouteAddress

		$nextHopSpec.scope = @($scopePath)

        $staticRouteSpec = $staticRoutePolicyService.help.patch.static_routes.Create()
        $staticRouteSpec.display_name = $T0GatewayVRFInterfaceStaticRouteName
        $staticRouteSpec.network = $T0GatewayVRFInterfaceStaticRouteNetwork
        $nextHopeAddResult = $staticRouteSpec.next_hops.Add($nextHopSpec)

        $staticRoute = $staticRoutePolicyService.patch($T0GatewayVRFName,$T0GatewayVRFInterfaceStaticRouteName,$staticRouteSpec)
    }
}
    

if($deployProjectExternalIPBlocksConfig -eq 1) {
    My-Logger "Connecting to NSX-T Manager for Project and VPC deployment configuration ..."
    if(!(Connect-NsxtServer -Server $NSXTMgrHostname -Username $NSXAdminUsername -Password $NSXAdminPassword -WarningAction SilentlyContinue)) {
        Write-Host -ForegroundColor Red "Unable to connect to NSX-T Manager, please check the deployment"
        exit
    } else {
        My-Logger "Successfully logged into NSX-T Manager $NSXTMgrHostname  ..."
    }

	$ExternalIPBlocks=$true

	if($ExternalIPBlocks) {
		
		$PUBip_blocks = Get-NsxtPolicyService -Name com.vmware.nsx_policy.infra.ip_blocks
		$PUBipblockSpec = $PUBip_blocks.help.patch.ip_address_block.Create($ProjectPUBipblockName)
		$PUBipblockSpec.id = $ProjectPUBipblockName
		$PUBipblockSpec.cidr = $ProjectPUBcidr
		$PUBipblockSpec.visibility = "EXTERNAL"
		$PUBipblock = $PUBip_blocks.update($ProjectPUBipblockName, $PUBipblockSpec)
	}
	
	My-Logger "Disconnecting from NSX-T Manager ..."
    Disconnect-NsxtServer -Confirm:$false
}


if($deployProject -eq 1) {
    if(!(Connect-NsxServer -Server $NSXTMgrHostname -Username $NSXAdminUsername -Password $NSXAdminPassword -WarningAction SilentlyContinue)) {
        Write-Host -ForegroundColor Red "Unable to connect to NSX-T Manager, please check the deployment"
        exit
    } else {
        My-Logger "Successfully logged into NSX-T Manager $NSXTMgrHostname  ..."
    }
	
	My-Logger "Create NSX Project $ProjectName via VMware.Sdk.Nsx.Policy PowerCLI Module"	
	$SdkPolicyEdgeCluster = ((Invoke-ListEdgeClustersForEnforcementPoint -siteId "default" -EnforcementpointId "default").Results | where {$_.DisplayName -eq $EdgeClusterName})
	$SdkPolicyEdgeClusterPath = $SdkPolicyEdgeCluster.Path	
	$SiteInfo = Initialize-SiteInfo -EdgeClusterPaths $SdkpolicyEdgeClusterPath -SitePath "/infra/sites/default"
	$Project = Initialize-Project -Children $ChildPolicyConfigResource -ShortId "$ShortId" -SiteInfos $SiteInfo -Tier0s "/infra/tier-0s/$ProjectT0"	
	Invoke-PatchProject -orgId "default" -projectId $ProjectName -project $Project
		
	My-Logger "Add $ProjectName Private IP Blocks"
	$IpAddressBlock = Initialize-IpAddressBlock -Description $VpcProjectPRIVipBlockName -Id $VpcProjectPRIVipBlockName -Cidr $VpcProjectPRIVcidr -Visibility "PRIVATE"
	Invoke-OrgsOrgIdProjectsProjectIdInfraCreateOrPatchIpAddressBlock -orgId $Orgs -projectId $ProjectName -ipBlockId $VpcProjectPRIVipBlockName -ipAddressBlock $ipAddressBlock -Verbose -Debug
	
	My-Logger "Add $ProjectName External IP Blocks via API call"
	$pair = "${NSXAdminUsername}:${NSXAdminPassword}"
	$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
	$base64 = [System.Convert]::ToBase64String($bytes)

	$headers = @{
		"Authorization"="basic $base64"
		"Content-Type"="application/json"
		"Accept"="application/json"
		}
		
	$ProjectUrl = "https://$NSXTMgrHostname/policy/api/v1/orgs/default/projects/$ProjectName"
	$Getrequests = Invoke-WebRequest -Uri $ProjectUrl -Method GET -Headers $headers -SkipCertificateCheck
	$json = $Getrequests.Content | Out-String | ConvertFrom-Json
	$json.external_ipv4_blocks = @("/infra/ip-blocks/$ProjectPUBipblockName")
	$body = $json | ConvertTo-Json -Depth 10

	$Patchrequests = Invoke-WebRequest -Uri $ProjectUrl -Body $body -Method PATCH -Headers $headers -SkipCertificateCheck
}	
	

if($deployVpc -eq 1) {
    if(!(Connect-NsxServer -Server $NSXTMgrHostname -Username $NSXAdminUsername -Password $NSXAdminPassword -WarningAction SilentlyContinue)) {
        Write-Host -ForegroundColor Red "Unable to connect to NSX-T Manager, please check the deployment"
        exit
    } else {
        My-Logger "Successfully logged into NSX-T Manager $NSXTMgrHostname  ..."
    }
	
	My-Logger "Add $VpcName to $ProjectName via API call"
	
	$SdkPolicyEdgeCluster = ((Invoke-ListEdgeClustersForEnforcementPoint -siteId "default" -EnforcementpointId "default").Results | where {$_.DisplayName -eq $EdgeClusterName})
	$SdkPolicyEdgeClusterPath = $SdkPolicyEdgeCluster.Path
	
	$pair = "${NSXAdminUsername}:${NSXAdminPassword}"
	$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
	$base64 = [System.Convert]::ToBase64String($bytes)

	$headers = @{
		"Authorization"="basic $base64"
		"Content-Type"="application/json"
		"Accept"="application/json"
		}
		
	$ProjectUrl = "https://$NSXTMgrHostname/policy/api/v1/orgs/default/projects/$ProjectName"
	$Getrequests = Invoke-WebRequest -Uri $ProjectUrl -Method GET -Headers $headers -SkipCertificateCheck
	$json = $Getrequests.Content | Out-String | ConvertFrom-Json
	$jsonVPC = [pscustomobject]@{
            "resource_type" = "Vpc";
            "display_name" = $VpcName;
            "site_infos" = @(@{
				"edge_cluster_paths" = @($SdkpolicyEdgeClusterPath)
				"site_path" = "/infra/sites/default"
			})
			"default_gateway_path" = "/infra/tier-0s/$ProjectT0";
			"service_gateway" = @{
				"disable" = $false
				"auto_snat" = $true;
				}
			"ip_address_type" = "IPV4";
			"private_ipv4_blocks" = @("/orgs/default/projects/$ProjectName/infra/ip-blocks/$VpcProjectPRIVipBlockName");
			"external_ipv4_blocks" = @("/infra/ip-blocks/$ProjectPUBipblockName");
			"dhcp_config" = @{
				"enable_dhcp" = $true;
				"dns_client_config" = @{
					"dns_server_ips" = @(
						$VMDNS)
				}
				}
			}	
	$bodyVPC = $jsonVPC | ConvertTo-Json -Depth 10
	$VpcUrl = "https://$NSXTMgrHostname/policy/api/v1/orgs/default/projects/$ProjectName/vpcs/$VpcName"
	
	$PatchVPCrequests = Invoke-WebRequest -Uri $VpcUrl -Body $bodyVPC -Method PATCH -Headers $headers -SkipCertificateCheck
}

if($deployVpcSubnetPublic -eq 1) {

My-Logger "Add $VpcName public subnet $VpcPublicSubnet via API call"

$pair = "${NSXAdminUsername}:${NSXAdminPassword}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)

$headers = @{
    "Authorization"="basic $base64"
    "Content-Type"="application/json"
    "Accept"="application/json"
}

$ProjectUrl = "https://$NSXTMgrHostname/policy/api/v1/orgs/default/projects/$ProjectName/vpcs/$VpcName"	

$Getrequests = Invoke-WebRequest -Uri $ProjectUrl -Method GET -Headers $headers -SkipCertificateCheck

$json = $Getrequests.Content | Out-String | ConvertFrom-Json

$jsonVPCsubnet = [pscustomobject]@{
            "resource_type" = "VpcSubnet";
			"description" = "This is test VpcSubnet"
            "display_name" = $VpcPublicSubnet;
			"access_mode" = "Public"
			"ip_addresses" = @($VpcPublicSubnetIpaddresses)
			"ipv4_subnet_size" = $VpcPublicSubnetSize
}

$bodyVPCsubnet = $jsonVPCsubnet | ConvertTo-Json -Depth 10

$VpcSubnetUrl = "https://$NSXTMgrHostname/policy/api/v1/orgs/default/projects/$ProjectName/vpcs/$VpcName/subnets/$VpcPublicSubnet"

$PatchVPCrequests = Invoke-WebRequest -Uri $VpcSubnetUrl -Body $bodyVPCsubnet -Method PATCH -Headers $headers -SkipCertificateCheck

}

if($deployVpcSubnetPrivate -eq 1) {

My-Logger "Add $VpcName private subnet $VpcPrivateSubnet via API call"

$pair = "${NSXAdminUsername}:${NSXAdminPassword}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)

$headers = @{
    "Authorization"="basic $base64"
    "Content-Type"="application/json"
    "Accept"="application/json"
}

$ProjectUrl = "https://$NSXTMgrHostname/policy/api/v1/orgs/default/projects/$ProjectName/vpcs/$VpcName"	

$Getrequests = Invoke-WebRequest -Uri $ProjectUrl -Method GET -Headers $headers -SkipCertificateCheck

$json = $Getrequests.Content | Out-String | ConvertFrom-Json

$jsonVPCsubnet = [pscustomobject]@{
            "resource_type" = "VpcSubnet";
			"description" = "This is test VpcSubnet"
            "display_name" = $VpcPrivateSubnet;
			"access_mode" = "Private"
			"ip_addresses" = @($VpcPrivateSubnetIpaddresses)
			"ipv4_subnet_size" = $VpcPrivateSubnetSize
}

$bodyVPCsubnet = $jsonVPCsubnet | ConvertTo-Json -Depth 10

$VpcSubnetUrl = "https://$NSXTMgrHostname/policy/api/v1/orgs/default/projects/$ProjectName/vpcs/$VpcName/subnets/$VpcPrivateSubnet"

$PatchVPCrequests = Invoke-WebRequest -Uri $VpcSubnetUrl -Body $bodyVPCsubnet -Method PATCH -Headers $headers -SkipCertificateCheck

}


$EndTime = Get-Date
$duration = [math]::Round((New-TimeSpan -Start $StartTime -End $EndTime).TotalMinutes,2)

My-Logger "vSphere with Tanzu using NSX-T Lab Deployment Complete!"
My-Logger "StartTime: $StartTime"
My-Logger "  EndTime: $EndTime"
My-Logger " Duration: $duration minutes"

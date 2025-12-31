# ===============================
# WINFETCH – FINAL CONFIG (PS7)
# ===============================

# -------- Styles (bars + text) --------
$cpustyle      = 'bartext'
$memorystyle   = 'bartext'
$diskstyle     = 'bartext'
$batterystyle  = 'bartext'

# -------- Show disks (change if needed) --------
# C: = system, D: = movies (as per your setup)
$ShowDisks = @("*")

# -------- Nerd Font icons --------
$iconUser   = ""
$iconShell  = ""
$iconCpu    = ""
$iconRam    = ""
$iconDisk   = "󰋊"
$iconGpu    = "󰢮"
$iconLaptop = "󰌢"

# -------- Custom info overrides (icons) --------
function info_title {
    @{
        title   = "$iconUser $env:USERNAME"
        content = $env:COMPUTERNAME
    }
}

function info_pwsh {
    @{
        title   = "$iconShell Shell"
        content = "PowerShell $($PSVersionTable.PSVersion)"
    }
}

function info_computer {
    @{
        title   = "$iconLaptop Device"
        content = (Get-CimInstance Win32_ComputerSystem).Model
    }
}

function info_cpu {
    $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
    @{
        title   = "$iconCpu CPU"
        content = $cpu.Name
    }
}

function info_memory {
    $os = Get-CimInstance Win32_OperatingSystem
    $used = $os.TotalVisibleMemorySize - $os.FreePhysicalMemory
    $total = $os.TotalVisibleMemorySize
    @{
        title   = "$iconRam RAM"
        content = "$([math]::Round($used/1MB,1)) / $([math]::Round($total/1MB,1)) GB"
    }
}

function info_disk {
    Get-PSDrive -PSProvider FileSystem | Where-Object {
        $ShowDisks -contains $_.Name + ":"
    } | ForEach-Object {
        @{
            title   = "$iconDisk Disk ($($_.Name):)"
            content = "$([math]::Round($_.Used/1GB,1)) / $([math]::Round(($_.Used+$_.Free)/1GB,1)) GB"
        }
    }
}

function info_gpu {
    Get-CimInstance Win32_VideoController | ForEach-Object {
        @{
            title   = "$iconGpu GPU"
            content = $_.Name
        }
    }
}

# -------- Display order --------
@(
    "title"
    "dashes"
    "os"
    "computer"
    "uptime"
    "pwsh"
    "terminal"
    "resolution"
    "cpu"
    "gpu"
    "memory"
    "disk"
    "blank"
    "colorbar"
)

<#
.Synopsis
   This cmdlet will add Dynatrace >NET Agents and to a specified computer or computers.
.DESCRIPTION
   This cmdlet allows a user to add a .NET Dynatrace agent and configure the Collector, Port, AgentName, Set Active,
   and App Pool for the agent.
.PARAMETER Computername
    This parameter specifies the computer/computers you want to add Dynatrace .NET Agents on.
.PARAMETER Credential
    Use this parameter to specify another set of credentials to run the cmdlet as.
.PARAMETER Authentication
    Use this parameter if Kerberos Authenticaiton is required for remote access to the server.
    Note - This parameter is required for CSS environments, and the value to be used is 'Credssp'.
.EXAMPLE
    Add-DotNetDynaAgent -Computername <ServerName> -Active True -Collector <CollectorServerName> -Port <Port Number>
    -AgentName <.NET Agent Name> -AppPool <AppPool Name>

    Example of how to use this cmdlet to add Dynatrace .Net Agent to a server.
.EXAMPLE
    Add-DotNetDynaAgent -Computername <ServerName1,ServerName2,ServerName3> -Active True -Collector <CollectorServerName> -Port <Port Number>
    -AgentName <.NET Agent Name> -AppPool <AppPool Name>

    Examples of how to add a Dynatrace .NET Agent to multiple servers.
.EXAMPLE
    Add-DotNetDynaAgent -Computername (Get-Content c:\servers.txt)

    Example using a CSV/TXT file.
.EXAMPLE
    Add-DotNetDynaAgent -Computername <ServerName> -Active True -Collector <CollectorServerName> -Port <Port Number>
    -AgentName <.NET Agent Name> -AppPool <AppPool Name> -Credential (Get-Credential)

    Example of using the Credential parameter with Get-Credential.
.EXAMPLE
    $Creds = Get-Credential

    Add-DotNetDynaAgent -Computername <ServerName> -Active True -Collector <CollectorServerName> -Port <Port Number>
    -AgentName <.NET Agent Name> -AppPool <AppPool Name> -Credential $Creds

    Example of using the Credential parameter with using stored credentials.
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
#>
function Add-DotNetDynaAgent{
    [CmdletBinding()]
    
    Param
    (
        
        [Parameter(Valuefrompipeline=$true)]
        [string[]]$Computername = $env:COMPUTERNAME,
        [Parameter(Mandatory=$true)]
        [string]$Active,
        [Parameter(Mandatory=$true)]
        [string]$Collector,
        [Parameter(Mandatory=$true)]
        [string]$Port,
        [Parameter(Mandatory=$true)]
        [string]$AgentName,
        [Parameter(Mandatory=$true)]
        [string]$AppPool,
        [System.Management.Automation.PSCredential]$Credential,
        [string]$Authentication   

    )

    Begin
    {
        Import-Module WebAdministration  
    }



    Process
    {
        foreach($computer in $computername)
        {
           if($computer -eq $env:COMPUTERNAME -or $computer -eq 'localhost')
           {
                $architecture = (Get-WmiObject win32_OperatingSystem).osArchitecture
                   if($architecture -eq '64-bit')
                   {
                        $regkey = Test-Path "hklm:\software\wow6432node\dynatrace\agent\whitelist\1"
                        Write-Verbose "Checking for Dynatrace RegKay Path"
                   }
                   else
                   {
                        $regkey = Test-Path "hklm:\software\dynatrace\agent\whitelist\1"
                        Write-Verbose "Checking for Dynatrace RegKey Path"
                   }
                if($regkey -eq $False)
                {
                   $architecture = (Get-WmiObject win32_OperatingSystem).osArchitecture
                   if($architecture -eq '64-bit')
                   {
                        $NewDynaPath = "hklm:\software\wow6432node\dynatrace\agent\whitelist"
                   }
                   else
                   {
                        $NewDynaPath = "hklm:\software\dynatrace\agent\whitelist"
                   }

                    $AppPoolVersion = (Get-ChildItem IIS:\AppPools | 
                    Select-Object -Property name,enable32bitapponwin64 | 
                    Where-Object -Property name -eq $AppPool)

                    if($AppPoolVersion.enable32bitapponwin64 -eq $false)
                    {
                        $IISProcPath = "c:\windows\system32\inetsrv"
                    }
                    Else
                    {
                        If((Get-CimInstance -ClassName Win32_OperatingSystem).Version -eq '6.3.9600')
                        {
                            $IISProcPath = "C:\windows\SysWOW64\inetsrv"
                        }
                        Else
                        {
                            $IISProcPath = "C:\Windows\SysWOW64\inetsrv"
                        }
                    }
                    $NewDynaKey = New-Item -Path $NewDynaPath -Name 1 -Force
                    New-ItemProperty -Path $NewDynaKey.PSPath -Name active -Value $Active
                    New-ItemProperty -Path $NewDynaKey.PSPath -Name port -Value $Port
                    New-ItemProperty -Path $NewDynaKey.PSPath -Name server -Value $Collector
                    New-itemproperty -Path $NewDynaKey.PSPath -Name cmdline -Value "-ap ""$AppPool"""
                    New-ItemProperty -Path $NewDynaKey.PSPath -Name name -Value $AgentName
                    New-ItemProperty -Path $NewDynakey.PSPath -Name logfile
                    New-ItemProperty -Path $NewDynaKey.PSPath -Name exec -Value w3wp.exe
                    New-ItemProperty -Path $NewDynaKey.PSPath -Name loglevelcon -Value LOG_INFO
                    New-ItemProperty -Path $NewDynaKey.PSPath -Name loglevelfile -Value LOG_INFO
                    New-ItemProperty -Path $NewDynaKey.PSPath -Name path -Value $IISProcPath
                    Write-Verbose "Adding new Registry values on $computer $Active,$Port,$Collector,$AppPool,$AgentName"  
                }
                Else
                {
                   $ID = Get-DynaInfo -Computername $computer | 
                         Select-Object -Property Dynatraceid -ExpandProperty Dynatraceid |
                         Sort-Object -Property Dynatraceid -Descending

                   if($ID.count -lt 2)
                   {   
                        $LastID = [int]$ID
                   }
                   Else
                   {
                        $LastID = [int]$ID[0]
                   }   

                   $newdynaID = $LastID + 1
                   Write-Verbose "Adding new Agent Key Value of $newdynaID"

                   $architecture = (Get-WmiObject win32_OperatingSystem).osArchitecture
                   if($architecture -eq '64-bit')
                   {
                        $NewDynaPath = "hklm:\software\wow6432node\dynatrace\agent\whitelist\$newdynaID"
                   }
                   else
                   {
                        $NewDynaPath = "hklm:\software\dynatrace\agent\whitelist\$newynaID"
                   }
               
                   $AppPoolVersion = (Get-ChildItem IIS:\AppPools | 
                   Select-Object -Property name,enable32bitapponwin64 | 
                   Where-Object -Property name -eq $AppPool)

                   if($AppPoolVersion.enable32bitapponwin64 -eq $false)
                    {
                        $IISProcPath = "c:\windows\system32\inetsrv"
                    }
                    Else
                    {
                        If((Get-CimInstance -ClassName Win32_OperatingSystem).Version -eq '6.3.9600')
                        {
                            $IISProcPath = "C:\windows\SysWOW64\inetsrv"
                        }
                        Else
                        {
                            $IISProcPath = "C:\Windows\SysWOW64\inetsrv"
                        }
                    }
                   New-Item -Path $NewDynaPath -ItemType Key -Force
                   New-ItemProperty -Path $NewDynaPath -Name active -Value $Active
                   New-ItemProperty -Path $NewDynaPath -Name port -Value $Port
                   New-ItemProperty -Path $NewDynaPath -Name server -Value $Collector
                   New-itemproperty -Path $NewDynaPath -Name cmdline -Value "-ap ""$AppPool"""
                   New-ItemProperty -Path $NewDynaPath -Name name -Value $AgentName
                   New-ItemProperty -Path $NewDynaPath -Name logfile
                   New-ItemProperty -Path $NewDynaPath -Name exec -Value w3wp.exe
                   New-ItemProperty -Path $NewDynaPath -Name loglevelcon -Value LOG_INFO
                   New-ItemProperty -Path $NewDynaPath -Name loglevelfile -Value LOG_INFO
                   New-ItemProperty -Path $NewDynaPath -Name path -Value $IISProcPath
                   Write-Verbose "Adding new Registry values $Active,$Port,$Collector,$AppPool,$AgentName"
                }

           }
           Else
           {
                
                $checkreg = {
                        
                    $architecture = (Get-WmiObject win32_OperatingSystem).osArchitecture
                        if($architecture -eq '64-bit')
                        {
                            Test-Path "hklm:\software\wow6432node\dynatrace\agent\whitelist\1"
                        }
                        else
                        {
                            Test-Path "hklm:\software\dynatrace\agent\whitelist\1"
                        }
                }
                if($PSBoundParameters.ContainsKey('Credential'))
                {
                   
                    if($PSBoundParameters.ContainsKey('Authentication'))
                    {
                        $regkey = Invoke-Command -ComputerName $computer -Credential $Credential -Authentication $Authentication -ErrorAction Stop -ScriptBlock $checkreg
                        Write-Verbose "Checking Registry of Remote Computer $computer for Dynatrace"
                    }
                    Else
                    {
                        $regkey = Invoke-Command -ComputerName $computer -Credential $Credential -ErrorAction Stop -ScriptBlock $checkreg
                        Write-Verbose "Checking Registry of Remote Computer $computer for Dynatrace"
                    }
                }
                Else
                {
                    $regkey = Invoke-Command -ComputerName $computer -ErrorAction Stop -ScriptBlock $checkreg
                    Write-Verbose "Checking Registry of Remote Computer $computer for Dynatrace"
                }    
                
                if($regkey -eq $False)
                {
                    $architecture = (Get-WmiObject win32_OperatingSystem).osArchitecture
                    if($architecture -eq '64-bit')
                    {
                        $NewDynaPath = "hklm:\software\wow6432node\dynatrace\agent\whitelist"
                    }
                    else
                    {
                        $NewDynaPath = "hklm:\software\dynatrace\agent\whitelist"
                    }

                    $NewDynaAgent = {
                        param($Active,$Collector,$Port,$AgentName,$AppPool,$NewDynaPath)
                        Import-Module WebAdministration
                        $AppPoolVersion = (Get-ChildItem IIS:\AppPools | 
                        Select-Object -Property name,enable32bitapponwin64 | 
                        Where-Object -Property name -eq $AppPool)

                        if($AppPoolVersion.enable32bitapponwin64 -eq $false)
                        {
                            $IISProcPath = "c:\windows\system32\inetsrv"
                        }
                        Else
                        {
                            If((Get-CimInstance -ClassName Win32_OperatingSystem).Version -eq '6.3.9600')
                            {
                                $IISProcPath = "C:\windows\SysWOW64\inetsrv"
                            }
                            Else
                            {
                                $IISProcPath = "C:\Windows\SysWOW64\inetsrv"
                            }
                        }
                        $NewDynaKey = New-Item -Path $NewDynaPath -Name 1 -Force
                        New-ItemProperty -Path $NewDynaKey.PSPath -Name active -Value $Active
                        New-ItemProperty -Path $NewDynaKey.PSPath -Name port -Value $Port
                        New-ItemProperty -Path $NewDynaKey.PSPath -Name server -Value $Collector
                        New-itemproperty -Path $NewDynaKey.PSPath -Name cmdline -Value "-ap ""$AppPool"""
                        New-ItemProperty -Path $NewDynaKey.PSPath -Name name -Value $AgentName
                        New-ItemProperty -Path $NewDynakey.PSPath -Name logfile
                        New-ItemProperty -Path $NewDynaKey.PSPath -Name exec -Value w3wp.exe
                        New-ItemProperty -Path $NewDynaKey.PSPath -Name loglevelcon -Value LOG_INFO
                        New-ItemProperty -Path $NewDynaKey.PSPath -Name loglevelfile -Value LOG_INFO
                        New-ItemProperty -Path $NewDynaKey.PSPath -Name path -Value $IISProcPath
                        Write-Verbose "Adding new Registry values on $computer $Active,$Port,$Collector,$AppPool,$AgentName"
                    }
                    if($PSBoundParameters.ContainsKey('Credential'))
                    {
                        if($PSBoundParameters.ContainsKey('Authentication'))
                        {
                            Try
                            {
                                Invoke-Command -ComputerName $computer -Credential $Credential -Authentication $Authentication -ErrorAction Stop -ScriptBlock $NewDynaAgent -ArgumentList $Active,$Collector,$Port,$AgentName,$AppPool,$NewDynaPath
                                Write-Verbose "Creating new Dynatrace agent on $computer called $AgentName"
                            }
                            Catch
                            {
                                Write-Error "Unable to connect to $computer, either remoting is not enabled or there is a kerberos error"
                                Write-Error $error[1]
                            }
                        }
                        Else
                        {
                            Try
                            {
                                Invoke-Command -ComputerName $computer -Credential $Credential -ErrorAction Stop -ScriptBlock $NewDynaAgent -ArgumentList $Active,$Collector,$Port,$AgentName,$AppPool,$NewDynaPath
                                Write-Verbose "Creating new Dynatrace agent on $computer called $AgentName"
                            }
                            Catch
                            {
                                Write-Error "Unable to connect to $computer, either remoting is not enabled or there is a kerberos error"
                                Write-Error $error[1]
                            }
                        }
                    }
                    Else
                    {
                        Try
                        {
                            Invoke-Command -ComputerName $computer -ErrorAction Stop -ScriptBlock $NewDynaAgent -ArgumentList $Active,$Collector,$Port,$AgentName,$AppPool,$NewDynaPath
                            Write-Verbose "Creating new Dynatrace agent $computer called $AgentName"
                        }
                        Catch
                        {
                            Write-Error "Unable to connect to $computer, either remoting is not enabled or there is a kerberos error"
                            Write-Error $error[1]
                        }
                    }
                    
                        
                }

                     Else
                     {
                        if($PSBoundParameters.ContainsKey('Credential'))
                        {
                            if($PSBoundParameters.ContainsKey('Authentication'))
                            {
                                $ID = Get-DynaInfo -Computername $computer -Credential $Credential -Authentication $Authentication | 
                                      Select-Object -Property Dynatraceid -ExpandProperty Dynatraceid |
                                      Sort-Object -Property Dynatraceid -Descending
                            }
                            Else
                            {
                                $ID = Get-DynaInfo -Computername $computer -Credential $Credential | 
                                      Select-Object -Property Dynatraceid -ExpandProperty Dynatraceid |
                                      Sort-Object -Property Dynatraceid -Descending
                            }
                        }
                        Else
                        {
                            $ID = Get-DynaInfo -Computername $computer | 
                                  Select-Object -Property Dynatraceid -ExpandProperty Dynatraceid |
                                  Sort-Object -Property Dynatraceid -Descending
                        }
                        
                         if($ID.count -lt 2)
                         {   
                            $LastID = [int]$ID
                         }
                         Else
                         {
                            $LastID = [int]$ID[0]
                         }   

                         $newdynaID = $LastID + 1
             
                         $architecture = (Get-WmiObject -ComputerName $computer -Credential $Credential win32_OperatingSystem).osArchitecture
                         if($architecture -eq '64-bit')
                         {
                             $NewDynaPath = "hklm:\software\wow6432node\dynatrace\agent\whitelist\$newdynaID"
                         }
                         else
                         {
                             $NewDynaPath = "hklm:\software\dynatrace\agent\whitelist\$newdynaID"
                         }

                         $NewDynaAgent = {
                            param($Active,$Collector,$Port,$AgentName,$AppPool,$NewDynaPath)
                            Import-Module WebAdministration
                            $AppPoolVersion = (Get-ChildItem IIS:\AppPools | 
                            Select-Object -Property name,enable32bitapponwin64 | 
                            Where-Object -Property name -eq $AppPool)

                            if($AppPoolVersion.enable32bitapponwin64 -eq $false)
                            {
                                $IISProcPath = "c:\windows\system32\inetsrv"
                            }
                            Else
                            {
                                If((Get-CimInstance -ClassName Win32_OperatingSystem).Version -eq '6.3.9600')
                                {
                                    $IISProcPath = "C:\windows\SysWOW64\inetsrv"
                                }
                                Else
                                {
                                    $IISProcPath = "C:\Windows\SysWOW64\inetsrv"
                                }
                            }
                            New-Item -Path $NewDynaPath -ItemType Key -Force
                            New-ItemProperty -Path $NewDynaPath -Name active -Value $Active
                            New-ItemProperty -Path $NewDynaPath -Name port -Value $Port
                            New-ItemProperty -Path $NewDynaPath -Name server -Value $Collector
                            New-itemproperty -Path $NewDynaPath -Name cmdline -Value "-ap ""$AppPool"""
                            New-ItemProperty -Path $NewDynaPath -Name name -Value $AgentName
                            New-ItemProperty -Path $NewDynaPath -Name logfile
                            New-ItemProperty -Path $NewDynaPath -Name exec -Value w3wp.exe
                            New-ItemProperty -Path $NewDynaPath -Name loglevelcon -Value LOG_INFO
                            New-ItemProperty -Path $NewDynaPath -Name loglevelfile -Value LOG_INFO
                            New-ItemProperty -Path $NewDynaPath -Name path -Value $IISProcPath
                            Write-Verbose "Adding new Registry values on $computer $Active,$Port,$Collector,$AppPool,$AgentName"
                         }
                                            
                         if($PSBoundParameters.ContainsKey('Credential'))
                         {
                              if($PSBoundParameters.ContainsKey('Authentication'))
                              {
                                  Try
                                  {
                                      Invoke-Command -ComputerName $computer -Credential $Credential -Authentication $Authentication -ErrorAction Stop -ScriptBlock $NewDynaAgent -ArgumentList $Active,$Collector,$Port,$AgentName,$AppPool,$NewDynaPath
                                      Write-Verbose "Creating new Dynatrace agent $computer called $AgentName"
                                  }
                                  Catch
                                  {
                                      Write-Error "Unable to connect to $computer, either remoting is not enabled or there is a kerberos error"
                                      Write-Error $error[1]
                                  }
                              }
                              Else
                              {
                                  Try
                                  {
                                      Invoke-Command -ComputerName $computer -Credential $Credential -ErrorAction Stop -ScriptBlock $NewDynaAgent -ArgumentList $Active,$Collector,$Port,$AgentName,$AppPool,$NewDynaPath
                                      Write-Verbose "Creating new Dynatrace agent $computer called $AgentName"
                                  }
                                  Catch
                                  {
                                      Write-Error "Unable to connect to $computer, either remoting is not enabled or there is a kerberos error"
                                      Write-Error $error[1]
                                  }
                              }
                         }
                         Else
                         {
                            Try
                            {
                                Invoke-Command -ComputerName $computer -ErrorAction Stop -ScriptBlock $NewDynaAgent -ArgumentList $Active,$Collector,$Port,$AgentName,$AppPool,$NewDynaPath
                            }
                            Catch
                            {
                                Write-Error "Unable to connect to $computer, either remoting is not enabled or there is a kerberos error"
                                Write-Error $error[1]
                            }
                         }
                         
                         
                     }
                
                  
           }
         
              
        }
            

    }
   
    
End{}  

}




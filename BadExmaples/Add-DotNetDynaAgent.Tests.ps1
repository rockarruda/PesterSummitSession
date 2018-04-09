Function MockRegistry1{
        param($Active,$Name,$exec,$server,$port)
        $RegPath1 = 'hklm:\software\wow6432node\dynatrace\agent\whitelist\1'
        New-Item -Path $RegPath1 -ItemType Key -Force | Out-Null
        New-ItemProperty -Path $RegPath1 -Name 'Active' -Value $Active | Out-Null
        New-ItemProperty -Path $RegPath1 -Name 'name' -Value $Name | Out-Null
        New-ItemProperty -Path $RegPath1 -Name 'exec' -Value $exec | Out-Null
        New-ItemProperty -Path $RegPath1 -Name 'server' -Value $server | Out-Null
        New-ItemProperty -Path $RegPath1 -Name 'port' -Value $port | Out-Null
        New-ItemProperty -Path $RegPath1 -Name 'logfile' -Value ''
        New-ItemProperty -Path $RegPath1 -Name 'loglevelcon' -Value LOG_INFO
        New-ItemProperty -Path $RegPath1 -Name 'loglevelfile' -Value LOG_INFO
        New-ItemProperty -Path $RegPath1 -Name 'path' -Value c:\windows\syswow64\inetsrv        
}

Function MockRegistry2{
        param($Active,$Name,$exec,$server,$port)
        $RegPath2 = 'hklm:\software\wow6432node\dynatrace\agent\whitelist\2'
        New-Item -Path $RegPath2 -ItemType Key -Force | Out-Null
        New-ItemProperty -Path $RegPath2 -Name 'Active' -Value $Active | Out-Null
        New-ItemProperty -Path $RegPath2 -Name 'name' -Value $Name | Out-Null
        New-ItemProperty -Path $RegPath2 -Name 'exec' -Value $exec | Out-Null
        New-ItemProperty -Path $RegPath2 -Name 'server' -Value $server | Out-Null
        New-ItemProperty -Path $RegPath2 -Name 'port' -Value $port | Out-Null
        New-ItemProperty -Path $RegPath2 -Name 'logfile' -Value ''
        New-ItemProperty -Path $RegPath2 -Name 'loglevelcon' -Value LOG_INFO
        New-ItemProperty -Path $RegPath2 -Name 'loglevelfile' -Value LOG_INFO
        New-ItemProperty -Path $RegPath2 -Name 'path' -Value c:\windows\syswow64\inetsrv       
}

Function MockRegistry3{
        param($Active,$Name,$exec,$server,$port)
        $RegPath3 = 'hklm:\software\wow6432node\dynatrace\agent\whitelist\3'
        New-Item -Path $RegPath3 -ItemType Key -Force | Out-Null
        New-ItemProperty -Path $RegPath3 -Name 'Active' -Value $Active | Out-Null
        New-ItemProperty -Path $RegPath3 -Name 'name' -Value $Name | Out-Null
        New-ItemProperty -Path $RegPath3 -Name 'exec' -Value $exec | Out-Null
        New-ItemProperty -Path $RegPath3 -Name 'server' -Value $server | Out-Null
        New-ItemProperty -Path $RegPath3 -Name 'port' -Value $port | Out-Null
        New-ItemProperty -Path $RegPath3 -Name 'logfile' -Value ''
        New-ItemProperty -Path $RegPath3 -Name 'loglevelcon' -Value LOG_INFO
        New-ItemProperty -Path $RegPath3 -Name 'loglevelfile' -Value LOG_INFO
        New-ItemProperty -Path $RegPath3 -Name 'path' -Value c:\windows\syswow64\inetsrv       
}

Describe 'Add-DotNetDynaAgent'{
    BeforeAll{
       MockRegistry1 -Active 'true' -Name 'TestAgent1' -exec 'test.exe' -server 'Server0001' -port '9999'
       MockRegistry2 -Active 'true' -Name 'TestAgent2' -exec 'test.exe' -server 'Server0002' -port '9999'
       MockRegistry3 -Active 'true' -Name 'TestAgent3' -exec 'test.exe' -server 'Server0003' -port '9999'
    }

    Context 'From Local Machine'{
        It 'Should return a value of 4' {
            Add-DotNetDynaAgent -Active True -Port 9999 -Collector Johndynad22 -AppPool 'Default AppPool' -AgentName 'TestDynaAdd'
            $NewID = Get-DynaInfo |
                     Select-Object -Property DynatraceID -ExpandProperty DynatraceID |
                     Sort-Object -Property DynatraceID -Descending
            $NewID -contains '4' | Should Be $True
        }

        $NewAgent = Get-DynaInfo | Sort-Object -Property DynatraceID -Descending | Select-Object -First 1
            
        It 'Should return Collector Value of Johndynad22'{
            $NewAgent.Collector | Should Be 'Johndynad22'
        }

        It 'Should return Active Value as True'{
            $NewAgent.Active | Should Be 'True'
        }
        
        It 'Should return AppPool Value as -ap "Default AppPool"'{
            $NewAgent.AppPool | Should Be '-ap "Default AppPool"'
        }

        It 'Should return Port Value as 9999'{
            $NewAgent.port | Should Be '9999'
        }

        It 'Should return AgentName as TestDynaAdd'{
            $NewAgent.agentname | Should Be 'TestDynaAdd'
        }

        It 'Should return logfile as null'{
            $NewAgent.logfile | Should Be ''
        }

        It 'Should return loglevelcon as LOG_INFO'{
            $NewAgent.loglevelcon
        }
        
    }
    
    AfterAll{
         Remove-Item -Path 'hklm:\software\wow6432node\dynatrace\agent' -Force -Recurse
    }

    Context 'Create New Agent on Remote Server without Dynatrace Agents'{
        $creds = Get-Credential
        Add-DotNetDynaAgent -Computername johnptwss51 -Active True -Port 9999 -Collector Johndynad22 -AppPool 'Default AppPool' -AgentName 'TestDynaAgent' -Credential $creds
        $NewRemoteAgent = Get-DynaInfo -Computername johnptwss51 -Credential $creds | Sort-Object -Property DynatraceID -Descending | Select-Object -First 1
        
        It 'Should return New Dynatrace ID of Value 1'{
            $NewRemoteAgent.dynatraceid -contains '1' | Should Be $True
        }

        It 'Should return New Collector Value of Johndynad22'{
            $NewRemoteAgent.collector | Should Be 'Johndynad22'
        }

        It 'Should return New AppPool Value of Default AppPool'{
            $NewRemoteAgent.apppool | Should Be '-ap "Default AppPool"'
        }

        It 'Should return New AgentName Value of TestDynaAgent'{
            $NewRemoteAgent.agentname | Should Be 'TestDynaAgent'
        }

        It 'Should return New Port Value of 9999'{
            $NewRemoteAgent.port | Should Be '9999'
        }
    }

    Context 'Add Agent to Remote Server'{
        $creds = Get-Credential
        Add-DotNetDynaAgent -Computername johnptwss51 -Active True -Port 9999 -Collector Johndynad22 -AppPool 'Default AppPool' -AgentName 'TestDynaAdd' -Credential $creds
        $NewRemoteAgent = Get-DynaInfo -Computername johnptwss51 -Credential $creds | Sort-Object -Property DynatraceID -Descending | Select-Object -First 1

        It 'Should return New Dynatrace ID Value of 2'{
            $NewRemoteAgent.dynatraceid -contains '2'| Should Be $True
        }

        It 'Should return New Collector Value of Johndynad22'{
            $NewRemoteAgent.collector | Should Be 'Johndynad22'
        }

        It 'Should return New AppPool Value of Default AppPool'{
            $NewRemoteAgent.apppool | Should Be '-ap "Default AppPool"'
        }

        It 'Should return New AgentName Value of TestDynaAdd'{
            $NewRemoteAgent.agentname | Should Be 'TestDynaAdd'
        }

        It 'Should return New Port Value of 9999'{
            $NewRemoteAgent.port | Should Be '9999'
        }


    }   

}
                    
                

    

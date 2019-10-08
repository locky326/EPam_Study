#Задание 5

#1.	При помощи WMI перезагрузить все виртуальные машины.
$c = get-credential administrator
$Computers = @("win-1")
Get-WmiObject win32_operatingsystem -ComputerName $computers -Credential $c | Invoke-WmiMethod -Name reboot


#2.	При помощи WMI просмотреть список запущенных служб на удаленном компьютере. 
$Computers = @("win-1")
WinRM set winrm/config/client '@{TrustedHosts="*"}'
Invoke-Command -ScriptBlock {Get-Process} -ComputerName $Computers #-Credential administrator

#3.	Настроить PowerShell Remoting, для управления всеми виртуальными машинами с хостовой.
winrm quickconfig
Enable-PSRemoting

#4.	Для одной из виртуальных машин установить для прослушивания порт 42658. Проверить работоспособность PS Remoting.

get-Item WSMan:\localhost\Listener\Listener*\port | fl name, value # читаем порт показывает стандартный 5985
Set-Item WSMan:\localhost\listener\listener*\port -Value 42658
get-Item WSMan:\localhost\Listener\Listener*\port | fl name, value # читаем порт, показывает 42658
# запускаем любую команду, например 
Invoke-Command -ScriptBlock {Get-Process} -ComputerName $Computers
# убеждаемся, что все работает

#5.	Создать конфигурацию сессии с целью ограничения использования всех команд, кроме просмотра содержимого дисков.
New-PSSessionConfigurationFile -path d:\conf.pssc -VisibleCmdlets Get-ChildItem -VisibleProviders FileSystem
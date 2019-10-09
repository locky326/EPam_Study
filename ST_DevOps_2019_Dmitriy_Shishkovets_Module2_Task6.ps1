#Задание 6 

#1.	    Для каждого пункта написать и выполнить соответсвующий скрипт автоматизации администрирования:

#1.1.	Вывести все IP адреса вашего компьютера (всех сетевых интерфейсов)

Get-WmiObject -Class win32_NetworkAdapterConfiguration -Filter ipenabled=True -ComputerName * | select -ExpandProperty ipaddress

#1.2.	Получить mac-адреса всех сетевых устройств вашего компьютера и удалённо.
$c = get-credential administrator
$Computers = @("win-1","win-2","win-3")
Get-WmiObject -Class win32_NetworkAdapterConfiguration -Filter ipenabled=True `
-ComputerName . | select PSComputerName,description,macaddress  # свой комп
Get-WmiObject -Class win32_NetworkAdapterConfiguration -Filter ipenabled=True `
-ComputerName $Computers -Credential $c | select PSComputerName,description,macaddress #список удаленных компов

#1.3.	На всех виртуальных компьютерах настроить (удалённо) получение адресов с DHСP.

Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=true `
-ComputerName $Computers -Credential $c | ForEach-Object -Process {$_.InvokeMethod("EnableDHCP", $null)}

#1.4.	Расшарить папку на компьютере

net share papka121=d:\121 /users:25 /remark:"folder 121"
#или
Get-WmiObject -List -ComputerName . | Where-Object -FilterScript `
{$_.Name –eq "Win32_Share"}).InvokeMethod("Create",("d:\121","papka121",0,25,"folder121"))

#1.5.	Удалить шару из п.1.4

net share papka121 /delete
#или
(Get-WmiObject -Class Win32_Share -ComputerName . -Filter "Name='papka121'").InvokeMethod("Delete",$null)

#1.6.	Скрипт входными параметрами которого являются Маска подсети и два ip-адреса. Результат  – сообщение (ответ) в одной ли подсети эти адреса.

#####################

#2.	    Работа с Hyper-V
#2.1.	Получить список коммандлетов работы с Hyper-V (Module Hyper-V)

Get-Help hyper-v -Category cmdlet

#2.2.	Получить список виртуальных машин 

Get-VM |select name

#2.3.	Получить состояние имеющихся виртуальных машин

Get-VM

#2.4.	Выключить виртуальную машину

Stop-VM -Name VM1 -Force #просто выключить
Stop-VM -Name VM1 -TurnOff #жестко выключить

#2.5.	Создать новую виртуальную машину

$VMName = "VM4"

 $VM = @{
     Name = $VMName
     MemoryStartupBytes = 2147483648
     Generation = 2
     NewVHDPath = "C:\Virtual Machines\$VMName\$VMName.vhdx"
     NewVHDSizeBytes = 53687091200
     BootDevice = "VHD"
     Path = "C:\Virtual Machines\$VMName"
     SwitchName = (Get-VMSwitch).Name
 }

 New-VM @VM

#2.6.	Создать динамический жесткий диск

New-VHD -Path d:\VM\Disk.vhdx -SizeBytes 20GB

#2.7.	Удалить созданную виртуальную машину

Remove-VM -Name vm4

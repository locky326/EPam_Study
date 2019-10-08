#Задание 4

#1.	Вывести список всех классов WMI на локальном компьютере. 

Get-WmiObject -list

#2.	Получить список всех пространств имён классов WMI. 

Get-WmiObject -List -Namespace "root"

#3.	Получить список классов работы с принтером.

Get-WmiObject -List | where {$_.name -like "*printer*"}

#4.	Вывести информацию об операционной системе, не менее 10 полей.

Get-WmiObject Win32_OperatingSystem | Select-Object PSComputerName, version, BuildNumber, Locale , `
FREE, InstallDate, Manufacturer, ProductType, SerialNumber, TotalVirtualMemorySize

#5.	Получить информацию о BIOS.

Get-WmiObject Win32_bios | select version, Description, Manufacturer , SerialNumber, Status, CurrentLanguage, BIOSVersion, PSComputerName

#6.	Вывести свободное место на локальных дисках. На каждом и сумму.

$c = 0
Get-WmiObject Win32_LogicalDisk | foreach-object { $c+=$_.freespace; Write-Host "On Disk " $_.deviceid , ($_.freespace / 1Gb) " Gb" }
"Total free space: " + ($c/1Gb) +" Gb"

#7.	Написать сценарий, выводящий суммарное время пингования компьютера (например 10.0.0.1) в сети.

$in_host = '10.0.0.1'
$PingTime=0
for($i=0; $i -lt 5; $i++)
{
    $info=Get-WmiObject -Class win32_pingstatus -f "Address='$in_host'"  
    write-host "Address" $in_host "Time:" $info.responsetime "ms" "Status" $info.StatusCode "TTL" $info.TimeToLive
    $PingTime+=$info.ResponseTime
}
Write-Host "Total Ping" $PingTime "ms" 

#8.	Создать файл-сценарий вывода списка установленных программных продуктов в виде таблицы с полями Имя и Версия.

Get-WmiObject Win32_Product | select name, version

#9.	Выводить сообщение при каждом запуске приложения MS Word.

register-wmiEvent -query "select * from __instancecreationevent within 5 where targetinstance isa 'Win32_Process' `
and targetinstance.name='winword.exe'" -sourceIdentifier "Process word" `
-Action {(New-Object -ComObject Wscript.Shell).Popup("Word Started") } 

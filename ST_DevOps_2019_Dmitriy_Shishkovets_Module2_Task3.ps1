#Задание 3

#1.	Создайте сценарии *.ps1 дл я задач из labwork 2, проверьте их работоспостобность. Каждый сценарий должен иметь параметры.
#1.1.	Сохранить в текстовый файл на диске список запущенных(!) служб. Просмотреть содержимое диска. Вывести содержимое файла в консоль PS.
  #Содержимое файла первого скрипта.

Param (
	  [string]$OutFile='c:\temp\services.txt'
	     )
Get-Service | Where{$_.Status -eq "Running"} > $OutFile
Get-ChildItem
Get-Content $OutFile

#1.2.	Просуммировать все числовые значения переменных среды Windows. (Параметры не нужны)
  #Содержимое файла второго скрипта.

$zz=0
(Get-ChildItem env:) | foreach-object {$zz+=$_.value} -ErrorAction SilentlyContinue

#1.3.	Вывести список из 10 процессов занимающих дольше всего процессор. Результат записывать в файл.
  #Содержимое файла второго скрипта.
  
Param (
  [string]$OutFile = 'c:\temp\Processes.txt',
  [int]$FirstNum = 10
	     )
  Get-Process | Sort-Object UserProcessorTime -Descending | Select-Object  ID, UserProcessorTime -first $FirstNum > $OutFile  -ErrorAction SilentlyContinue

#1.3.1.	Организовать запуск скрипта каждые 10 минут

$script =  "C:\Temp\proc.ps1"
$jobname = "Top X Processes"
$repeat = (New-TimeSpan -Minutes 10)
 
$scriptblock = [scriptblock]::Create($script)
$trigger = New-JobTrigger -Once -At (Get-Date).Date -RepeatIndefinitely -RepetitionInterval $repeat
$msg = "Enter the username and password that will run the task"; 
$credential = $Host.UI.PromptForCredential("Task username and password",$msg,"$env:userdomain\$env:username",$env:userdomain)
 
$options = New-ScheduledJobOption -RunElevated -ContinueIfGoingOnBattery -StartIfOnBattery
Register-ScheduledJob -Name $jobname -ScriptBlock $scriptblock -Trigger $trigger -ScheduledJobOption $options -Credential $credential

#1.4.	Подсчитать размер занимаемый файлами в папке (например C:\windows) за исключением файлов с заданным расширением(напрмер .tmp)
  #Содержимое файла четвертого скрипта.
Param (
  [string]$DirToCount = 'c:\temp\Processes.txt',
  [string]$ExcludeFiles = '*.tmp',
  [int]$FirstNum = 10
	     )
"{0:N2} GB" -f ((Get-ChildItem $DirToCount -Recurse -Exclude $ExcludeJiles | measure Length -Sum).sum / 1Gb)

#1.5.	Создать один скрипт, объединив 3 задачи:
#1.5.1.	Сохранить в CSV-файле информацию обо всех обновлениях безопасности ОС.
#1.5.2.	Сохранить в XML-файле информацию о записях одной ветви реестра HKLM:\SOFTWARE\Microsoft.
#1.5.3.	Загрузить данные из полученного в п.1.5.1 или п.1.5.2 файла и вывести в виде списка  разным разными цветами
  #Содержимое файла пятого скрипта.

Param (
  [string]$FileCSV = 'update.csv',
  [string]$FileXML = 'reestr.xml'
  	     )
HotFix | where{$_.Description -eq "Security Update"} | Export-Csv $FileCSV
Get-ChildItem HKLM:\SOFTWARE\Microsoft | Export-Clixml $FileXML
import-csv  $FileCSV | select -Property CSName, Hotfixid | Write-host -f blue
import-clixml  $FileXML |  Write-host -f yellow

#2.	Работа с профилем
#2.1.	Создать профиль

New-Item -ItemType file -Path $profile -force

#2.2.	В профиле изненить цвета в консоли PowerShell
#2.3.	Создать несколько собственный алиасов
#2.4.	Создать несколько констант
#2.5.	Изменить текущую папку
#2.6.	Вывести приветсвие
# Изменение внешнего вида консоли
# Для настройки используем команду: notepad $profile , и редактируем профиль.

 (Get-Host).UI.RawUI.ForegroundColor = "green"
 (Get-Host).UI.RawUI.BackgroundColor = "black"
 (Get-Host).UI.RawUI.CursorSize = 10
 (Get-Host).UI.RawUI.WindowTitle = "Hallo world!"
 
# Установка директорию по умолчанию
 Set-Location d:\
 
# Новые алиасы
 Set-Alias HelpMе Get-Help
 Set-Alias Izydi Clear-Host
 
# Добавление всех зарегистрированных оснасток и модулей
 Get-Pssnapin -Registered | Add-Pssnapin -Passthru -ErrorAction SilentlyContinue
 Get-Module -ListAvailable| Import-Module -PassThru -ErrorAction SilentlyContinue
 
#константы
set-variable -name sto -value ([int64]100) -option Constant
set-variable -name dvesti -value ([int64]200) -option Constant


# Очиcтка экрана
 Clear-Host
 
# Приветствие 
 Write-Host "Yes, My Lord !!!"

#2.7.	Проверить применение профиля

# Перезапускаем павершел, и убеждаемся что консоль поменяла цвета, вывела приветствие и сменила наименование окна.

#3.	Получить список всех доступных модулей

Get-Module -listAvailable


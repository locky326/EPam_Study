# 1.	Просмотреть содержимое ветви реeстра HKCU

cd HKCU:\
Get-ChildItem

# 2.	Создать, переименовать, удалить каталог на локальном диске

New-Item -ItemType Directory -force -Path E:\121
Rename-Item -path e:\121 -NewName E:\122
Remove-Item -path e:\121

# 3.	Создать папку C:\M2T2_ФАМИЛИЯ. Создать диск ассоциированный с папкой E:\M2T2_ФАМИЛИЯ.

New-Item -ItemType Directory -force -Path E:\M2T2_SHISHKOVETS
New-PSDrive -Name K -PSProvider FileSystem -Root "E:\M2T2_SHISHKOVETS"

# 4.	Сохранить в текстовый файл на созданном диске список запущенных(!) служб. 
#       Просмотреть содержимое диска. Вывести содержимое файла в консоль PS.

cd k:
Get-Service | Where{$_.Status -eq "Running"} > services.txt
Get-ChildItem
Get-Content services.txt

# 5.	Просуммировать все числовые значения переменных текущего сеанса.

$zz=0
Get-Variable | foreach-object {$zz+=$_.value} -ErrorAction SilentlyContinue

# 6.	Вывести список из 6 процессов занимающих дольше всего процессор.

Get-Process | Sort-Object TotalProcessorTime -Descending | Select-Object  ID, UserProcessorTime -first 5

# 7.	Вывести список названий и занятую виртуальную память (в Mb) каждого процесса, разделённые знаком тире,
#       при этом если процесс занимает более 100Mb – выводить информацию красным цветом, иначе зелёным.

get-process | foreach-object{
if ($_.VirtualMemorySize -lt 100000000 ) {
write-host -f green -Separator "-" $_.name ($_.VirtualMemorySize / 1Mb )}`
else{ write-host -f red -Separator "-"$_.name ($_.VirtualMemorySize / 1Mb )}}
# 8.	Подсчитать размер занимаемый файлами в папке C:\windows (и во всех подпапках) за исключением файлов *.tmp

"{0:N2} GB" -f ((Get-ChildItem c:\Windows -Recurse -Exclude *.tmp | measure Length -Sum).sum / 1Gb)

# 9.	Сохранить в CSV-файле информацию о записях одной ветви реестра HKLM:\SOFTWARE\Microsoft.

Get-ChildItem HKLM:\SOFTWARE\Microsoft\ | Export-Csv k:\111.csv

# 10.	Сохранить в XML -файле историческую информацию о командах выполнявшихся в текущем сеансе работы PS.

Get-History | Export-Clixml k:\121.xml

# 11.	Загрузить данные из полученного в п.10 xml-файла и вывести в виде списка информацию о каждой записи, в виде 5 любых (выбранных Вами) свойств.

Import-Clixml k:\121.xml | Format-List ID, CommandLine ,ExecutionStatus, StartExecutionTime, EndExecutionTime

# 12.	Удалить созданный диск и папку С:\M2T2_ФАМИЛИЯ

Remove-PSDrive -force -Name K
Remove-Item E:\M2T2_SHISHKOVETS -Recurse -Force -Confirm:$false

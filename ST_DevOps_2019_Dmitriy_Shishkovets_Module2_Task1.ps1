#   1.	Получите справку о командлете справки

Get-Help Get-Help

#   2.	Пункт 1, но детальную справку, затем только примеры

Get-Help Get-Help -Detailed
Get-Help Get-Help -Examples

#   3.	Получите справку о новых возможностях в PowerShell 4.0 (или выше)

get-help -Name about_Windows_PowerShell_5.0

#   4.	Получите все командлеты установки значений

Get-Help -Category Cmdlet -Name Set* 

#   5.	Получить список команд работы с файлами

get-command -CommandType Cmdlet *item*

#   6.	Получить список команд работы с объектами

get-command -CommandType Cmdlet *object*

#   7.	Получите список всех псевдонимов

Get-Alias

#   8.	Создайте свой псевдоним для любого командлета

Set-Alias -name showdir -Value Get-ChildItem

#   9.	Просмотреть список методов и свойств объекта типа процесс

(Get-Process -ProcessName idle) | Get-Member

#   10.	Просмотреть список методов и свойств объекта типа строка

('asd') | Get-Member

#   11.	Получить список запущенных процессов, данные об определённом процессе

Get-Process
Get-Process -ProcessName idle

#   12.	Получить список всех сервисов, данные об определённом сервисе

Get-Service
Get-Service -name dhcp

#   13.	Получить список обновлений системы

Get-HotFix

#   14.	Узнайте, какой язык установлен для UI Windows

Get-WinSystemLocale

#   15.	Получите текущее время и дату

Get-Date

#   16.	Сгенерируйте случайное число (любым способом)

Get-Random -maximum 1000

#   17.	Выведите дату и время, когда был запущен процесс «explorer». Получите какой это день недели. 

$a = (Get-Process -Name Explorer).StartTime
$a
$a.DayOfWeek

#   18.	Откройте любой документ в MS Word (не важно как) и закройте его с помощью PowerShell

$filename='D:\test.doc' #предположим что файл существует по этому пути
$word = New-Object -ComObject Word.Application
$word.Visible = $True
$doc = $word.Documents.open($filename) #файл открываем
$doc.Close() #и сразу его закрываем. Ворд не гасим, т.к. там возможно открыты другие файлы.

#   19.	Подсчитать значение выражения S= . N – изменяемый параметр. Каждый шаг выводить в виде строки. (Пример: На шаге 2 сумма S равна 9)

Write-Host "Enter N"
$n = Read-Host
$s = 0
for ($i = 1; $i -le $n; $i++)
    {
        $s += ($i *3)
        Write-Host "On step" $i "amount of S is:" $s  
    }
Read-Host -Prompt "Press Enter to continue"

#   20.	Напишите функцию для предыдущего задания. Запустите её на выполнение.

function CountSteps ($n)
    {
       $s = 0
       for ($i = 1; $i -le $n; $i++)
        {
             $s += ($i *3)
             Write-Host "On step" $i "amount of S is:" $s   
        }
    }
CountSteps 6 #Вызов функции для 6 шагов.

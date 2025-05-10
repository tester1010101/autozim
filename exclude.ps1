#####################################################################
# Generate filters structure to exclude stuff from being crawled

Write-Host -ForegroundColor Magenta "#### :: #### [ STARTING ] #### :: ####"
Write-Host -ForegroundColor Magenta "#### :: #### [ Have you placed your AAAA.txt in CD\excludeLists folder? ] #### :: ####"
pause

$wFolder = (pwd).Path
Write-Host -ForegroundColor DarkMagenta "Current directory = [$wFolder]"
sleep 1


[bool]$pathBool = (Test-Path -Path "$wFolder\excludeLists\AAAA.txt")
if ($pathBool -eq $true)
{
    $collection = "$wFolder\excludeLists\AAAA.txt"
}
else
{
    mkdir $wFolder\excludeLists
    Write-Host -ForegroundColor Red "$wFolder\excludeLists\AAAA.txt NOT FOUND, exiting in 3..."
    sleep 1
    Write-Host -ForegroundColor Red "$wFolder\excludeLists\AAAA.txt NOT FOUND, exiting in 2..."
    sleep 1
    Write-Host -ForegroundColor Red "$wFolder\excludeLists\AAAA.txt NOT FOUND, exiting in 1..."
    sleep 1
    pause
    exit
}

sleep 1

$string = $null
$string2 = $null


[array]$excludeF = @("`$diF = @(`"--exclude=```"(`", ``")

foreach ($item in $collection)
{
    $string = "    `"$item`", ``"
    Write-Host $string
    [array]$excludeF += $string
}


$excludeF | out-file -encoding utf8 -filepath "$wFolder\excludeFilter_import.txt"
# [array]$excludeF += "    `"action=history`", ``"
#
#    $diF = @(
#    "https://www.gameye.app/encyclopedia/all?ps=100&p=1", `
#    "https://www.gameye.app/encyclopedia/all?ps=100&p=2", `
#    ...
#    "https://www.gameeye.app/other")
#
#
# iF = -> (^)

#############################################################################

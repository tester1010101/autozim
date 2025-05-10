################################
# Webpages Inclusion Generator #
# ---------------------------- #
#  Generates pages numbers to  #
# be crawled through according # # # # -> include page 1, 2, 3, 4, 5 ... 10. (add link-hops/include...)
#  to chosen webpages portion. #
# ---------------------------- #
# made by: tester1010101 (v01) #
# ---------------------------- #
#############################################################################
# TO-DO: choose url portion to modify/increment [https://page.with/complicated{$i}Links]
# .>> Choose URL portion (foreach $[index] in $pageStr_URL, choose $index to increment/generate)

<#

Write-Host -ForegroundColor Magenta "#### :: #### [ STARTING -> {1.} bookmarks conversion ] #### :: ####"

$wFolder = (pwd).Path
Write-Host -ForegroundColor DarkMagenta "Output directory = [$wFolder]"
sleep 1

$bookMarks = "$wFolder\excludeLists\AAAA.txt"
Write-Host -ForegroundColor DarkMagenta "Bookmark.file = [$bookMarks]"
sleep 1


$i = 0
$startNum = $i
$test1 = "https://github.com/tester1010101/p1/data"
$endNum = $test1.Length

do
{
    $test2 = $null
    $test2 = $test1[$i]
    Write-Host "$i. $test2"
    $i++
}
until ($i -eq $endNum)

Write-Host "Selexion? [$startNum >> $endNum]"
$selectVal = Read-Host

#>

$includeF = $null
$pageStr = $null
$wPage = $null

Write-Host "Page to increment? eg: [{https://www.google.com/results/}]"
[string]$pageStr = Read-Host

Write-Host "Start number (`$value)? [https://results.com/p/{`$value}] eg. {1}"
[int]$nbStar = Read-Host

Write-Host "Completion number (`$value)? [https://results.com/p/{`$value}] eg. {140}"
Write-Host "Generates pages from number X to Y. {page1 --> page 140}"
[string]$nbEnd = Read-Host

[array]$includeF = @("`$diF = @(`"--include=```"(`", ``")

do
{
    $wPage = "    `"$pageStr$nbStar`", ``"
    Write-Host $wPage
    [array]$includeF += $wPage
    $i++
}
until ($nbStar -eq $nbEnd)


$includeF | out-file -encoding utf8 -filepath "$wFolder\includeFilter_import.txt"
##################################################################################
#
#    $diF = @(--include=", `
#    "https://www.gameye.app/encyclopedia/all?ps=100&p=1", `
#    "https://www.gameye.app/encyclopedia/all?ps=100&p=2", `
#    ...
#    "https://www.gameeye.app/other")
#
#
# iF = -> (^)
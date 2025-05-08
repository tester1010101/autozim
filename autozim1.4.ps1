# 10101010101010101010101010101010101010101010 #
# ~<> Docker's Zimit Automated Script v0.1 <>~ #
#   > Thanks to OpenZim team for this tool <   # # # > Add auto-run/start-process for each request/step, keep files in between... (GAI)
#       https://github.com/tester1010101       #
# 10101010101010101010101010101010101010101010 #

############################################################# [ {0.} initialization ] ########################################################### [STATUS = OK]
# Asks user to start the program "Docker Desktop"

$stopwatch_global = [System.Diagnostics.Stopwatch]::StartNew()

$dockerPath = (where.exe docker.exe)

Write-Host -ForegroundColor Red ">>> IS DOCKER ENGINE STARTED? PROGRAM WILL FAIL @ LAUNCHING IMAGES IF NOT RUNNING."
$var123 = Read-Host

Write-Host -ForegroundColor Red ">>> ARE ZIMIT/CRAWLER IMAGES INSTALLED? PROGRAM WILL FAIL @ LAUNCHING IMAGES IF NOT DOWNLOADED."
$var123 = Read-Host

Write-Host -ForegroundColor Red ">>> EXIT NOW IF CHANGES NEED TO BE DONE & RESTART PROGRAM, DOCKER MUST BE IN PATH."
$var123 = pause

############################################################# [ {0.} user input ] ############################################################### [STATUS = OK]
# Configure script behavior

Write-Host -ForegroundColor Magenta "#### :: #### [ STARTING -> {1.} bookmarks conversion ] #### :: ####"

$wFolder = (pwd).Path
Write-Host -ForegroundColor DarkMagenta "Output directory = [$wFolder]"
sleep 1

$bookMarks = "$wFolder\bkm.txt"
Write-Host -ForegroundColor DarkMagenta "Bookmark.file = [$bookMarks]"
sleep 1

Write-Host -ForegroundColor Red "During the processes, IF ANY bookmark.zim fails to extract, clean storage unit? [Y/N]"
Write-Host -ForegroundColor Red "Y = CLEAN $item DIRECTORY/CACHES - !WARNING! - "
Write-Host -ForegroundColor Red "N = KEEP $item DIRECTORY/CACHES:DEBUGINFO"
$cleanCheck = "y"
# $cleanCheck = Read-Host

$BoolP0 = Test-Path $wFolder\bookn1.txt
if ($BoolP0 -eq $true)
{
    Write-Host -ForegroundColor Red "Detected namefiles from old instance, deleting..."
    Remove-Item $wFolder\bookn1.txt
}

$BoolP1 = Test-Path $wFolder\bookm2.txt
if ($BoolP1 -eq $true)
{
    Write-Host -ForegroundColor Red "Detected bookmarkfiles from old instance, deleting..."
    Remove-Item $wFolder\bookm2.txt
}

$BoolP2 = Test-Path $wFolder\folderTree.txt
if ($BoolP2 -eq $true)
{
    Write-Host -ForegroundColor Red "Detected treefiles from old instance, deleting..."
    Remove-Item $wFolder\folderTree.txt
}

$BoolP3 = Test-Path $wFolder\bs.txt
if ($BoolP3 -eq $true)
{
    Write-Host -ForegroundColor Red "Detected file from old instance, deleting..."
    Remove-Item $wFolder\bs.txt
}

$BoolP4 = Test-Path "$wFolder\# ZIM Files"
if ($BoolP4 -eq $false)
{
    Write-Host -ForegroundColor Red "Folder with ZIM files not found, creating..."
    New-Item -ItemType Directory "$wFolder\# ZIM Files"
}


############################################################# [ {1.} bookmarks conversion ] ##################################################### [STATUS = OK] (1. convert-bkm-https)
# Converts bkm.txt to usable commands 

Write-Host -ForegroundColor Yellow "########################################################################################################################"
Write-Host -ForegroundColor Yellow "# [page]     - crawl only this page and no additional links."
Write-Host -ForegroundColor Yellow "# [page-spa] - crawl only this page, but load any links that include different hashtags..."
Write-Host -ForegroundColor Yellow "#                  Useful for single-page apps that may load different content based on hashtag."
Write-Host -ForegroundColor Yellow "# [prefix]   - crawl any pages in the same directory, eg. starting from https://example.com/path/page.html, ..."
Write-Host -ForegroundColor Yellow "#                  Crawl anything under https://example.com/path/ (default)"
Write-Host -ForegroundColor Yellow "# [host]     - crawl pages that share the same host."
Write-Host -ForegroundColor Yellow "# [domain]   - crawl pages that share the same domain and subdomains, eg..." 
Write-Host -ForegroundColor Yellow "#                  Given https://example.com/ will also crawl https://anysubdomain.example.com/"
Write-Host -ForegroundColor Yellow "# [any]      - crawl any and all pages linked from this page.."
Write-Host -ForegroundColor Yellow "# [custom]   - crawl based on the --include regular expression rules."
Write-Host -ForegroundColor Yellow "########################################################################################################################"
Write-Host -ForegroundColor    Red "########################################################################################################################"
Write-Host -ForegroundColor    Red "# [ -> Caution with REDIRECTS & WIKI-EDIT SCRIPTS, CORRUPTS ALREADY ARCHIVED PAGES. SEE SCRIPT DETAILS #(v) <- "
Write-Host -ForegroundColor    Red "# -i example.com/(crawl-this|crawl-that|skip.*|) --> will only download what matches the regex"
Write-Host -ForegroundColor    Red "# -e example.com/(redirect|action=edit|) --> only excludes pages matching regex (overwrite/corruption/redirections)"
Write-Host -ForegroundColor    Red "# (/!\)CORRUTION(/!\). -i shouldn't be necessary (only includes match in scope) -> (build .txtfile/REGEX-pattern) <- ]"
Write-Host -ForegroundColor    Red "########################################################################################################################"

$scopeType1 = "prefix"
Write-Host -ForegroundColor DarkMagenta "Scope type = [prefix]"
sleep 1

$stopwatch_p1 = [System.Diagnostics.Stopwatch]::StartNew()

$collection = (Get-Content -Path "$bookMarks")
$i5 = 0
foreach ($item in $collection)
{
    Write-Host -ForegroundColor Green "Processing $item ..."
    $i5 = ($i5++)
    if ($item.Substring(0,5) -eq "https")
    {
        Write-Host -ForegroundColor Green "HTTPS path, setting variable." # starting search @ (9,1)
        $i = 8
        do
        {
            $itempos = $item.Substring($i,1)
            $i++
        }
        until ($itempos -eq "/")
        $itemname = $item.Substring(8,($i-9))
        $itemname2 = $itemname.replace(".","_")
        Write-Host -ForegroundColor Green "Website proceeded => $itemname"
        Write-Host -ForegroundColor Green "Fixed project name = $itemname2"
        $fullNames = "ITEM #$i5 = $itemname --> $itemname2 "
        $fullNames  | out-file -encoding utf8 $wFolder\bs.txt -Append
    }
    else
    {
        Write-Host -ForegroundColor Green "HTTP path, setting variable" # starting search @ (8,1)
        $i = 7
        do
        {
            $itempos = $item.Substring($i,1)
            $i++
        }
        until ($itempos -eq "/")
        $itemname = $item.Substring(7,($i-8))
        $itemname2 = $itemname.replace(".","_")
        Write-Host -ForegroundColor Green "Website proceeded => $itemname"
        Write-Host -ForegroundColor Green "Fixed project name = $itemname2"
        $fullNames = "ITEM #$i5 = $itemname --> $itemname2 "
        $fullNames  | out-file -encoding utf8 $wFolder\bs.txt -Append
    }

    $dexF = $null
    $dexFC = $null
    $dockerCMD = $null
    $dCMD = $null
    $dCM = $null

    $dexF = @("--exclude=`"(", `
                        "Special:UserProfileActivity|", `
                        "Special:RecentChangesLinked|", `
                        "Special:WhatLinksHere|", `
                        "Special:PrefixIndex|", `
                        "Special:ListFiles|", `
                        "Special:AbuseLog|", `
                        "Special:Log|", `
                        "action=edit|", `
                        ".com\/process|", `
                        "silver_surfer.html|", `
                        "index.html\?query|", `
                        "index.php\?title|", `
                        "User|", `
                        "talk:|", `
                        "User_blog|", `
                        "action=|", `
                        "\?diff|", `
                        "facebook.com|", `
                        "twitter.com|", `
                        "youtube.com|", `
                        "x.com|", `
                        "redirect=)`"")

    $dexFC = ($dexF -join "###########")
    $dexF = ($dexFC -replace "###########", "")

    $dCMD = @("run", `
                        "-v $wFolder\$itemname2`:/crawls", `
                        "--memory=`"1g`"", `
                        "--memory-swap=`"1g`"", `
                        "docker.io/webrecorder/browsertrix-crawler:1.3.5 crawl", `
                        "--name $itemname2", `
                        "--url $item", `
                        "--scopeType $scopeType1", `
                        "--depth -1", `
                        "--extrahops 1", `
                        "--timeout 10000", `
                        "--waitUntil load,networkidle2", `
                        "--postLoadDelay 2", `
                        "--pageExtraDelay 1", `
                        "--workers 6", `
                        "$dexF", `
                        " --keep ", `
                        "--verbose ", `
                        "--continue-on-error")

    $dCM = ($dCMD -join "###########")
    $dockerCMD = ($dCM -replace "###########", "")

############################################################# [ {2.} bookmarks2convert commands ] ############################################### [STATUS = OK] (2. convert-bkm2warcCMDs)
# Creates download Docker commands for every line/website (bkm.txt) to (bookm2.txt) - recover failed commands if necessary
# Append commands to text file in current directory then runs them

    Write-Host -ForegroundColor Magenta "#### :: #### [ IN PROGRESS -> {2.} exporting... [bookm2.txt] ] #### :: ####"


    $itemname2 | out-file -Encoding utf8 $wFolder\bookn1.txt -Append
    Write-Host -ForegroundColor Cyan "Exporting/appending command to textfile:[$dockerCMD]"
    
    $dockerCMD | out-file -Encoding utf8 $wFolder\bookm2.txt -Append
    $dockerCMD = $null
    $itempos = $null
    $itemname = $null
    $itemname2 = $null
}

Write-Host -ForegroundColor Yellow "#### :: #### [ :: PROJECTS TO CONVERT === ] #### :: ####"
$collection = (Get-Content -Path "$wFolder\bookn1.txt")

foreach ($item in $collection)
{
    Write-Host -ForegroundColor Yellow "#### :: #### [ :: |=|} $item"
}

Write-Host -ForegroundColor Yellow "#### :: #### [ :: | OUTPUT OK? | :: ] #### :: ####"
pause

$stopwatch_p1.Elapsed
$stopwatch_p1.Stop()
$curDateHigh = $null
$curDateHigh = (Get-Date)
Write-Host -ForegroundColor Green "[ $curDateHigh ] :: FINISHED - TIME STATS FOR BOOKMARKS CONVERSION :: [ OP FOLDER >> $wFolder ]"
Write-Host -ForegroundColor Green "Bookmarks converted to commands, now executing crawler foreach bookmark... (operations may take a while)"
$curDateHigh = $null

############################################################# [ {3.} Process-download commands ] ################################################ [STATUS = OK] (3. download-bkm2warc)
# Starts processing/downloading commands/websites, one by one, then will try to convert2zim before downloading next website.

Write-Host -ForegroundColor Magenta "#### :: #### [ STARTING -> {3.} webcrawler operations ] #### :: ####"

$stopwatch_p2 = [System.Diagnostics.Stopwatch]::StartNew()
$collection = $null
$item = $null

# Get-Content for all bookmarks/links in the bkm.txt
$collection = (Get-Content -Path "$wFolder\bookm2.txt")
$collectionCount = $collection.Length

# Get-Content for fixed names list output
$collectionName = (Get-Content -Path "$wFolder\bookn1.txt")

# Initialize variable position in namelist
[int]$i = "0"

# Starts processing each line
foreach ($item in $collection)
{
    $fixedcName = $null
    $fixedcName = $collectionName[$i]
    $stopwatch = $null
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $curDateLow = $null
    $curDateLow = (Get-Date)
    Write-Host -ForegroundColor Green "[ $curDateLow ] :: Processing website/webpages, running Docker crawler for CMD -> $item"
    Start-Process -NoNewWindow -Wait -FilePath $dockerPath -ArgumentList "$item"
    # Start-Process -NoNewWindow -FilePath $dockerPath -ArgumentList "run -v $wFolder\$item`:/output -v $inputPath`:/input ghcr.io/openzim/zimit:2.1.4 --warcs $WARCs --name $item --keep --continue-on-error"  # Process Docker cmd @ [$item]
    $curDateHigh = $null
    $curDateHigh = (Get-Date)
    Write-Host -ForegroundColor Green "[ $curDateHigh ] :: FINISHED - TIME STATS FOR $fixedcName :: [ OP FOLDER >> $wFolder ]"
    $curDateHigh = $null
    $curDateHigh = (Get-Date)
    $stopwatch.Elapsed
    Write-Host -ForegroundColor Green "[ $curDateHigh ] :: Archived in working folder..."
    $stopwatch.Stop()

############################################################# [ {4.} Post-download operations ] ################################################# [STATUS = OK] (4. mountconv2zimCMDs)
# Prepares WARCs cmdset to be ran  
  
    Write-Host -ForegroundColor Magenta "#### :: #### [ STARTING -> {4.} warc2zim extraction ] #### :: ####"

    Write-Host -ForegroundColor Green "[ $curDateLow ] :: Processing WARCs for project -> $fixedcName"

    $itemData = (ls -Directory "$wFolder\$fixedcName\collections").Name
    if (($itemData).Count -ge "2")
    {
        [bool]$RequiredBool = $false
        Write-Host -ForegroundColor Yellow "2+ crawl folders... building cmd..."
        $collection2 = (ls -Directory "$wFolder\$fixedcName\collections").Name
        $inputPath = "$wFolder\$fixedcName\collections"
        foreach ($item2 in $collection2)
        {
            Write-Host -ForegroundColor DarkGreen "$item2,$collection2"
            $WARCset = (ls "$wFolder\$fixedcName\collections\$item2\archive").Name
            $iPath = "/input/$item2/archive/"
            foreach ($item3 in $WARCset)
            {
                Write-Host -ForegroundColor Green "$iPath\$item3"
                $WARCfName += "$iPath$item3,"
            }
        }
        
        $varLength = ($WARCfName.Length-1)
        $WARCtfName = ($WARCfName.Substring(0,$varLength))
        $WARCs += $WARCtfName
        $WARCfName = $null
        $WARCtfName = $null
        $varLength = $null

        $cmdFixed = $null
        $cmdFixed = "run -v $wFolder\$fixedcName`:/output -v $inputPath`:/input --memory=`"1g`" --memory-swap=`"1g`" ghcr.io/openzim/zimit:2.1.4 zimit --warcs $WARCs --name $fixedcName --keep --continue-on-error"
        $cmdFixed | Out-File -Encoding UTF8 $wFolder\$fixedcName\conv2zim.txt -Append

        $i++
        $WARCs = $null
    }
    elseif(($itemData).Count -eq "0")
    {
        Write-Host -ForegroundColor Red ">>>>>>>>>>>>>>>>> Count = 0, skipping CMDmaker... Foldername = $fixedcName <<<<<<<<<<<<<<<<<<<<<"
        [bool]$RequiredBool = $true
        $cmdFixed = $null
        $i++
    }
    else
    {
        Write-Host "Count = 1"
        [bool]$RequiredBool = $false
        $inputPath = "$wFolder\$fixedcName\collections"
        $itemWARCrawlPath = (ls -Directory "$wFolder\$fixedcName\collections").Name
        $WARCPath = "$wFolder\$fixedcName\collections\$itemWARCrawlPath\archive"
        $WARCset = (ls $WARCPath).Name
        $iPath = "/input/$itemWARCrawlPath/archive/"
        foreach ($item2 in $WARCset)
        {
            Write-Host -ForegroundColor Green "$iPath\$item2"
            $WARCfName += "$iPath$item2,"
        }
        $varLength = ($WARCfName.Length-1)
        $WARCtfName = ($WARCfName.Substring(0,$varLength))

        $cmdFixed = $null
        $cmdFixed = "run -v $wFolder\$fixedcName`:/output -v $inputPath`:/input --memory=`"1g`" --memory-swap=`"1g`" ghcr.io/openzim/zimit:2.1.4 zimit --warcs $WARCtfName --name $fixedcName --keep --continue-on-error"
        $cmdFixed | Out-File -Encoding UTF8 $wFolder\$fixedcName\conv2zim.txt -Append

        $WARCfName = $null
        $varLength = $null
        $i++

############################################################# [ {5.} Start project conversion ] ################################################# [STATUS = OK] (5. conv2zim/postDL)
# Converts folder with WARCs to usable.zim

        if ($RequiredBool -eq $false)
        {
            $stopwatch_p5 = $null
            $stopwatch_p5 = [System.Diagnostics.Stopwatch]::StartNew()
            $curDateLow = $null
            $curDateLow = (Get-Date)
            Write-Host -ForegroundColor Green "[ $curDateLow ] :: Processing website/webpages and running warc2zim -> $fixedcName"
            Start-Process -NoNewWindow -Wait -FilePath $dockerPath -ArgumentList $cmdFixed
            # Start-Process -NoNewWindow -FilePath $dockerPath -ArgumentList "run -v $wFolder\$item`:/output -v $inputPath`:/input ghcr.io/openzim/zimit:2.1.4 zimit --warcs $WARCs --name $item --keep --continue-on-error"  # Process Docker cmd @ [$item]
            $curDateHigh = $null
            $curDateHigh = (Get-Date)
            Write-Host -ForegroundColor Green "[ $curDateHigh ] :: FINISHED - TIME STATS FOR $fixedcName :: [ OP FOLDER >> $wFolder ]"
            $curDateHigh = $null
            $curDateHigh = (Get-Date)
            $stopwatch_p5.Elapsed
            Write-Host -ForegroundColor Green "[ $curDateHigh ] :: { $fixedcName.zim } ~ Archived in output folder defined earlier, moving 2NXT website..."
            $stopwatch_p5.Stop()

            Write-Host -ForegroundColor Magenta "#### :: #### [ STARTING -> {5.} warc2zim conversion ] #### :: ####"
            $stopwatch_p4 = [System.Diagnostics.Stopwatch]::StartNew()
        }
        elseif ($RequiredBool -eq $true)
        {
            # passively-continue if nothing to convert
            Write-Host -ForegroundColor Green "[ Empty folder @ $fixedcName, moving to next website... ]"
        }
    
        $cmdFixed = $null
        $WARCfName = $null
        $WARCtfName = $null
    }

    $itemData = $null

    ########################################################## [ {6.} Cleanup section ] ######################################################### [STATUS = OK] (6. cleanup-session)
    # Cleanup current session data once extracted to .zim

    [bool]$zimConf = (Test-Path -Path "$wFolder\$fixedcName\$fixedcName.zim")
    if ($zimConf -eq $true)
    {
        Write-Host -ForegroundColor Green "$fixedcName.zim successfully extracted, cleaning storage unit..."
        # Cleaning commands ################ prune/wslpurge
    }
    elseif ($zimConf -eq $false) 
    {

        if ($cleanCheck -eq "Y")
        {
            $curLDate = $null
            $curLDate = (Get-Date -Format yyyy-MM)
            $zimSize = $null
            $BoolP4 = $null
            $BoolP5 = $null
            $BoolP4 = (Test-Path -Path "$wFolder\$fixedcName\$fixedcName`_$curLDate.zim")
            $zimSize = ((ls "$wFolder\$fixedcName\$fixedcName`_$curLDate.zim").Length)
            Write-Host -ForegroundColor Magenta "$wFolder\$fixedcName\$fixedcName`_$curLDate.zim"
            Write-Host -ForegroundColor Magenta "$zimSize"
            if ($BoolP4 -eq $true)
            {
                if ($zimSize -gt "4")
                {
                    $BoolP5 = (Test-Path -Path "$wFolder\# ZIM Files\$fixedcName`_$curLDate.zim")
                    if ($BoolP5 -eq $true)
                    {
                        Move-Item "$wFolder\$fixedcName\$fixedcName`_$curLDate.zim" "$wFolder\# ZIM Files\$fixedcName`_$curLDate`_UPDATED.zim"
                    } else {
                        Move-Item "$wFolder\$fixedcName\$fixedcName`_$curLDate.zim" "$wFolder\# ZIM Files\$fixedcName`_$curLDate.zim"
                    }
                    
                    $movedBool = (Test-Path -Path "$wFolder\# ZIM Files\$fixedcName`_$curLDate.zim")
                    if ($movedBool -eq $true)
                    {
                        Write-Host -ForegroundColor Magenta "Successfully moved $fixedcName`_$curLDate.zim to ZIM folder, deleting caches..."
                        Start-Process -NoNewWindow -Wait -FilePath $dockerPath -ArgumentList "system prune -f"
                        Remove-Item -Path $wFolder\$fixedcName -Recurse -Force
                        $delBool = (Test-Path -Path "$wFolder\$fixedcName")

                        if ($delBool -eq $false)
                        {
                            Write-Host -ForegroundColor Magenta "Folder deleted, moving to next project..."
                        }
                        else {
                            $BoolP6 = (Test-Path -Path "$wFolder\# ZIM Files\$fixedcName`_$curLDate`_UPDATED.zim")
                            if ($BoolP6 -eq $true)
                            {
                                Write-Host -ForegroundColor Magenta "Successfully moved $fixedcName`_$curLDate`_UPDATED.zim to ZIM folder, deleting caches..."
                            } else {
                                Write-Host -ForegroundColor Red "Project not deleted, keeping caches and moving to next project (mainFolderDeleteFail)"
                            }
                        }
                    }
                } 
                else {
                    Write-Host -ForegroundColor Red "Project too small or failed, keeping caches and moving to next project (zimSize/moveFail)"
                }
            }
            else {
                    Write-Host -ForegroundColor Red "Project too small or failed, keeping caches and moving to next project (zimNotFound)"
            }

            # del *itemname2*
            # wsl --shutdown/restart --> might be better to prune + optimize disk (v)
            # Optimize-VHD -Path "${Env:LocalAppData}\Docker\wsl\disk\<<whatevername>>.vhdx" -Mode Full 
            # del --> AppData\Local\Docker\wsl\data*
            # del --> AppData\Local\Temp

        }
        elseif ($cleanCheck -eq "N")
        {
            Write-Host -ForegroundColor Red "keeping caches and moving to next project"
        }
        else
        {
            Write-Host -ForegroundColor Red "Wrong input, keeping caches and moving to next project"
        }
    }
}

############################################################# [ {7.} Process-download statistics ] ############################################## [STATUS = OK] (7. PostDL-stats)
# Final stats on total script behavior

$curDateHigh = $null
$curDateHigh = (Get-Date)
Write-Host -ForegroundColor Green "[ $curDateHigh ] :: SUCCESS - ALL TASKS ENDED/$collectionCount PROJECT(S) COMPLETED! - SEE TERMINAL/DOCKER LOGS FOR DETAILS - GLOBAL TIME STATS :: [ -> ]"
$stopwatch_global.Elapsed
$stopwatch_global.Stop()
sleep 1
$curDateHigh = $null
Write-Host -ForegroundColor Green "Each successfully converted .zim is located in .<working-outputFolder>/projectname/projectname.zim"
Write-Host -ForegroundColor Red "PROGRAM WILL EXIT, PRESS ENTER TO OPEN OUTPUT FOLDER >>"
pause
explorer $wFolder

$stopwatch_global = $null
$dockerPath = $null
$var123 = $null
$bookMarks = $null
$wFolder = $null
$scopeType1 = $null
$collection = $null
$item = $null
$i = $null
$i2 = $null
$itempos = $null
$itemname = $null
$itemname2 = $null
$dockerCMD = $null
$curDateHigh = $null
$stopwatch = $null
$stopwatch_p1 = $null
$stopwatch_p2 = $null
$stopwatch_p3 = $null
$stopwatch_p4 = $null
$stopwatch_p5 = $null
$curDateLow = $null
$stopwatch_p3 = $null
$collectionCount = $null
$collectionName = $null
$itemData = $null
$collection2 = $null
$inputPath = $null
$item2 = $null
$WARCset = $null
$iPath = $null
$item3 = $null
$WARCfName = $null
$varLength = $null
$WARCtfName = $null
$varLength = $null
$WARCtfName = $null
$WARCs = $null
$cmdFixed = $null
$itemWARCrawlPath = $null
$WARCPath = $null
$BoolP0 = $null
$BoolP1 = $null
$BoolP2 = $null
$cleanCheck = $null
$fixedcName = $null
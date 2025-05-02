# 10101010101010101010101010101010101010101010 #
# ~<> Docker's Zimit Automated Script v1.2 <>~ #
#   > Thanks to OpenZim team for this tool <   # # # > Add auto-run/start-process for each request/step, keep files in between...
#       https://github.com/tester1010101       #
# 10101010101010101010101010101010101010101010 #

$dockerPath = (where.exe docker.exe)

Write-Host -ForegroundColor Magenta "#### :: #### [ STARTING -> {1.} user input ] #### :: ####"
Write-Host -ForegroundColor Red ">>> WARNING --> WILL DELETE BOOKMARK/NAME TEXTFILES, DO NOT CONTINUE & EXIT/BACKUP NOW IF NEEDED!"
$var123 = pause

############################################################# [ {1.} user input ] ############################################################### [STATUS = OK]

$wFolder = (pwd).Path
Write-Host -ForegroundColor DarkMagenta "Output directory = [$wFolder]"
sleep 1

# Get-Content for fixed names list output
$collection = (Get-ChildItem -Directory -Path "$wFolder" | Where-Object name -match "_").Name
$collectionCount = $collection.Count
$collectionName = $collection

Write-Host -ForegroundColor Yellow "collection = $collection"
Write-Host -ForegroundColor Yellow "collectionName = $collectionName"
Write-Host -ForegroundColor Yellow "Folder names OK?"

Write-Host -ForegroundColor Red ">>> WARNING --> WILL DELETE BOOKMARK/NAME TEXTFILES, DO NOT CONTINUE & EXIT/BACKUP NOW IF NEEDED!"
$var123 = pause

############################################################# [ {2.} warc2zim enumeration ] ############################################################### [STATUS = OK]

# Initialize variable position in namelist
[int]$i = "0"

# Starts processing each folder
foreach ($item in $collection)
{
    $fixedcName = $null
    $fixedcName = $collectionName[$i]
    $stopwatch = $null
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

# Prepares WARCs cmdset to be ran    
    Write-Host -ForegroundColor Magenta "#### :: #### [ STARTING -> {2.} warc2zim enumeration ] #### :: ####"

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
        $cmdFixed = "run -v $wFolder\$fixedcName`:/output -v $inputPath`:/input ghcr.io/openzim/zimit:2.1.4 zimit --warcs $WARCs --name $fixedcName --keep --continue-on-error"
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
        $cmdFixed = "run -v $wFolder\$fixedcName`:/output -v $inputPath`:/input ghcr.io/openzim/zimit:2.1.4 zimit --warcs $WARCtfName --name $fixedcName --keep --continue-on-error"
        $cmdFixed | Out-File -Encoding UTF8 $wFolder\$fixedcName\conv2zim.txt -Append

        $WARCfName = $null
        $varLength = $null
        $i++

        ###############################################
        # convertFolder2zim
        ##################################################### [ {3.} warc2zim conversion ] ################################################# [STATUS = OK] (5. conv2zim/postDL)

        if ($RequiredBool -eq $false)
        {
            $stopwatch_p5 = $null
            $stopwatch_p5 = [System.Diagnostics.Stopwatch]::StartNew()
            $curDateLow = $null
            $curDateLow = (Get-Date)
            Write-Host -ForegroundColor Magenta "#### :: #### [ STARTING -> {3.} warc2zim conversion ] #### :: ####"
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

    ########################################################## [ {4.} Cleanup section ] ######################################################### [STATUS = OK] (6. cleanup-session)
    # Cleanup current session data once extracted to .zim
    # 
    $cleanCheck = "Y"
    [bool]$zimConf = (Test-Path -Path "$wFolder\$fixedcName\$fixedcName.zim")
    if ($zimConf -eq $true)
    {
        Write-Host -ForegroundColor Green "$fixedcName.zim successfully converted/extracted, cleaning storage unit..."
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
            # 

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

############################################################# [ {5.} Process-download statistics ] ############################################## [STATUS = OK] (7. PostDL-stats)

$curDateHigh = $null
$curDateHigh = (Get-Date)
Write-Host -ForegroundColor Green "[ $curDateHigh ] :: SUCCESS - ALL TASKS ENDED/$collectionCount PROJECT(S) COMPLETED! - SEE TERMINAL/DOCKER LOGS FOR DETAILS - GLOBAL TIME STATS :: [ -> ]"
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
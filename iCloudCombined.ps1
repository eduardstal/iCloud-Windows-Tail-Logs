$folderPath = "C:\Users\{User}\AppData\Local\Packages\{iCloud Package Name}\LocalCache\Local\Logs"
$globPattern = "iCloud*.**.log"
$maxFileAgeHours = 1
$pathRegex = '(?<![^\s])[A-Za-z]:\\(?:[^\\/:*?"<>|\r\n]+\\)*[^\\/:*?"<>|\r\n]*'

function Monitor-Files {
    param (
        [string]$path,
        [string]$pattern,
        [int]$maxAgeHours
    )

    $files = Get-ChildItem -Path $path -Filter $pattern | Where-Object { (Get-Date) - $_.LastWriteTime -le (New-TimeSpan -Hours $maxAgeHours) }
    $fileReaders = @()

    foreach ($file in $files) {
        try {
            $fileStream = [System.IO.FileStream]::new($file.FullName, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
            $reader = [System.IO.StreamReader]::new($fileStream)
            $fileReaders += $reader
        } catch {
            Write-Host "Error opening $($file.Name): $($_.Exception.Message)"
        }
    }

    try {
        while ($true) {
            for ($i = 0; $i -lt $fileReaders.Count; $i++) {
                while ($null -ne ($line = $fileReaders[$i].ReadLine())) {
                    $fileName = ($files[$i].Name).PadRight(30)
                    
                    if ($line -match "ERROR") {
                        $foregroundColor = "Red"
                    } elseif ($line -match "WARN") {
                        $foregroundColor = "Yellow"
                    } else {
                        $foregroundColor = "Green"
                    }

                    $formattedLine = $line -replace $pathRegex, { Write-Host -NoNewline -ForegroundColor Blue $_.Value; $_.Value }
                    Write-Host -NoNewline -ForegroundColor $foregroundColor $fileName
                    Write-Host $formattedLine
                }
            }
            Start-Sleep -Milliseconds 500
        }
    }
    finally {
        foreach ($reader in $fileReaders) {
            $reader.Close()
        }
    }
}

Monitor-Files -path $folderPath -pattern $globPattern -maxAgeHours $maxFileAgeHours

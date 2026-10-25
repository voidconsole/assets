param(
    [string]$TodoFile
)

$lines = Get-Content -Path $TodoFile
$output = @()
$seenLegacyImage = $false

foreach ($line in $lines) {
    # Relaxed regex: Looks for "pick", a hash, and "Upload image [any number].png" anywhere in the subject
    if ($line -match '^(pick|p)\s+([0-9a-f]+)\s+.*Upload image \d+\.png.*') {
        $hash = $Matches[2]
        
        if (-not $seenLegacyImage) {
            # 1. Keep the first image commit
            $output += "pick $hash"
            
            # 2. Immediately inject a command to rename it without opening an editor
            $output += 'exec git commit --amend -m "Uploaded legacy images"'
            
            $seenLegacyImage = $true
        } else {
            # 3. Squash all subsequent image commits into the first one
            $output += "fixup $hash"
        }
    }
    else {
        # Keep all other commits exactly as they are
        $output += $line
    }
}

# Write back to the file using clean UTF-8
[System.IO.File]::WriteAllLines(
    $TodoFile, 
    $output, 
    (New-Object System.Text.UTF8Encoding($false))
)
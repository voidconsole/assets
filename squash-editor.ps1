param(
    [string]$TodoFile
)

$lines = Get-Content -LiteralPath $TodoFile

$previousSubject = $null

$output = foreach ($line in $lines) {

    if ($line -match '^pick ([0-9a-f]+) (.+)$') {

        $hash = $Matches[1]
        $subject = $Matches[2]

        if ($subject -eq $previousSubject) {
            "fixup $hash $subject"
        }
        else {
            $line
        }

        $previousSubject = $subject
    }
    else {
        $line
    }
}

[System.IO.File]::WriteAllLines(
    $TodoFile,
    $output,
    (New-Object System.Text.UTF8Encoding($false))
)
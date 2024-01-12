oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\emodipt-extend.omp.json" | Invoke-Expression

function ctr {
    param(
        [string]$name,
        [switch]$verbose
    )
    $command="cargo test --release '$name'"
    if ($verbose) {
        $command += " --", "--nocapture"
    }
    Invoke-Expression $command
}

function cre {
    param(
        [string]$name,
        [string]$other
    )
    $command="cargo run --example '$name' --release '$other'"
    Invoke-Expression $command
}

function Write-Color([String[]]$Text, [ConsoleColor[]]$Color = "White", [int]$StartTab = 0, [int] $LinesBefore = 0,[int] $LinesAfter = 0, [string] $LogFile = "", $TimeFormat = "yyyy-MM-dd HH:mm:ss") {
    $DefaultColor = $Color[0]
    if ($LinesBefore -ne 0) { for ($i = 0; $i -lt $LinesBefore; $i++) { Write-Host "`n" -NoNewline } } # Add empty line before
    if ($StartTab -ne 0) { for ($i = 0; $i -lt $StartTab; $i++) { Write-Host "`t" -NoNewLine } } # Add TABS before text
    if ($Color.Count -ge $Text.Count) {
        for ($i = 0; $i -lt $Text.Length; $i++) { Write-Host $Text[$i] -ForegroundColor $Color[$i] -NoNewLine }
    } else {
        for ($i = 0; $i -lt $Color.Length ; $i++) { Write-Host $Text[$i] -ForegroundColor $Color[$i] -NoNewLine }
        for ($i = $Color.Length; $i -lt $Text.Length; $i++) { Write-Host $Text[$i] -ForegroundColor $DefaultColor -NoNewLine }
    }
    Write-Host
        if ($LinesAfter -ne 0) { for ($i = 0; $i -lt $LinesAfter; $i++) { Write-Host "`n" } } # Add empty line after
        if ($LogFile -ne "") {
            $TextToFile = ""
            for ($i = 0; $i -lt $Text.Length; $i++) {
                $TextToFile += $Text[$i]
            }
            Write-Output "[$([datetime]::Now.ToString($TimeFormat))]$TextToFile" | Out-File $LogFile -Encoding unicode -Append
        }
}

function gitH {
    Write-Color -Text "Command ", "Argument ", "Description" -Color Green,Blue,White
    Write-Color -Text "gitcm ", "commit:String", " [git commit -m <commit>]" -Color Green,Blue,White
    Write-Color -Text "gitacm ", "commit:String", " [git add -A && git commit -m <commit>]" -Color Green,Blue,White
    Write-Color -Text "gitck ", "branch:String" , " Option[-b]", " [git checkout [-b] <branch>]" -Color Green,Blue,Blue,White
    Write-Color -Text "gitpo ", "remote:String", " branch:String", " [git push -u <remote> <branch>]" -Color Green,Blue,Blue,White
    Write-Color -Text "gitcmc ", "commit:String", " [git commit --amend -m <new_commit>]" -Color Green,Blue,White
}

function gitcm {
    param(
        [string]$commit
    )
    $command="git commit -m '$commit'"
    Invoke-Expression $command
}

function gitacm {
    param(
        [string]$commit
    )
    $command="git add -A && git commit -m '$commit'"
    Invoke-Expression $command
}

function gitck {
    param(
        [string]$branch,
        [switch]$b_new
    )
    $command="git checkout"
    if ($b_new) {
        $command += " -b"
    }
    $command += " '$branch'"
    Invoke-Expression $command
}

function gitpo {
    param(
        [string]$remote,
        [string]$branch
    )
    $command = "git push -u '$remote' '$branch'"
    Invoke-Expression $command
}

function gitcmc {
    param(
        [string]$new_commit
    )
    $command="git commit --amend -m '$new_commit'"
    Invoke-Expression $command
}

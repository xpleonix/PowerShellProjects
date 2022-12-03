
# Pseudo code
# 1. Load english words (5 letters)
# 2. Pick a random word
# 3. Ask player to guess word
# 4. Check if word is valid (English & 5 letters long)
# 5. Check the letters to make sure they are in the right place
# 6. Highlight proper letters (Correct position or in the word)
# 7. Repeat 3 -> 6 until word is correct or too many guesses (6)
# Word.txt was downloaded from here: https://github.com/dwyl/english-words
# based on CarolineChiari's project

#Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass


#$pathToWords = "C:\_main\_projects\wordle"  
$pathToWords = "."
$WordLength = 5


function Get-Characters {
    param (
        [Parameter(Mandatory=$true)]
        [string]
        $Word
    )
    $result = @()
    for ($i=0; $i -lt $Word.Length; $i++) {
        $result += $word.Substring($i, 1)   # result: "string" --> @("s","t","i","n","g")

    }
    return $result
}


# 1. Load english words (5 letters)
$words = Get-Content "$pathToWords/words.txt" | Where-Object {$_.length -eq $WordLength -and $_ -cmatch "^[a-z]{$WordLength}"}  
#$words[0..10]

# 2. Pick a random word
$WordToGuess = $words[(Get-Random -minimum 0 -maximum $words.Count)]
$WordToGuessChars = Get-Characters -Word $WordToGuess
# see the word
#Write-Host $WordToGuess

$guesses = 1
$CorrectGuess = $false
$IncorrectLetters = @()

do {

    # 3. Ask player to guess word
    $guessPrompt = "$guesses Guess the word"
    $guess = Read-Host -Prompt $guessPrompt

    # 4. Check if word is valid (English & 5 letters long)
    if ($guess.Length -eq $WordLength -and $words -contains $guess) {
        $guesses++
        if ($guess -eq $WordToGuess) {
            $CorrectGuess = $true
        }
        $guessChars = Get-Characters -Word $guess

        # 5. Check the letters to make sure they are in the right place
        for ($i=0; $i -lt $guessChars.Count; $i++) {
            $letter = $guessChars[$i]
            if ($WordToGuessChars -contains $letter) {
                $CorrectPlace = $false
                if ($WordToGuessChars[$i] -eq $letter) {
                    $CorrectPlace = $true
                }
                # 6. Highlight proper letters (Correct position or in the word)
                $Host.UI.RawUI.CursorPosition = @{
                    X=$guessPrompt.Length +2 +$i
                    Y=$Host.UI.RawUI.CursorPosition.Y - 1 
                }
                $color = "Yellow"
                if ($CorrectPlace) {
                    $color = "Green"
                }
                Write-Host $letter -BackgroundColor $color
            } else {
                $IncorrectLetters += $letter
            }

        }
        $Host.UI.RawUI.CursorPosition = @{
            X=$guessPrompt.Length +2 +$WordLength + 5
            Y=$Host.UI.RawUI.CursorPosition.Y - 1 
        }
        Write-Host "Bad letters: " -ForegroundColor "red" -NoNewline
        $IncorrectLetters = $IncorrectLetters | Sort-Object -Unique
        foreach ($letter in $IncorrectLetters) {
            Write-Host $letter -NoNewline
        }
        Write-Host ""
    }

# 7. Repeat 3 -> 6 until word is correct or too many guesses (6)

} while (($guesses -le 6) -and (-not $CorrectGuess))
if ($CorrectGuess) {
    Write-Host "Good job!" -ForegroundColor "Green"
} else {
    Write-Host "Better luck next time..." -ForegroundColor "Blue"
}


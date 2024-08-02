# Define the path to the CSV file and log file
$csvPath = "H:\DATA\AXXIA_DOCS\IT Temp\updated_doclist.csv"
$logPath = "H:\DATA\AXXIA_DOCS\IT Temp\move_files_log.txt"

# Create or clear the log file
New-Item -Path $logPath -ItemType File -Force

# Function to write messages to the log file
function Write-Log {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    Add-Content -Path $logPath -Value $logMessage
}

# Import the CSV file
$data = Import-Csv -Path $csvPath

# Loop through each row in the CSV
foreach ($row in $data) {
    # Get the original path and new path
    $originalPath = $row.original_path
    $newPath = $row.new_path

    # Get the directory for the new path
    $newDirectory = [System.IO.Path]::GetDirectoryName($newPath)

    # Create the new directory if it doesn't exist
    if (-not (Test-Path -Path $newDirectory)) {
        New-Item -ItemType Directory -Path $newDirectory
        Write-Log "Created directory: $newDirectory"
    }

    # Move the file to the new path
    if (Test-Path -Path $originalPath) {
        Move-Item -Path $originalPath -Destination $newPath
        Write-Log "Moved: $originalPath to $newPath"
    } else {
        Write-Log "File not found: $originalPath"
    }
}

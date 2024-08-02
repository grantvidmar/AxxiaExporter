# Specify the CSV file path
$csvPath = "H:\DATA\AXXIA_DOCS\IT Temp\doclist.csv"

# Specify the destination folder for copied files
$destinationFolder = "H:\DATA\AXXIA_DOCS\IT Temp\Axxia Export"

# Specify the log file path
$logFilePath = Join-Path -Path $destinationFolder -ChildPath "CopyLog.txt"

# Read the CSV file
$files = Import-Csv $csvPath

# Initialize a log array
$log = @()

# Loop through each row in the CSV
foreach ($file in $files) {
    try {
        # Get the original location and new name from the CSV
        $sourcePath = $file.document_path
        $newFileName = $file.title

        # Construct the destination path
        $destinationPath = Join-Path -Path $destinationFolder -ChildPath $newFileName

        # Create the destination directory if it doesn't exist
        $destinationDir = Split-Path -Path $destinationPath
        if (-not (Test-Path -Path $destinationDir)) {
            New-Item -ItemType Directory -Path $destinationDir | Out-Null
        }

        # Copy the file
        Copy-Item -Path $sourcePath -Destination $destinationPath -Force

        # Display progress on screen
        Write-Host "Copied '$sourcePath' to '$destinationPath'"

        # Add a log entry
        $logEntry = "Copied '$sourcePath' to '$destinationPath'"
        $log += $logEntry
    }
    catch {
        # Handle any errors (e.g., file not found, permission issues)
        $logEntry = "Error copying '$sourcePath': $_"
        $log += $logEntry
    }
}

# Write the log to the log file
$log | Out-File -FilePath $logFilePath -Append

Write-Host "Files copied and log written to $logFilePath"

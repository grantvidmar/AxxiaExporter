# Read data from the first column of the CSV file (adjust the path accordingly)
$csvData = Import-Csv -Path "H:\DATA\AXXIA_DOCS\IT Temp\axxiasearch.csv"

# Specify the search directory
$searchDirectory = "H:\DATA\AXXIA_DOCS\PERI\Work"

# Define the log file path
$logFilePath = Join-Path -Path $PSScriptRoot -ChildPath "searchlog.txt"

# Create or append to the log file
"Search started at $(Get-Date)" | Out-File -FilePath $logFilePath -Append

# Initialize an empty array to store the "matter" column data
$matterColumnData = @()

# Exclude folder path
$excludedFolder = "H:\DATA\AXXIA_DOCS\PERI\Work\ALM0002\01517880"

# Iterate through each row in the CSV
foreach ($row in $csvData) {
    # Get the value from the "matter" column (assuming it's the first property in the row)
    $matterValue = $row.matter
    Write-Host "Searching for matter: $matterValue in folder: $searchDirectory"

    # Exclude the specific folder
    if ($matterValue -ne $excludedFolder) {
        # Search for both files and folders matching the matter value
        $foundItems = Get-ChildItem -Path $searchDirectory -Filter "*$matterValue*" -Recurse

        if ($foundItems.Count -eq 0) {
            # If not found, add a "NOT FOUND" entry
            Write-Host "Matter: $matterValue - NOT FOUND"
            "Matter: $matterValue, Path(s): NOT FOUND" | Out-File -FilePath $logFilePath -Append
        } else {
            # If found, add all matching items (files and folders)
            $resultPaths = $foundItems | Select-Object -ExpandProperty FullName
            Write-Host "Matter: $matterValue - Found at: $($resultPaths -join ', ')"

            # Log the search results to the CSV file
            $resultPaths | ForEach-Object {
                [PSCustomObject]@{
                    Matter = $matterValue
                    Path = $_
                }
            } | Export-Csv -Path "H:\DATA\AXXIA_DOCS\IT Temp\search_results.csv" -Append -NoTypeInformation
        }
    }
}

# Log completion message
"Search completed at $(Get-Date)" | Out-File -FilePath $logFilePath -Append
Write-Host "Search completed. Log written to searchlog.txt. Results exported to search_results.csv."

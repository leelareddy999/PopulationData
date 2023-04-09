# Set to $true to see the debug related print statements on console
$debugMode = $false

# Function to get prime factors
function Get-PrimeFactors {
    param([int]$number)
    $primeFactors = @()
    $divisor = 2
    while ($number -gt 1) {
        if ($number % $divisor -eq 0) {
            $primeFactors += $divisor
            $number = $number / $divisor
        } else {
            $divisor++
        }
    }
    return $primeFactors -join ';'
}



# Fetch data from API
$apiUrl = "https://datausa.io/api/data?drilldowns=State&measures=Population"
$response = Invoke-WebRequest -Uri $apiUrl
$data = ($response.Content | ConvertFrom-Json).data

# Prepare CSV data
$csvData = @()
$csvData += "State Name,2013,2014,2015,2016,2017,2018,2019,2020,2020 Factors"

foreach ($state in ($data | Group-Object -Property State)) {

    $stateName = $state.Name
    $sortedData = $state.Group | Sort-Object -Property Year
    $populations = @{}
    $populationChanges = @{}

    $csvRow = $stateName
    foreach ($record in $state.Group) {
        $year = $record.Year
        $population = $record.Population
        if ($debugMode) {
            Write-Host "............next elemsn........"
        }

        $populations[$year] = $population
        if ($debugMode) {
            Write-Host $year, "-------", $population, ".......", $populations[$year]
        }
    }

    $previousPop = 0
    $sortedPopulations = $populations.GetEnumerator() | Sort-Object { $_.Key }
    foreach ($entry in $sortedPopulations) { 
        $track = $entry.Key
        $pop = $entry.Value
            
        if ($track -ge 2014) {
            $change = $pop - $previousPop
            if ($debugMode) {
                Write-Host $track +"/////" + $change +"......." + $pop
            }
            $percentChange = ($change / $previousPop) * 100
            $csvRow += "," + $pop + "  ($('{0:N2}' -f $percentChange)%)"
        } else {
            $csvRow += "," + $pop
        }
        $previousPop = $pop    
    }    
    $primeFactors = Get-PrimeFactors -number $pop
    $csvRow += "," + $primeFactors
    Write-Host $csvRow

    # Fix for empty year values
    $csvRow = $csvRow -replace ',,+', ','
    $csvData += $csvRow
}

# Save CSV
$csvData | Out-File -FilePath "PopulationData.csv"

### Powershell Script Explanation   

1. Function Get-PrimeFactors to find the prime factors of a given number. It takes an integer as a parameter, then iterates through possible divisors, adding them to an array if they are prime factors. It returns the prime factors as a semicolon-separated string.   

1. Fetch population data for US states from the datausa.io API. It sends a request to the specified URL and converts the response content from JSON format to a PowerShell object.   

1. Prepare CSV data with a header row containing the column names, such as "State Name," "2013," "2014," etc., and an additional column "2020 Factors" for the prime factors of the 2020 population.   

1. Process the fetched data by grouping it by state, sorting it by year, and calculating the percentage change in population for each year starting from 2014.   

1. Construct a CSV row for each state, including the state name, population values, percentage changes, and the prime factors of the 2020 population.   

1. Fix potential issues with empty year values in the CSV row by replacing consecutive commas with a single comma.   

1. Save the processed data to a CSV file called "PopulationData.csv."   

1. The script also has a $debugMode variable that, when set to $true, will display debugging information in the console to help understand the script's progress and data handling.   
#####################################################################
#####################################################################
##                                                                 ##
##                                                                 ##
##  BIOSCheck v0.1                                                 ##
##                                                                 ##
##  Get a JSON file and check if current version matches data      ##
##                                                                 ##
##                                                                 ##
##  DOES NOT CHECK MANUFACTURER WEBSITE                            ##
##                                                                 ##
#####################################################################
#####################################################################

# This should be a simple Key:Value JSON file
$JSON_URL = "https://gist.githubusercontent.com/WinSCaP/58b13c6806f51d4de92c9035a2b7234f/raw/806bd6dccab289e3b8db95b473cb42823b39f102/machines.json"
# Using RestMothod you get a PSObject of parsed JSON
$jsondata=Invoke-RestMethod -Uri $JSON_URL -Method GET

# Retreive information about current system. Retreive Manufacturer, Model and BIOS Version from WMI
$system_info = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -Property Manufacturer, Model
$system_model = $system_info.manufacturer + " " + $system_info.model
$system_current_BIOS_version = (Get-CimInstance -ClassName Win32_BIOS).SMBIOSBIOSVersion


# Check is Manufacturer and Model are available in JSON
if(Get-Member -inputobject $jsondata -name $system_model -Membertype Properties){
  
  # Get the latest BIOS version from JSON
  $latest_version = $jsondata.$system_model
  echo "Latest BIOS Version: $latest_version"
  Echo "Current BIOS Version: $system_current_BIOS_version"
  
  # Check if we are running the most recent BIOS
  if ($system_current_BIOS_version -eq $latest_version) {
    Echo "Everything is fine :)"
  } else {
    echo "Time to Update!"
  }
} else {

  # This model was not found in the JSON
  echo "The current system: $system_model is not supported"
}

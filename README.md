# iCloud-Windows-Tail-Logs
Simple PowerShell iCloud for Windows Log Tail

This PowerShell script monitors and displays the content of log files in a specified folder that match a given filename pattern and have been modified within the last 4 hours. It continuously reads new lines in real-time and displays them in the terminal with green text. If a line contains the word "ERROR", the script displays that line in red text, making it easier to identify errors in the log files.

## Usage
Save the script as LogFileMonitor.ps1 in your desired location.
Open a PowerShell terminal and navigate to the location where you saved the script.
Run the script with the following command:
```
.\iCloudCombined.ps1
```
Modify the script using your personal iCloud package name in {iCloud Package Name} & user folder in {User} for Windows in $folderPath
```
C:\Users\{User}\AppData\Local\Packages\{iCloud Package Name}\LocalCache\Local\Logs
```
And matches the filename pattern:
```
iCloudServices.*.log
```
Only files modified within the last 1 hours will be monitored by default.

## Customization
To customize the script for your needs, you can modify the following variables at the beginning of the script:

$folderPath: The path to the folder containing the log files you want to monitor.
$globPattern: The filename pattern to match the log files you want to monitor.
$maxFileAgeHours: The maximum age (in hours) of log files you want to monitor. Files older than this value will be ignored.
### Requirements
Windows PowerShell 5.1 or later
Read access to the log files and folders
### Limitations
The script may not be able to access log files that are locked by other processes.
Performance may degrade if a large number of log files are being monitored simultaneously.

# Update-DuckDNS.ps1

Updates the IP address of your Duck DNS domain(s). Intended to be run as a scheduled task.

## Requirements

1. PowerShell 2.0+

## Usage

`.\Update-DuckDNS.ps1 -Domains "foo,bar" -Token my-duck-dns-token`

## Scheduled Task Instructions:
1. Open Task Scheduler:
  - Win+R (run): taskschd.msc
2. Right-click "Task Scheduler Library" and click "Add Basic Task"
   1. Name it and set a schedule of "daily"
   2. Action: Start a program
      1. Program Script: powershell.exe
      2. Add Arguments: -ExecutionPolicy ByPass -File "C:\Path\To\Powershell\Script\Update-DuckDNS.ps1" -Domains "foo,bar" -Token my-duck-dns-token
   3. Finish
   4. Go into settings and check the box for "Run task as soon as possible after a scheduled start is missed"
3. Test: 
   1. Login to DuckDNS's site and change your ip to something new manually
   2. Right click the task in Task Scheduler and select "Run"
   3. Verify your IP has been updated on DuckDNS site.
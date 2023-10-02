# PrinterMapUtility

A PowerShell utility to facilitate the mapping of multiple printers from two predefined print servers. It provides an interactive menu-driven interface for users to select a print server and then map one or multiple printers in parallel for efficiency.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Mapping Printers](#mapping-printers)
- [Notes](#notes)
- [Troubleshooting](#troubleshooting)


## Features

- Interactive menu to select from two print servers: `testserver1` and `testserver2`.
- Allows mapping of multiple printers at once.
- Utilizes parallel processing to speed up printer mapping.
- Provides real-time progress updates during printer mapping.

## Prerequisites

- Windows 8/Windows Server 2012 or newer (due to reliance on the `Add-Printer` cmdlet).
- PowerShell 5.1 or newer.
- Appropriate permissions to map the printers on the network.

## Usage

1. Clone this repository or download the `PrintMapUtility.ps1` script.
2. Open a PowerShell terminal with elevated privileges (Run as Administrator).
3. Navigate to the directory containing the script.
4. Execute the script:

```powershell
.\PrinterMapUtility.ps1
```
Follow the on-screen prompts to select a print server and enter printer names. 

## Mapping Printers

1. **Interactive Menu:** The script will present you with an interactive menu. Here, you can select the desired print server or opt for the "Follow You Printer" option.

![image](https://github.com/Zeph3r/PrinterMapUtility/assets/25629680/1f9c9ce1-813c-45a5-acd6-ca7f6ecffc7b)


2. **Entering Printer Names:**

- If you selected a print server (e.g., printserver), you'll be prompted to enter the names of the printers you want to map.
- Separate each printer name with a comma.
- Example: printer1,printer2,printer3

![image](https://github.com/Zeph3r/PrinterMapUtility/assets/25629680/c5003648-5d5e-4c80-8677-cba887de2ef4)

3. **Mapping Progress:** After confirming your selection, the script will begin mapping the printers. You will see real-time progress, indicating which printers are successfully mapped and which ones failed.

![image](https://github.com/Zeph3r/PrinterMapUtility/assets/25629680/9fd7fac7-760d-44cc-a079-70db1442a910)

5. **Summary:** Once the script finishes its task, it will display a summary, showing you which printers were successfully added and which ones failed.

![image](https://github.com/Zeph3r/PrinterMapUtility/assets/25629680/9fd7fac7-760d-44cc-a079-70db1442a910)

7. **Return to Main Menu:** Simply press 'Enter' when prompted to return to the main menu and start another task or exit the script.

![image](https://github.com/Zeph3r/PrinterMapUtility/assets/25629680/5df9fe8e-699c-42cf-989d-9ec41435eadb)

## Notes

- When entering printer names, separate each name with a comma. Spaces are allowed before and after commas.
- Ensure you have network connectivity to the print servers.
- The script uses multi-threading to map printers in parallel. This speeds up the process but relies on the capability of the print server to handle multiple connections. If there are issues, consider checking the print server's health or network connectivity.

## Troubleshooting

1. **Printers aren't being mapped:** Ensure you've entered the correct printer name and that the printer exists on the selected print server.
2. **Permission issues:** Ensure you're running the script with elevated privileges and have permission to add printers on the network.
3. **Script execution is disabled on the system:** You might encounter a security error if your system's PowerShell execution policy is set to Restricted. You can temporarily bypass this by running the script with:

```
.\powershell -ExecutionPolicy Bypass -File .\PrintMapUtility.ps1
```

**Be cautious about bypassing execution policies, especially if you're unsure about a script's source or contents.**

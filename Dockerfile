####################################
#       Base Image
####################################
FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2022


####################################
#       Use Windows shell
####################################
SHELL ["cmd", "/S", "/C"]


####################################
#       Setup Chocolatey 
####################################
RUN powershell.exe -command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"


####################################
#       Setup cmd line text editor
####################################
RUN choco install nano -y


####################################
#       Setup entry point
####################################
CMD ["ping","-t","localhost",">>","C:\pulse.txt"]

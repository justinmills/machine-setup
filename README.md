# Machine Setup

This repos contains a bunch of setup scripts, docs on how to get things going on a new development machine.

## Windows

You may need to run the following to allow you to execute scripts. I don't think I've consistently
had to, but could be the machine's I'm using.

: Set-ExecutionPolicy Unrestricted -Scope CurrentUser


The [BoxStarter](https://boxstarter.org/) scripts should be run first to install all of the "base"
software you will need. These can be run and re-run as often as you like.

: START 'C:\Program Files\Internet Explorer\iexplore.exe' "http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/justinmills/machine-setup/master/windows/boxstarter-ell"

: START 'C:\Program Files\Internet Explorer\iexplore.exe' "http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/justinmills/machine-setup/master/windows/boxstarter"

Then you should run the PowerShell setup script (as administrator)

Before doing so, however, make sure you have a HOME environment variable set and it points to your
user's home directory:

: echo $HOME

To set it:

: [Environment]::SetEnvironmentVariable("HOME", "C:\Users\justin", "justin")

: iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/justinmills/machine-setup/master/windows/Setup.ps1'))


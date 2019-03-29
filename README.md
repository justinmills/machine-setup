# Machine Setup

This repos contains a bunch of setup scripts, docs on how to get things going on a new development machine.

## Windows

Fire up a PowerShell as administrator. It might be helpful to run another instance of PowerShell
within this shell so you can see any output from scripts that we may run in-process that may exit
(like the Setup.ps1 script referenced below). To do that run the following:

```ps
powershell -NoExit
```

You may need to run the following to allow you to execute scripts. I don't think I've consistently
had to, but could be the machine's I'm using.

```ps
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
```

You might also need to make sure you have $HOME set properly. PowerShell will provide this often,
but it's not set as a system-wide environment variable, so you should do that. The Setup.ps1 script
referenced below will check for that, but you can also verify/set it yourself:

```ps
echo $HOME
[Environment]::GetEnvironmentVariable("HOME")

# Assuming $HOME is set, but the environment variable is not...
[Environment]::SetEnvironmentVariable("HOME", "$HOME", "User")

# Alternatively, just set it manually
[Environment]::SetEnvironmentVariable("HOME", "C:\Users\justin", "User")
```

The [BoxStarter](https://boxstarter.org/) scripts should be run first to install all of the "base"
software you will need. These can be run and re-run as often as you like.

```ps
START 'C:\Program Files\Internet Explorer\iexplore.exe' "http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/justinmills/machine-setup/master/windows/boxstarter-ell"

START 'C:\Program Files\Internet Explorer\iexplore.exe' "http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/justinmills/machine-setup/master/windows/boxstarter"
```

This will install a bunch of software and do some machine setup/configuration. The following will
wrap things up, customize some things (powershell, emacs, etc) and do any other things too painful
to do via boxstarter, but easier via plain ole PowerShell

```ps
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/justinmills/machine-setup/master/windows/Setup.ps1'))
```

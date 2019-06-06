# Windows Developer Machine Initializer

This bat file uses Chocolatey to set up a standard Corballis Windows developer machine.

## How to Use it
- start an elevated cmd shell
- run ```setup-dev-machine.bat```

## Development
Windows Sandbox is recommended to update and test the batch file. Enable Windows Sandbox on
your machine and double click on the sandbox.wsb file to start a Windows Sandbox instance.
The wsb maps the local developer-tools folder into the container to make testing easier.
You might need to adjust the mapped folder path in the wsb file if required. 
# ubuntu24python

This is a very basic example of creating a Python project developing inside a docker container using VSCode.

The following is very short bullet point description of goals:

* Developing within docker container
* Automation of development environment spin-up with VSCode 
* Use of pipenv to separate development only Python pkgs to prod Python pkgs
* Use of precommit for the very basics - Note the CICD pipeline is the ultimate enforcer
* Debug launch
* Hints of how some would can be done in CICD pipeline but no pipeline files included


What this example is not:

* Complex or all-encompassing Python project format
* CICD pipeline example

## Development Enviornment 

### Prerequisites

* GIT
* Docker
* Visual Studio Code IDE
* Host MacOS, Linux, Windows - developed on MacOS

### Enviornment Spin-up

1. Clone repo to dev machine.

2. Open repo within vscode.  Vscode should recognize that a `.devcontainer/` is present in this project and a small dialog should pop up in the lower left right corner asking if you want to `Reopen in Container` - select that option.  If you do not see this option to re-open in a container click the bottom left corner of vscode on the green box.  This should open a pop up menu allowing to select the choice of `Reopen in Container`.

3. The `.devcontainer/` will also initialize the container with all the python requirments automatically performing a `pipenv install --dev`.  Note that pipenv is used vs. pip to more easily keep development environment packages separate from production environment packages.  The `--dev` agrument installs both the dev and prod python packages.  If a python package is required for only development work the package should be installed using the `--dev` argument.

4. Start the virtual enviornment: `pipenv shell`

5. A few Python debug operations are present.  Via 'Run and debug' open launch.json to see options.

6. The Python Interpreter may need to be set for the repo.  That can be done via the command pallette.
[![Actions Status](https://github.com/nimb3s/streets/workflows/master/badge.svg)](https://github.com/nimb3s/streets/actions)
[![Actions Status](https://github.com/nimb3s/streets/workflows/develop/badge.svg)](https://github.com/nimb3s/streets/actions)

#About the project
Streets is an address verification service utility.

# Getting Started
## Windows Users - Install Choco
Reference [install instructions from choco.org](https://chocolatey.org/install).
## Mac Users - Install Brew
Referece [brew.sh](https://brew.sh/)

After installing brew [install dotnet](https://formulae.brew.sh/cask/dotnet)

```brew
brew install --cask dotnet
```

## Install Visual Studio Code
Download and install VS Code [from the official stie]((https://code.visualstudio.com/download)).

After installing, install these extensions:
- [vscode-solution-explorer](https://marketplace.visualstudio.com/items?itemName=fernandoescolar.vscode-solution-explorer)
- [Kubernetes](https://marketplace.visualstudio.com/items?itemName=ms-kubernetes-tools.vscode-kubernetes-tools)
- [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
- [C#](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csharp)
- [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
- [DotENV](https://marketplace.visualstudio.com/items?itemName=mikestead.dotenv)

## Docker and Kubernetes

Install Docker from the [official site](https://www.docker.com/products/docker-desktop)

Enable Kuberenetes and Deploy Docker Stacks to Kubernetes by default. Take a look at the [docker docs on how to enable](https://docs.docker.com/desktop/kubernetes/).

## Github Actions
To run actions locally install nektos/act. Reference the [nektos/act](https://github.com/nektos/act) repo on how to install.

Before you isntall act, make sure docker is installed.

## Git repo cleanup before .gitignore file is committed
Just in case, run these git commands to cleanup a git repo when files are added before a .gitignore:
```
git rm -rf --cached .
git add .
git commit -am "cleanup"
```

## dotnet Tools
Install nerdbank. Run this in a commandline:
  - Click [here](https://github.com/dotnet/Nerdbank.GitVersioning/blob/master/doc/nbgv-cli.md) to learn more about the CLI. 
  - You can also go here to [learn more about Nerdbank.GitVersioning](https://github.com/dotnet/Nerdbank.GitVersioning).
  - To learn more about SemVer you can [read this doc and watch the vid](https://apifriends.com/api-management/what-is-semantic-versioning/)

Make sure you add dotnet tools to your environment path. To learn more about about `dotnet tool` [read the Microsoft docs](https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-tool-install)

```
dotnet tool install -g nbgv
```
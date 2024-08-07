﻿# <img src="https://cdn.jsdelivr.net/gh/brogers5/chocolatey-package-localsend@6414b40023c2c8fa002621c682a5dc6dd92e3f14/localsend.png" width="48" height="48"/> Chocolatey Package: [LocalSend](https://community.chocolatey.org/packages/localsend)

[![Chocolatey package version](https://img.shields.io/chocolatey/v/localsend.svg)](https://community.chocolatey.org/packages/localsend)
[![Chocolatey package download count](https://img.shields.io/chocolatey/dt/localsend.svg)](https://community.chocolatey.org/packages/localsend)

---

This package is part of a family of packages published for LocalSend. This repository is for the meta package.

* For the installer package, see [chocolatey-package-localsend.install](https://github.com/brogers5/chocolatey-package-localsend.install).
* For the portable package, see [chocolatey-package-localsend.portable](https://github.com/brogers5/chocolatey-package-localsend.portable).

See the [Chocolatey FAQs](https://docs.chocolatey.org/en-us/faqs) for more information on [meta packages](https://docs.chocolatey.org/en-us/faqs#what-is-the-difference-between-packages-no-suffix-as-compared-to.install.portable) and [installer/portable packages](https://docs.chocolatey.org/en-us/faqs#what-distinction-does-chocolatey-make-between-an-installable-and-a-portable-application).

---

## Install

[Install Chocolatey](https://chocolatey.org/install), and run the following command to install the latest approved stable version from the Chocolatey Community Repository:

```shell
choco install localsend --source="'https://community.chocolatey.org/api/v2'"
```

Alternatively, the packages as published on the Chocolatey Community Repository will also be mirrored on this repository's [Releases page](https://github.com/brogers5/chocolatey-package-localsend/releases). The `nupkg` can be installed from the current directory (with dependencies sourced from the Community Repository) as follows:

```shell
choco install localsend --source="'.;https://community.chocolatey.org/api/v2/'"
```

## Build

[Install Chocolatey](https://chocolatey.org/install), clone this repository, and run the following command in the cloned repository:

```shell
choco pack
```

A successful build will create `localsend.x.y.z.nupkg`, where `x.y.z` should be the Nuspec's `version` value at build time.

Note that Chocolatey package builds are non-deterministic. Consequently, an independently built package will fail a checksum validation against officially published packages.

## Update

This package should be automatically updated by the [Chocolatey Automatic Package Updater Module](https://github.com/majkinetor/au), with update queries implemented by the [PowerShellForGitHub PowerShell Module](https://github.com/microsoft/PowerShellForGitHub). If it is outdated by more than a few days, please [open an issue](https://github.com/brogers5/chocolatey-package-localsend/issues).

AU expects the parent directory that contains this repository to share a name with the Nuspec (`localsend`). Your local repository should therefore be cloned accordingly:

```shell
git clone git@github.com:brogers5/chocolatey-package-localsend.git localsend
```

Alternatively, a junction point can be created that points to the local repository (preferably within a repository adopting the [AU packages template](https://github.com/majkinetor/au-packages-template)):

```shell
mklink /J localsend ..\chocolatey-package-localsend
```

Once created, simply run `update.ps1` from within the created directory/junction point. Assuming all goes well, all relevant files should change to reflect the latest version available. This will also build a new package version using the modified files.

To forcibly create an updated package (regardless of whether a new software version is available), pass the `-Force` switch:

```powershell
.\update.ps1 -Force
```

Before submitting a pull request, please [test the package](https://docs.chocolatey.org/en-us/community-repository/moderation/package-verifier#steps-for-each-package) using the [Chocolatey Testing Environment](https://github.com/chocolatey-community/chocolatey-test-environment) first.

# Synology Toolkit System Requirements for Non-Linux OS

It provides an environment to run the toolkits distributed by [Synology Developer Center](https://www.synology.com/ja-jp/support/developer) on non-Linux OS such as macOS.

## Preparation

What you need

* Docker
* bash or a compatible version

Preparing to run

```console
$ git clone https://github.com/sharkpp/synology-toolkit-for-non-linux.git
$ cd synology-toolkit-for-non-linux
$ docker/build.sh
           :
 => exporting to image                                                                            1.0s
 => => exporting layers                                                                           0.8s
 => => writing image sha256:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx      0.0s
 => => naming to docker.io/library/synorogy-toolkit 
```

## Usage

### EnvDeproy

Get the platforms that can be specified.

```console
$ pkgscripts/EnvDeploy -v 7.0 -l
Available bromolow cedarview armadaxp armada370 armada375 evansport comcerto2k avoton alpine braswell apollolake grantley alpine4k monaco broadwell kvmx64 armada38x denverton rtd1296 broadwellnk purley armada37xx geminilake v1000
```

Building the development environment

```console
$ pkgscripts/EnvDeploy -v 7.0 -p braswell
```

### PkgCreate.py

Preparation

1. put the source folder of the package under the source folder 2.
2. put the information for generating GPG keys in source/key.conf

Create the package

Create package

```console
$ pkgscripts/PkgCreate.py -v 7.0 -p braswell -c minimalPkg
                :
============================================================
                    Time Cost Statistic                     
------------------------------------------------------------
00:00:00: Traverse project
00:00:00: Link Project
00:00:03: Build Package
00:00:02: Install Package
00:00:01: Install Package
00:00:03: Generate code sign
00:00:00: Collect package

[SUCCESS] pkgscripts/PkgCreate.py -v 7.0 -p braswell -c minimalPkg finished.
```

Result

* Package generated under `result_spk` folder as `ds.{platform}-{version}/{package name & package version}`.
* A key created from `key.conf` is generated in `source/.gpupg` (if it already exists, it is not regenerated).

## License

&copy; 2021 sharkpp

This software is licensed under a [The MIT License](http://opensource.org/licenses/MIT).

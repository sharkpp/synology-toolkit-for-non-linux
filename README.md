# Synology Toolkit System Requirements for Non-Unix OS

It provides an environment to run the toolkits distributed by [Synology Developer Center](https://www.synology.com/ja-jp/support/developer) on non-Unix OS such as macOS.

## Preparation

What you need

* Docker
* bash or a compatible version

Preparing to run

```console
$ git clone https://github.com/sharkpp/synology-toolkit-for-non-unix.git
$ cd synology-toolkit-for-non-unix
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
$ pkgscripts/EnvDeploy -v 6.2 -l
Available platforms: 6281 alpine alpine4k apollolake armada370 armada375 armada37xx armada38x armadaxp avoton braswell broadwell broadwellnk bromolow cedarview comcerto2k denverton dockerx64 evansport geminilake grantley hi3535 kvmx64 monaco purley qoriq rtd1296 v1000 x64
```

Building the development environment

```console
$ pkgscripts/EnvDeploy -v 6.2 -p x64
```

Results

* `toolkit_tarballs` contains a set of tar files related to the development environment.

### PkgCreate.py

Preparation

1. put the source folder of the package under the source folder 2.
2. put the information for generating GPG keys in source/key.conf

Create the package

Create package

```console
$ pkgscripts/PkgCreate.py -v 6.2 -p x64 -c minimalPkg
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

[SUCCESS] pkgscripts/PkgCreate.py -v 6.2 -p x64 -c minimalPkg finished.
```

Result

* Package generated under `result_spk` folder as `ds.{platform}-{version}/{package name & package version}`.
* A key created from `key.conf` is generated in `source/.gpupg` (if it already exists, it is not regenerated).

## License

&copy; 2021 sharkpp

This software is licensed under a [The MIT License](http://opensource.org/licenses/MIT).

# 非Linux系OS のための Synology ツールキット動作環境

[Synology デベロッパ センター](https://www.synology.com/ja-jp/support/developer) で
配布されているツールキットを macOS などの非Linux系のOSで動作させるための環境を提供します。

## 準備

必要なもの

* Docker
* bash もしくは互換性のあるもの

実行するための準備

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

## 使い方

### EnvDeproy

指定可能なプラットフォームの取得

```console
$ pkgscripts/EnvDeploy -v 7.0 -l
Available bromolow cedarview armadaxp armada370 armada375 evansport comcerto2k avoton alpine braswell apollolake grantley alpine4k monaco broadwell kvmx64 armada38x denverton rtd1296 broadwellnk purley armada37xx geminilake v1000
```

開発環境の構築

```console
$ pkgscripts/EnvDeploy -v 7.0 -p braswell
```

### PkgCreate.py

事前準備

1. source フォルダ以下にパッケージのソースフォルダを置く
2. source/key.conf に GPG キーを生成するための情報を記載する

パッケージの作成

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

結果

* `result_spk` フォルダの下に `ds.{プラットフォーム}-{バージョン}/{パッケージ名＆パッケージバージョン}` として生成されたパッケージが生成される
* `source/.gpupg` に `key.conf` から作成されたキーが生成される(既に存在する場合は再生成されない)

## ライセンス

&copy; 2021 sharkpp

このソフトウェアは [The MIT License](http://opensource.org/licenses/MIT) でライセンスされています。

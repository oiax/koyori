Koyori - A preprocessor for kindlegen
=====================================

## 概要

これは、株式会社オイアクスが発行する Kindle 向け電子書籍のために作られた Ruby プログラムです。

[Koyori記法](http://github.com/oiax/koyori/blob/master/doc/format.md)と呼ばれる、特別なマークアップを1個のHTMLファイルに変換します。

このHTMLファイルを`kindlegen`（後述）で処理すると拡張子`.mobi`を持つファイルが生成されます。

これを[Amazon Kindleダイレクト・パブリッシンング](https://kdp.amazon.co.jp/)のサイトに登録すれば、Kindle用電子書籍として販売できます。

## 動作要件

* Ruby 2.0.0 以上
* Git

## インストール

`~/koyori` にインストールする場合の手順：

    $ cd ~
    $ git clone https://github.com/oiax/koyori
    $ export PATH="$HOME/koyori/bin"

最後のコマンドを `~/.bashrc` 等に追加してください。

## アップデート

Koyori を最新版にアップデートする手順：

    $ cd ~/koyori
    $ git pull

## 使用法

適当な作業ディレクトリを用意してください。以下、`~/kdp/example1` を作業ディレクトリとします。

`~/kdp/example1` に以下のような内容の新規ファイル `config.yml` を作成します。

<pre>
file_name: neko_ruby
title: 猫でも分かるRuby
author: 例示 花子
publisher: 株式会社エグザンプル
date: 2014-08-01
</pre>

`~/kdp/example1` に以下のような内容の新規ファイル `CHAPTERS` を作成します。

<pre>
preface.koy
what_is_ruby.koy
ruby_is_fun.koy
</pre>

`~/kdp/example1` に、[Koyori記法](http://github.com/oiax/koyori/blob/master/doc/format.md)でファイル群 `preface.koy`, `what_is_ruby.koy`, `ruby_is_fun.koy` を作成します。ここでは、ファイル名の拡張子を `.koy` としていますが、ファイル名に制限はありません。

`preface.koy` という名前のファイルは「前書き」の内容を含むものとして特別扱いされます。「前書き」がある場合、「目次」は「前書き」の後ろに挿入されます。

`~/kdp/example1` に以下のような内容の新規ファイル `PROTECTED_WORDS` を作成します（任意）。

<pre>
Koyori
HTML
Ruby
</pre>

Koyoriは段落、見出し、箇条書きなどの内容に含まれるASCII文字列を `<code>` と `</code>` で囲みます。ただし、`PROTECTED_WORDS` に載せられた単語はこの処理の対象から除外されます。

`~/kdp/example1` ディレクトリで `koyori` コマンドを実行します。

    $ koyori

すると、`neko_ruby.html` という名前のファイルが生成されます。


## mobi ファイルの生成

あらかじめ `kindlegen` をインストールしておきます。https://kdp.amazon.co.jp/ から無償でダウンロードできます。また、環境変数 `PATH` に `kindlegen` プログラムのパスを追加しておいてください。

`~/kdp/example1` ディレクトリで次のコマンドを実行します。

    $ kindlegen neko_ruby.html

すると、`neko_ruby.mobi` という名前のファイルが生成されます。


## ライセンス

このソフトウェアは、[MIT License](https://github.com/oiax/koyori/blob/master/MIT-LICENSE.txt)に基づいて公開されています。

著作権者の許諾を得ることなく、誰でも無償で無制限に使用・配布できます。

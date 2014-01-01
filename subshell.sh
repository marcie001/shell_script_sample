#!/bin/sh
# サブシェルのサンプル
# () 内の変数の代入は、() を抜けると影響を及ぼさない
foo=foo0
(
  echo $foo
  foo=foo1
  echo $foo
) > logfile
echo $foo >> logfile

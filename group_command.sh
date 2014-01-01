#!/bin/sh
# グループコマンドのサンプル
# { } 内の変数の代入などは、{ } を抜けても影響を及ぼす

foo=foo0
{
  echo "$foo"
  foo=foo1
  echo "$foo"
} > logfile
echo "$foo" >> logfile

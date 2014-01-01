#!/bin/sh
# wait のサンプル

(sleep 5; exit 25) &
echo $!  # $!: 直近のバックグラウンドで起動されたコマンドのプロセスID
wait $!
echo $?  # wait の終了ステータスは引数で指定したプロセスの終了ステータス

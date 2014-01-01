#!/bin/sh
# read のサンプル
# select.sh と同じ動きをする

while
  echo -n \
'1) 検索
2) 登録
3) 編集
4) 削除
5) quit
なにをしますか?(対応する数字を入力) ' 1>&2
  read cmd
do
  case $cmd in
    1)
      echo '検索します';;
    2)
      echo '登録します';;
    3)
      echo '編集します';;
    4)
      echo '削除します';;
    5)
      echo '終了します'
      break;;  #while 文の終了
    *)
      echo "$cmd"'というコマンドはありません';;
  esac
  echo
done

#!/bin/bash
# select 文のサンプル
# read.sh と同じ動きをする

PS3='なにをしますか?(対応する数字を入力) '
# select 文は bash のみ
select cmd in 検索 登録 編集 削除 quit
do
  case $cmd in
  検索)
    echo '検索します';;
  登録)
    echo '登録します';;
  編集)
    echo '編集します';;
  削除)
    echo '削除します';;
  quit)
    echo '終了します'
    break;;  #select 文の終了
  *)
    echo "$REPLY"'というコマンドはありません';;
  esac
  echo
done

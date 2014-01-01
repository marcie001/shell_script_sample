#!/bin/sh
# アドレス帳のサンプル

file='address.txt'
while getopts f: option
do
  case $option in
    f)
      file="$OPTARG";;
    \?)
      echo "Usage: $0 [-f file]" 1>&2
      exit 1;;
  esac
done

if [ -f "$file" ]; then :; else
  touch "$file"
fi

search_address() 
{
  while 
    echo -n "1) 名前（中間一致）\n2) 住所（前方一致）\n3) 年齢（以上）\n4) 検索を終わる\n検索方法(対応する数字を入力) " 1>&2
    read search
  do
    case $search in
      1)
        echo -n '検索する名前を入力してください ' 1>&2
        read cond
        show_address "`awk -F"\t" '$1$2 ~ /'"$cond"'/ { if (length($0) > 0) print NR "\t" $0 }' "$file"`";;
      2)
        echo -n '検索する住所を入力してください ' 1>&2
        read cond
        show_address "`awk -F"\t" '$3 ~ /^'"$cond"'/ { if (length($0) > 0) print NR "\t" $0 }' "$file"`";;
      3)
        echo -n '検索する年齢を入力してください ' 1>&2
        read cond
        show_address "`awk -F"\t" '$4 > '"$cond"' { if (length($0) > 0) print NR "\t" $0 }' "$file"`";;
      4)
        break;;
      *)
        echo '不正な入力です' 1>&2;;
    esac
    echo 1>&2
  done
}

find_address() {
  awk -F"\t" 'NR == '"$1"' { print $0 }' "$file"
}

show_address()
{
  if [ ${#1} -eq 0 ]; then echo "該当するデータがありません" 1>&2; return 1; fi

  echo "$1" | awk -F"\t" '{ print "===\nid: " $1 "\n" "name: " $2 $3 "\n" "address: " $4 "\n" "age: " $5 }' -
}

read_address()
{
  while 
    echo '名字を入力してください' 1>&2
    read family_name
    test ${#family_name} -eq 0 && test $# -eq 0
  do :; done
  while 
    echo '名前を入力してください' 1>&2
    read name
    test ${#name} -eq 0 && test $# -eq 0
  do :; done
  while 
    echo '住所を入力してください' 1>&2
    read address
    test ${#address} -eq 0 && test $# -eq 0
  do :; done
  while 
    echo '年齢を入力してください' 1>&2
    read age
    test ${#age} -eq 0 && test $# -eq 0
  do :; done

  if [ $# -eq 0 ]
  then
    echo "$family_name\t$name\t$address\t$age" >> "$file"
  else
    tmp=`awk -F"\t" \
        -v OFS="\t" \
        -v familyname="$family_name" \
        -v name="$name" \
        -v address="$address" \
        -v age="$age" \
        -v editid="$1" \
        -f "address.awk" \
        "$file"`
    echo "$tmp" > "$file"
  fi
}

delete_address()
{
  tmp=`awk 'NR == '"$1"' { print "" } NR != '"$1"' { print $0 }' "$file"`
  echo "$tmp" > "$file"
}

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
      search_address;;
    2)
      read_address
      echo '登録しました' 1>&2;;
    3)
      while
        echo -n "編集したいデータの id を入力してください(何も入力しないでエンターを押すと検索を行えます) " 1>&2
        read edit_id
        if [ ${#edit_id} -eq 0 ]
        then
          search_address
        else
          result=`find_address "$edit_id"`
        fi
        test `echo "$result" | wc -l` -ne 1 || test ${#result} -eq 0
      do :; done
      echo "id $edit_id を編集します。変更しないデータは何も入力せずエンターを押してください。" 1>&2
      read_address $edit_id
      echo '編集しました' 1>&2;;
    4)
      while
        echo -n "削除したいデータの id を入力してください(何も入力しないでエンターを押すと検索を行えます) " 1>&2
        read del_id
        if [ ${#del_id} -eq 0 ]
        then
          search_address
        else
          result=`find_address "$del_id"`
        fi
        test `echo "$result" | wc -l` -ne 1 || test ${#result} -eq 0
      do :; done
      delete_address "$del_id"
      echo "id $del_id を削除しました" 1>&2;;
    5)
      echo '終了します' 1>&2
      break;;
    *)
      echo "$cmd"'というコマンドはありません' 1>&2;;
  esac
  echo 1>&2
done

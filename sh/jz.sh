#!/usr/bin/env bash

# このスクリプトは、次のような呼びパターンがあります。
# $ sh jz.sh set 2023-01-01
# $ sh jz.sh add 5d
# $ sh jz.sh add 5m
# $ sh jz.sh reset
# $ sh jz.sh clear
# $ sh jz.sh
# 引数がsetの場合は、次の日付をjz.txtファイルに保存します。
# 引数がaddの場合は、d.txtファイルの日付に、引数の日数を加算します。
# 引数がresetの場合は、d.txtファイルの日付を、現在の日付にします。
# 引数がclearの場合は、d.txtファイルを削除します。
# 引数がない場合は、d.txtファイルの日付を表示します。

# 処理開始
##########################
# 引数のチェック
##########################
if [ $# -gt 2 ]; then
    echo "引数が多すぎます。"
    exit 1
fi
if [ $# -eq 2 ]; then
    if [ $1 != "set" -a $1 != "add" ]; then
        echo "引数が不正です。"
        exit 1
    fi
fi
# 引数が set add reset clear のいずれでもない場合は、エラー終了します。
if [ $# -eq 1 ]; then
    if [ $1 != "set" -a $1 != "add" -a $1 != "reset" -a $1 != "clear" ]; then
        echo "引数が不正です。"
        echo "set add reset clear のいずれかを指定してください。"
        exit 1
    fi
fi

##########################
# 日付決定フェーズ
##########################
# d.txtファイルがない場合は、現在の日付をd.txtファイルに保存します。
if [ ! -e d.txt ]; then
    date +"%Y-%m-%d" > d.txt
fi
# 引数がない場合は、d.txtファイルの日付を表示します。
if [ $# -eq 0 ]; then
    cat d.txt
fi
# 引数がsetの場合は、次の日付をjz.txtファイルに保存します。
if [ $1 = "set" ]; then
    date -d $2 +"%Y-%m-%d" > d.txt
fi
# 引数がaddの場合は、d.txtファイルの日付に、引数の日数を加算します。
if [ $1 = "add" ]; then
    if [ ${2: -1} = "d" ]; then
        # 日付を加算します。
        d=$(date -d "$(cat d.txt) ${2:0:-1} day" "+%Y-%m-%d")
    elif [ ${2: -1} = "m" ]; then
        # 月を加算します。
        d=$(date -d "$(cat d.txt) ${2:0:-1} month" "+%Y-%m-%d")
    else
        # 日付を加算します。
        d=$(date -d "$(cat d.txt) $2 day" "+%Y-%m-%d")
    fi
    echo $d > d.txt
    cat d.txt
fi
# 引数がresetの場合は、d.txtファイルの日付を、現在の日付にします。
if [ $1 = "reset" ]; then
    date +"%Y-%m-%d" > d.txt
    cat d.txt
fi
# 引数がclearの場合は、d.txtファイルを削除します。
if [ $1 = "clear" ]; then
    rm d.txt
fi

##########################
# ファイル編集フェーズ
##########################
FILE1=./main.php
JZ_START='\/\/ jz >>>>>>>>'
JZ_END='\/\/ jz <<<<<<<<'

# 1.0の処理
FILE1=./main.php
if [ -e $FILE1 ]; then
    echo $FILE1 を処理します
fi

# 一旦jzコードを削除
sed -i -e "/$JZ_START/, /$JZ_END/d" $FILE1

# d.txtファイルがない場合は、clearとみなし、終わり
if [ ! -e d.txt ]; then
    # jzコード削除する
    exit 0
fi

# 日付を取得
DATE=$(cat d.txt)
# YYYY-MM-DD形式の文字列を、Y,M,Dに分割
Y=${DATE:0:4}
M=${DATE:5:2}
D=${DATE:8:2}

# jzコードを追加
sed -i -e "/function hello_world() {/a\\
$JZ_START \\
$DATE \\
$JZ_END" $FILE1


echo $DATE に設定しました。

exit 0

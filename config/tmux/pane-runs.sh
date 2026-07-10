#!/usr/bin/env bash
# tmux の if-shell 判定用: pane (tty=$1) の最前面プロセス名が正規表現 $2 に一致するか
# 状態が T/X/Z (停止・死亡) のプロセスは除外する
ps -o state= -o comm= -t "$1" | grep -iqE "^[^TXZ ]+ +(\S+/)?($2)\$"

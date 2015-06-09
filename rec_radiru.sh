#!/bin/bash

LANG=ja_JP.utf8

date=`date '+%Y-%m-%d-%H-%M'`
outdir="."

#引数：[Ch.名] [録音秒数] [出力先] [ファイル名]
# [録音秒数]は30秒増しに録られる
# [ファイル名]は[ファイル名]-YYYY-MM-DD-HH-mm.m4aで保存される。デフォルトは[Ch.名]
# [Ch.名]は
# R1   : AM #1 (Tokyo , News)
# R2   : AM #2 (Tokyo , Classical)
# FM   : FM    (Tokyo )
# HKR1 : AM #1 (Sendai, News)
# HKFM : FM    (Sendai)
# CKR1 : AM #1 (Nagoya, News)
# CKFM : FM    (Nagoya)
# BKR1 : AM #1 (Osaka , News)
# BKFM : FM    (Osaka )

#引数が足りないときは、使用方法を表示して戻り値１でバイバイ。
if [ $# -le 1 ]; then
  echo "usage : $0 channel_name duration(minutes) [outputdir] [prefix]"
  exit 1
fi

#引数が2つ以上あるときは、1個目をCh.名に、2個目を録音時間に指定。
if [ $# -ge 2 ]; then
  channel=$1
  DURATION=`expr $2 \* 60 + 30`
fi

#引数が3つ以上あるときは、3個目を出力先ディレクトリに指定。
if [ $# -ge 3 ]; then
  outdir=$3
fi

#引数が4つあるときは、4個目をファイル名の固定値に指定する。指定しなければ固定値はCh.名。
PREFIX=${channel}
if [ $# -ge 4 ]; then
  PREFIX=$4
fi

#Ch.名による条件分岐
# --rtmpの引数（play_url）と--playpathの引数（ch_url）のみ違う。

case "$channel" in

"R1" )
  # ラジオ第1
  play_url="rtmpe://netradio-r1-flash.nhk.jp"
  ch_url='NetRadio_R1_flash@63346'
  ;;

"R2" )
  # ラジオ第2
  play_url="rtmpe://netradio-r2-flash.nhk.jp"
  ch_url='NetRadio_R2_flash@63342'
  ;;

"FM" )
  # NHK-FM
  play_url="rtmpe://netradio-fm-flash.nhk.jp"
  ch_url='NetRadio_FM_flash@63343'
  ;;

# 2013/5/27から仙台(JOHK)・名古屋(JOCK)・大阪(JOBK)の各ローカル放送（ラジオ第1及びFM）がらじる★らじるに対応

"HKR1" )
  # 仙台放送局ラジオ第1
  play_url="rtmpe://netradio-hkr1-flash.nhk.jp"
  ch_url='NetRadio_HKR1_flash@108442'
  ;;

"HKFM" )
  # 仙台放送局FM
  play_url="rtmpe://netradio-hkfm-flash.nhk.jp"
  ch_url='NetRadio_HKFM_flash@108237'
  ;;

"CKR1" )
  # 名古屋放送局ラジオ第1
  play_url="rtmpe://netradio-ckr1-flash.nhk.jp"
  ch_url='NetRadio_CKR1_flash@108234'
  ;;

"CKFM" )
  # 名古屋放送局FM
  play_url="rtmpe://netradio-ckfm-flash.nhk.jp"
  ch_url='NetRadio_CKFM_flash@108235'
  ;;

"BKR1" )
  # 大阪放送局ラジオ第1
  play_url="rtmpe://netradio-bkr1-flash.nhk.jp"
  ch_url='NetRadio_BKR1_flash@108232'
  ;;

"BKFM" )
  # 大阪放送局FM
  play_url="rtmpe://netradio-bkfm-flash.nhk.jp"
  ch_url='NetRadio_BKFM_flash@108233'
  ;;

esac

filename="${PREFIX}-${date}.m4a"

#
# rtmpdump
#
rtmpdump \
         --rtmp ${play_url} \
         --playpath ${ch_url} \
         --app "live" \
         --swfVfy http://www3.nhk.or.jp/netradio/files/swf/rtmpe.swf \
         --live \
         --stop ${DURATION} \
         -o "/tmp/${filename}" && \
mv "/tmp/${filename}" "${outdir%%/}/${filename}"

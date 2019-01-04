# 参考
# C https://www.mm2d.net/main/prog/c/
# PNG書式 https://www.setsuki.com/hsp/ext/png.htm
# PNGを読む https://hoshi-sano.hatenablog.com/entry/2013/08/18/112550
# PNGを読む http://darkcrowcorvus.hatenablog.jp/entry/2017/02/12/235044#IHDR-%E3%83%98%E3%83%83%E3%83%80%E6%83%85%E5%A0%B1
# Pythonで画像生成 http://d.hatena.ne.jp/c-yan2/20100317/1268825146

import crc32
import strutils, streams, algorithm, sequtils

type
  RGBA = object
    r, g, b, a: uint8

  Pixel = object
    color: RGBA
    colorIndex, grayIndex: uint8
  
  ColorType = enum
    index, gray, rgb, rgba
  
  Image = object
    width, height: uint32
    colorType: ColorType
    pixels: seq[seq[Pixel]]
  
proc toHexStr(n: int, digit: int): string =
  n.toHex(digit).parseHexStr

proc chunk(t: string, d: string): string =
  d.len.toHexStr(8) & t & d

var
  imageWidth = 701
  imageHeight = 191
  s = "test.dat".newFileStream fmWrite
defer: s.close

# PNGファイルシグネチャの書き込み 8byte
for data in ['\x89', 'P', 'N', 'G', '\x0D', '\x0A', '\x1A', '\x0A']:
  s.write data

var data = [
  [imageWidth, 8],  # (4)画像の横幅
  [imageHeight, 8], # (4)画像の縦幅
  [8, 2],           # (1)ビット深度
  [6, 2],           # (1)カラータイプ
  [0, 2],           # (1)圧縮手法
  [0, 2],           # (1)フィルター手法
  [0, 2]            # (1)インターレース手法
]

# (4)CRC (cyclic redundancy check)
# chunk type と chunk dataで計算する
# https://qiita.com/mikecat_mixc/items/e5d236e3a3803ef7d3c5

var dataDiv = data.mapIt(it[0].toHexStr it[1]).join("")
s.write chunk("IHDR", dataDiv)
s.write crc32("IHDR" & dataDiv)
echo chunk("IHDR", dataDiv).len
echo len($(crc32("IHDR" & dataDiv)))

# IDATチャンク: 可変長: イメージデータ
# TODO

# IENDチャンク: 12byte: イメージ終端
s.write chunk("IEND", "")
s.write crc32("IEND" & "")

# 参考
# C https://www.mm2d.net/main/prog/c/
# PNG書式 https://www.setsuki.com/hsp/ext/png.htm
# PNGを読む https://hoshi-sano.hatenablog.com/entry/2013/08/18/112550
# PNGを読む http://darkcrowcorvus.hatenablog.jp/entry/2017/02/12/235044#IHDR-%E3%83%98%E3%83%83%E3%83%80%E6%83%85%E5%A0%B1
# Pythonで画像生成 http://d.hatena.ne.jp/c-yan2/20100317/1268825146

import crc32
import strutils, streams, algorithm

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

var
  imageWidth = 701
  imageHeight = 191
  s = "test.dat".newFileStream fmWrite
defer: s.close

# PNGファイルシグネチャの書き込み 8byte
for data in ['\x89', 'P', 'N', 'G', '\x0D', '\x0A', '\x1A', '\x0A']:
  s.write data

# IHDRチャンク: 25byte: イメージヘッダ https://www.setsuki.com/hsp/ext/chunk/IHDR.htm
## (4)length
s.write 13.toHexStr 8

## (4)chunk type
s.write "IHDR"

## chunk data

# (4)画像の横幅
s.write imageWidth.toHexStr 8

# (4)画像の縦幅
s.write imageHeight.toHexStr 8

# (1)ビット深度
# TODO: とりあえず決め打ち
#s.write 0x08'u8
s.write 8.toHexStr 2

# (1)カラータイプ
# TODO: とりあえず決め打ち
s.write 6.toHexStr 2

# (1)圧縮手法
# TODO: とりあえず決め打ち
s.write 0.toHexStr 2

# (1)フィルター手法
s.write 0.toHexStr 2

# (1)インターレース手法
# なし = 0, あり = 1
s.write 0.toHexStr 2

# (4)CRC (cyclic redundancy check)
# chunk type と chunk dataで計算する
# https://qiita.com/mikecat_mixc/items/e5d236e3a3803ef7d3c5
let w = imageWidth.toHexStr 8
let h = imageHeight.toHexStr 8
s.write crc32("IHDR" & w & h & $0x06'u8 & $0x08'u8 & $0x00'u8 & $0x00'u8 & $0x00'u8)

# IDATチャンク: 可変長: イメージデータ
# TODO

# IENDチャンク: 12byte: イメージ終端
## (4)length
s.write '\x00' # 固定
s.write '\x00' # 固定
s.write '\x00' # 固定
s.write '\x00' # 固定

## (4)chunk type
s.write "IEND"
## (4)crc
#s.write crc32("IEND")

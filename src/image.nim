# 参考
# C https://www.mm2d.net/main/prog/c/
# PNG書式 https://www.setsuki.com/hsp/ext/png.htm
# PNGを読む https://hoshi-sano.hatenablog.com/entry/2013/08/18/112550
# PNGを読む http://darkcrowcorvus.hatenablog.jp/entry/2017/02/12/235044#IHDR-%E3%83%98%E3%83%83%E3%83%80%E6%83%85%E5%A0%B1

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
  
  BitDepth = enum
    grayScale = '\x00', trueColor = '\x02', indexColor = '\x03', grayScaleAlpha = '\x04', trueColorAlpha = '\x06'

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
s.write '\x00' # 固定
s.write '\x00' # 固定
s.write '\x00' # 固定
s.write '\x0d' # 固定

## (4)chunk type
s.write '\x49' # 固定
s.write '\x48' # 固定
s.write '\x44' # 固定
s.write '\x52' # 固定

## chunk data

# (4)画像の横幅
s.write imageWidth.toHex(8).parseHexStr

# (4)画像の縦幅
s.write imageHeight.toHex(8).parseHexStr

# (1)ビット深度
# TODO: とりあえず決め打ち
s.write BitDepth.trueColorAlpha

# (1)カラータイプ
# TODO: とりあえず決め打ち
s.write '\x08'

# (1)圧縮手法
# TODO: とりあえず決め打ち
s.write '\x00'

# (1)フィルター手法
s.write '\x00'

# (1)インターレース手法
# なし = 0, あり = 1
s.write '\x00'

# (4)CRC (cyclic redundancy check)
# chunk type と chunk dataで計算する
# https://qiita.com/mikecat_mixc/items/e5d236e3a3803ef7d3c5

when false:

  # IDATチャンク: 可変長: イメージデータ

  # IENDチャンク: 12byte: イメージ終端
  ## (4)length
  s.write '\x00' # 固定
  s.write '\x00' # 固定
  s.write '\x00' # 固定
  s.write '\x00' # 固定

  ## (4)chunk type
  s.write '\x49' # 固定
  s.write '\x45' # 固定
  s.write '\x4E' # 固定
  s.write '\x44' # 固定

  ## (4)crc

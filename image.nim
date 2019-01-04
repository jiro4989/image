# 参考
# C https://www.mm2d.net/main/prog/c/
# PNG書式 https://www.setsuki.com/hsp/ext/png.htm
# PNGを読む https://hoshi-sano.hatenablog.com/entry/2013/08/18/112550

import strutils, streams, algorithm
import sequtils

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

echo '\x61'
echo '\x70'
echo chr('\x70'.int)
echo chr('\x61'.int + '\x0f'.int)

# (4)画像の横幅
s.write imageWidth.toHex(8).parseHexStr

# (4)画像の縦幅
s.write imageHeight.toHex(8).parseHexStr

when false:
  # (1)ビット深度
  # (1)カラータイプ
  # (1)圧縮手法
  # (1)フィルター手法
  # (1)インターレース手法
  # (4)CRC (cyclic redundancy check)

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

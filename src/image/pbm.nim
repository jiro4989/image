## pbm is PBM(Portable bitmap) image encoder/decorder module.
##
## PBM example
## ===========
##
## .. code-block:: text
##
##    P1
##    # comment
##    5 6
##    0 0 1 0 0
##    0 1 1 0 0
##    0 0 1 0 0
##    0 0 1 0 0
##    0 0 1 0 0
##    1 1 1 1 1
##
## See also:
## * https://ja.wikipedia.org/wiki/PNM_(%E7%94%BB%E5%83%8F%E3%83%95%E3%82%A9%E3%83%BC%E3%83%9E%E3%83%83%E3%83%88)

from strformat import `&`
from sequtils import mapIt, filterIt
import strutils

type
  PBMValue* = enum
    white = 0'u8
    black
  PBMObj = object
    fileDiscriptor*: string ## P1
    col*, row*: int
    data*: seq[seq[PBMValue]]
  PBM* = ref PBMObj

const fileDiscriptor* = "P1"

proc encode*(data: seq[seq[PBMValue]]): PBM =
  new(result)
  if data.len < 1:
    return
  let col = data[0].len
  let row = data.len

  result.fileDiscriptor = fileDiscriptor
  result.row = row
  result.col = col
  result.data = data

proc format*(self: PBM): string =
  let data = self.data.mapIt(it.mapIt(it.ord).join(" ")).join("\n")
  result = &"""{self.fileDiscriptor}
{self.col} {self.row}
{data}"""

proc decode*(s: string): PBM =
  new(result)
  var lines: seq[string]
  for line in s.splitLines:
    if not line.startsWith "#":
      lines.add line

  if lines.len < 3:
    return
  let colRow = lines[1].split(" ")
  if colRow.len < 2:
    return

  result.fileDiscriptor = lines[0]
  result.col = colRow[0].parseInt
  result.row = colRow[1].parseInt
  let rawData = lines[2..^1]
  result.data = rawData.mapIt(it.split(" ").mapIt(PBMValue(it.parseUInt)))

proc decode*(f: File): PBM =
  result = f.readAll.decode

proc `$`*(self: PBM): string =
  result = "{" & &"fileDiscriptor:{self.fileDiscriptor},col:{self.col},row:{self.row},data:{self.data}" & "}"
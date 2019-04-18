# Package

version       = "0.1.0"
author        = "jiro4989"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
binDir = "bin"
bin = @["image"]

# Dependencies

requires "nim >= 0.19.0"
requires "crc32"

task docs, "Generate documents":
  exec "nimble doc src/image/pbm.nim -o:docs/pbm.html"
  exec "nimble doc src/image/pgm.nim -o:docs/pgm.html"

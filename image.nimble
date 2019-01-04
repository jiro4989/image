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

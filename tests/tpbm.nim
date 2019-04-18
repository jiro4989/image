import unittest

import image/pbm as pbm

suite "encode":
  test "normal":
    check @[@[white, white, white], @[white, black, white]].encode()[] == 
      PBM(fileDiscriptor: fileDiscriptor,
            row: 2,
            col: 3,
            data: @[@[white, white, white], @[white, black, white]])[]

suite "format":
  test "normal":
    check PBM(fileDiscriptor: fileDiscriptor,
            row: 2,
            col: 3,
            data: @[@[white, white, white], @[white, black, white]]).format() ==
          """P1
3 2
0 0 0
0 1 0"""

suite "decode":
  test "normal":
    check pbm.decode("""P1
3 2
0 0 0
0 1 0""")[] == PBM(fileDiscriptor: fileDiscriptor,
                 row: 2,
                 col: 3,
                 data: @[@[white, white, white], @[white, black, white]])[]
  test "comment exists":
    check pbm.decode("""P1
# comment
3 2
0 0 0
0 1 0""")[] == PBM(fileDiscriptor: fileDiscriptor,
                 row: 2,
                 col: 3,
                 data: @[@[white, white, white], @[white, black, white]])[]
  test "illegal data":
    check pbm.decode("""P1
2 3""")[] == PBM()[]
    check pbm.decode("""P1
2""")[] == PBM()[]
    check pbm.decode("""P1
""")[] == PBM()[]
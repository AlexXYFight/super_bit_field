@BitFieldGen(runAfter: [BitFieldGen.addPartOfDirective])
library test_bit_field;

import 'package:super_bit_field/super_bit_field.dart';

part 'test_bit_field.g.dart';


@BitField(32)
class TestBitField {
  @Bits(2)
  late int twoBits; // 0-1

  @Bits(1)
  late int oneBit; // 2-2

  @Bits(3)
  late int threeBits; // 3-5

  late int value;

  factory TestBitField(int value, [
    GetSetHook<int> hook
  ]) = _TestBitField;
}



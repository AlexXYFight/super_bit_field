
import 'package:test/test.dart';
import 'package:super_bit_field_example/test_bit_field.dart';
import 'package:super_bit_field/super_bit_field.dart';

void main() {
  group('TestBitField', () {
    test('New BitField getField', () {
      TestBitField testBitField = TestBitField(276939876);
      expect(testBitField.twoBits, 0);
      expect(testBitField.oneBit, 1);
      expect(testBitField.threeBits, 4);
    });
    test('New BitField setField', () {
      TestBitField testBitField = TestBitField(1024);
      testBitField.twoBits = 2;
      testBitField.oneBit = 1;
      testBitField.threeBits = 5;
      expect(testBitField.value, 1070);
    });
    test('New BitField hook', () {
      int value = 0;
      TestBitField testBitField = TestBitField(value, GetSetHook<int>(onSet: (int v) {
        value = v;
      }, onGet: () {
        return value;
      }));
      testBitField.twoBits = 2;
      expect(value, 2);
      testBitField.oneBit = 1;
      expect(value, 6);
      testBitField.threeBits = 5;
      expect(value, 46);
    });
  });
}


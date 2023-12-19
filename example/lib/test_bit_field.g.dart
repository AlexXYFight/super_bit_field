part of 'test_bit_field.dart';

class _TestBitField implements TestBitField {
  _TestBitField(
    int value, [
    GetSetHook<int>? hook,
  ])  : _value = value,
        _hook = hook;

  static const int length = 32;

  static const int musk = ((0x01 << length) - 1);

  int _value = 0;

  final GetSetHook<int>? _hook;

  static const int twoBitsBits = 2;

  static const int oneBitBits = 1;

  static const int threeBitsBits = 3;

  static const int twoBitsOffset = 0;

  static const int oneBitOffset = 2;

  static const int threeBitsOffset = 3;

  static const int twoBitsMask = ((0x01 << twoBitsBits) - 1) << twoBitsOffset;

  static const int oneBitMask = ((0x01 << oneBitBits) - 1) << oneBitOffset;

  static const int threeBitsMask =
      ((0x01 << threeBitsBits) - 1) << threeBitsOffset;

  @override
  int get value {
    if (_hook != null && _hook.onGet != null) {
      _value = _hook.onGet!() & musk;
    }
    return _value & musk;
  }

  @override
  set value(value) {
    _value = value & musk;
    if (_hook != null && _hook.onSet != null) {
      _hook.onSet!(_value);
    }
  }

  @override
  int get twoBits => ((value & twoBitsMask) >> twoBitsOffset);

  @override
  int get oneBit => ((value & oneBitMask) >> oneBitOffset);

  @override
  int get threeBits => ((value & threeBitsMask) >> threeBitsOffset);

  @override
  set twoBits(int v) =>
      value = (value & ~twoBitsMask) | ((v << twoBitsOffset) & twoBitsMask);

  @override
  set oneBit(int v) =>
      value = (value & ~oneBitMask) | ((v << oneBitOffset) & oneBitMask);

  @override
  set threeBits(int v) => value =
      (value & ~threeBitsMask) | ((v << threeBitsOffset) & threeBitsMask);
}

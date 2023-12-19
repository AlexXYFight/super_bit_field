<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

A bit field code generator base on super_annotation for dart.

## Getting started

First, add `super_annotations`, `super_bit_field` as dependencies, and `build_runner` as a dev_dependency.

```shell
pub add super_annotations super_bit_field
pub add --dev build_runner
```

> For every `pub` command prefix it with either `dart` or `flutter` depending on your project.

## Usage

Asume you have a dart file named `test_bit_field.dart` in your project. You can define a bit field class in it like this:

```dart
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
```

Then run `build_runner` to generate the part file.

```shell
pub run build_runner build
```

> For every `pub` command prefix it with either `dart` or `flutter` depending on your project.

The generated part file named `test_bit_field.g.dart` will be like this:

```dart
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
      _value = _hook.onGet!();
    }
    return _value;
  }

  @override
  set value(value) {
    _value = value;
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

```

Then you can operate the bit field in the class you defined.

```dart

void main() {
  var bitField = TestBitField(0);
  bitField.twoBits = 1;
  bitField.oneBit = 1;
  bitField.threeBits = 1;
  print(bitField.value.toRadixString(2));
  print(bitField.twoBits);
  print(bitField.oneBit);
  print(bitField.threeBits);
}

```

You can also opperate a external int value with a bit field object by using `GetSetHook`.

```dart
void main() {
    int value = 0;
    TestBitField testBitField = TestBitField(value, GetSetHook<int>(onSet: (int v) {
        value = v;
    }, onGet: () {
        return value;
    }));
    testBitField.twoBits = 2;
    print(value); // 2
    testBitField.oneBit = 1;
    print(value); // 6
    testBitField.threeBits = 5;
    print(value); // 46
}
```


import 'package:super_annotations/super_annotations.dart';

typedef BitFieldGen = CodeGen;

class Bits {
  final int range;
  const Bits(this.range);
}

class BitField extends ClassAnnotation {
  final int length;

  const BitField(this.length);

  @override
  void apply(Class target, LibraryBuilder output) {
    int offset = 0;
    if (length > 64) {
      throw Exception('BitField length must be <= 64');
    }
    Class cs = Class((b) => b
      ..name = '_${target.name}'
      ..implements.add(refer(target.name))
      ..fields.add(Field((b) => b
        ..name = 'length'
        ..type = refer('int')
        ..assignment = Code('$length')
        ..static = true
        ..modifier = FieldModifier.constant))
      ..fields.add(Field((b) => b
        ..name = 'musk'
        ..type = refer('int')
        ..assignment = const Code('((0x01 << length) - 1)')
        ..static = true
        ..modifier = FieldModifier.constant))
      ..fields.add(Field((b) => b
        ..name = '_value'
        ..type = refer('int')
        ..assignment = const Code('0')))
      ..fields.add(Field((b) => b
        ..name = '_hook'
        ..type = refer('GetSetHook<int>?')
        ..modifier = FieldModifier.final$))
      ..constructors.add(Constructor((b) => b
        ..requiredParameters.add(Parameter((b) => b
          ..name = 'value'
          ..type = refer('int')))
        ..optionalParameters.add(Parameter((b) => b
          ..name = 'hook'
          ..type = refer('GetSetHook<int>?')))
        ..initializers.add(const Code('_value = value'))
        ..initializers.add(const Code('_hook = hook'))))
      ..methods.add(Method((b) => b
        ..name = 'value'
        ..type = MethodType.getter
        ..returns = refer('int')
        ..annotations.add(refer('override'))
        ..body = const Code('''
          if(_hook != null && _hook.onGet != null) {
            _value = _hook.onGet!() & musk;
          }
          return _value & musk;
        ''')))
      ..methods.add(Method((b) => b
        ..name = 'value'
        ..type = MethodType.setter
        ..requiredParameters.add(Parameter((b) => b..name = 'value'))
        ..annotations.add(refer('override'))
        ..body = const Code('''
          _value = value & musk;
          if(_hook != null && _hook.onSet != null) {
            _hook.onSet!(_value);
          }
        ''')))
      ..fields.addAll(target.fields
          .where((b) => b.resolvedAnnotationsOfType<Bits>().length == 1)
          .map((e) {
        final List<Bits> bitsAnnotations = e.resolvedAnnotationsOfType<Bits>();
        final Bits bitsAnnotation = bitsAnnotations.first;
        final int bits = bitsAnnotation.range;
        return Field((b) {
          b
            ..name = '${e.name}Bits'
            ..type = refer('int')
            ..modifier = FieldModifier.constant
            ..assignment = Code('$bits')
            ..static = true;
        });
      }))
      ..fields.addAll(target.fields
          .where((b) => b.resolvedAnnotationsOfType<Bits>().length == 1)
          .map((e) {
        final List<Bits> bitsAnnotations = e.resolvedAnnotationsOfType<Bits>();
        final Bits bitsAnnotation = bitsAnnotations.first;
        final int bits = bitsAnnotation.range;
        var f = Field((b) {
          b
            ..name = '${e.name}Offset'
            ..type = refer('int')
            ..modifier = FieldModifier.constant
            ..assignment = Code('$offset')
            ..static = true;
        });
        offset += bits;
        return f;
      }))
      ..fields.addAll(target.fields
          .where((b) => b.resolvedAnnotationsOfType<Bits>().length == 1)
          .map((e) => Field((b) => b
            ..name = '${e.name}Mask'
            ..type = refer('int')
            ..modifier = FieldModifier.constant
            ..assignment =
                Code('((0x01 << ${e.name}Bits) - 1) << ${e.name}Offset')
            ..static = true)))
      ..methods.addAll(target.fields
          .where((b) => b.resolvedAnnotationsOfType<Bits>().length == 1)
          .map((e) => Method((b) => b
            ..name = e.name
            ..type = MethodType.getter
            ..returns = refer('int')
            ..lambda = true
            ..annotations.add(refer('override'))
            ..body = Code('((value & ${e.name}Mask) >> ${e.name}Offset)'))))
      ..methods.addAll(target.fields
          .where((b) => b.resolvedAnnotationsOfType<Bits>().length == 1)
          .map((e) => Method((b) => b
            ..name = e.name
            ..type = MethodType.setter
            ..requiredParameters.add(Parameter((b) => b
              ..name = 'v'
              ..type = refer('int')))
            ..lambda = true
            ..annotations.add(refer('override'))
            ..body = Code(
                'value = (value & ~${e.name}Mask) | ((v << ${e.name}Offset) & ${e.name}Mask)')))));
    output.body.add(cs);
  }
}

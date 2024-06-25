import 'dart:math';

class GenerateRandomAlias {
  String generateUUID() {
    final Random random = Random();

    String hexDigit(int value) => value.toRadixString(16).padLeft(2, '0');

    // Gera uma parte do UUID com a quantidade especificada de dígitos
    String generatePart(int length) =>
        List.generate(length, (_) => hexDigit(random.nextInt(256))).join('');

    // Gera as diferentes partes do UUID
    String part1 = generatePart(4);
    String part2 = generatePart(2);
    String part3 = '4${generatePart(1)}'; // Versão 4 do UUID
    String part4 = hexDigit((random.nextInt(16) & 0x3) | 0x8) +
        generatePart(1); // Varia entre 8, 9, A, ou B
    String part5 = generatePart(6);

    return '$part1$part2-$part2-$part3-$part4-$part5';
  }
}

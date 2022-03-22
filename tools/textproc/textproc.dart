import 'dart:convert';
import 'dart:io';

Future<int> main(List<String> args) async {
  if (args.length != 5) {
    print(
      'Usage : textproc [tbl 파일] [텍스트 디렉터리] [언어 키] [address] [출력 파일명]',
    );
    return -1;
  }

  final tableFile = File(args[0]);
  if (!await tableFile.exists()) {
    print(
      'tbl 파일이 존재하지 않습니다.\n'
      '(${args[0]})',
    );
    return -1;
  }

  final txtDirectoryFile = Directory(args[1]);
  if (!await txtDirectoryFile.exists()) {
    print(
      '경로가 존재하지 않습니다.\n'
      '(${args[1]})',
    );
    return -1;
  }

  // 테이블 로딩
  final characterTable = <String, int>{};
  for (final line in await tableFile.readAsLines()) {
    if (line.isEmpty) {
      continue;
    }

    // if (line.contains('\\')) {
    //   print(
    //     '"\\" 문자는 등록할 수 없습니다.\n'
    //     '($line)',
    //   );
    //   return -1;
    // }

    final keyValue = line.split('=');
    characterTable[keyValue[1]] = int.parse(keyValue[0], radix: 16);
  }

  // 변환 처리
  final generatedFile = File(args[4]);
  final generatedBuffer1 = StringBuffer();

  // 시작 텍스트
  final generatedBuffer2 = StringBuffer();
  generatedBuffer2.writeln('arch gba.thumb');
  generatedBuffer2.writeln('');
  generatedBuffer2.writeln(
    '////////////////////////////////////////////////////////////\n'
    '// 포인터 입력\n'
    '////////////////////////////////////////////////////////////',
  );

  int textIndex = int.parse(args[3], radix: 16);

  // 텍스트 시작 지점 입력
  generatedBuffer1.writeln(
    '\n'
    '\n'
    '////////////////////////////////////////////////////////////\n'
    '// 텍스트 입력\n'
    '////////////////////////////////////////////////////////////\n'
    'org \$${textIndex.toRadixString(16).padLeft(8, '0')}',
  );

  for (final entity in await txtDirectoryFile.list().toList()) {
    if (entity is File && entity.path.endsWith('.json')) {
      final source = await entity.readAsString();
      final json = jsonDecode(source);

      for (final item in json) {
        final text = item['text'][args[2]];
        final buffer = <int>[];
        for (var i = 0; i < text.length; i++) {
          final char = text[i];

          // 숫자 데이터 처리
          if (char == '\$' && text.length >= i + 1 && text[i + 1] == '[') {
            final tempNumberBuffer = StringBuffer();
            bool hasNumber = false;
            for (var j = 0; j < 5; j++) {
              if (text.length >= i + j + 2) {
                if (text[i + j + 2] == ']') {
                  hasNumber = true;
                  break;
                } else {
                  tempNumberBuffer.write(text[i + j + 2]);
                }
              }
            }

            if (hasNumber) {
              final number = int.tryParse(
                tempNumberBuffer.toString(),
                radix: 16,
              );
              if (number == null) {
                print(
                  '"$tempNumberBuffer"는 16진수가 아닙니다.\n'
                  '(${entity.path})',
                );
                return -1;
              }
              if (number > 0xff) {
                print(
                  '숫자는 0~255(ff) 사이의 값만 지정할 수 있습니다.\n'
                  '(${entity.path})',
                );
                return -1;
              }
              buffer.add(number);
              i += 2 + tempNumberBuffer.length;
              continue;
            }
          }

          final newValue = characterTable[char];
          if (newValue == null) {
            print(
              '"$char" 문자는 존재하지 않습니다.\n'
              '(${entity.path})',
            );
            return -1;
          }

          if (newValue >= 0x100) {
            buffer.add((newValue & 0xff00) >> 8);
            buffer.add(newValue & 0xff);
          } else {
            buffer.add(newValue);
          }
        }

        final pointer = (item['pointer'] as String).substring(2);
        final pointerLabel = 'text_$pointer';

        // 포인터 입력
        generatedBuffer2.writeln('org \$$pointer ; dd $pointerLabel');

        // 텍스트 입력
        generatedBuffer1.write('$pointerLabel: ; db');
        for (var j = 0; j < buffer.length; j++) {
          final b = buffer[j];
          generatedBuffer1.write(' \$${b.toRadixString(16).padLeft(2, '0')}');
          if (j < buffer.length - 1) {
            generatedBuffer1.write(',');
          }
        }
        generatedBuffer1.write('\n');

        textIndex += buffer.length;
      }
    }
  }

  await generatedFile.writeAsString('$generatedBuffer2$generatedBuffer1');

  return 0;
}

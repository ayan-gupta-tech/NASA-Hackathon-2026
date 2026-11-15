import 'package:flutter_test/flutter_test.dart';

import 'package:sarc/utils/format.dart';

void main() {
  test('formatDate gives day, month and year', () {
    expect(formatDate(DateTime(2023, 10, 4)), '4 Oct 2023');
  });
}

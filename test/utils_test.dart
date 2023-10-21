import 'package:flutter_test/flutter_test.dart';
import 'package:pegasus_tool/utils.dart';

void main() {
  test('format test', () async {
    // Arrange
    const value1 = 1000;
    const value2 = 100;
    const value3 = 10000000;

    // Act
    final result1 = format(value1);
    final result2 = format(value2);
    final result3 = format(value3);
    final result4 = format(null);

    // Assert
    expect(result1, "1,000");
    expect(result2, "100");
    expect(result3, "10,000,000");
    expect(result4, "");
  });

  test('getEnvironment test', () async {
    expect(getEnvironment(), "Mainnet");
  });
}

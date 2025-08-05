import 'package:flutter_test/flutter_test.dart';
import 'package:volley_rotation/business_logic/models/position.dart';

void main() {
  group('Position', () {
    test('should have correct properties', () {
      expect(Position.p1.number, equals(1));
      expect(Position.p1.shortName, equals('P1'));
      expect(Position.p1.description, equals('Back Right - Server'));
      expect(Position.p1.isServer, isTrue);
      expect(Position.p1.isBackRow, isTrue);
      expect(Position.p1.isFrontRow, isFalse);
    });

    test('should correctly identify back row positions', () {
      expect(Position.p1.isBackRow, isTrue);
      expect(Position.p5.isBackRow, isTrue);
      expect(Position.p6.isBackRow, isTrue);
      
      expect(Position.p2.isBackRow, isFalse);
      expect(Position.p3.isBackRow, isFalse);
      expect(Position.p4.isBackRow, isFalse);
    });

    test('should correctly identify front row positions', () {
      expect(Position.p2.isFrontRow, isTrue);
      expect(Position.p3.isFrontRow, isTrue);
      expect(Position.p4.isFrontRow, isTrue);
      
      expect(Position.p1.isFrontRow, isFalse);
      expect(Position.p5.isFrontRow, isFalse);
      expect(Position.p6.isFrontRow, isFalse);
    });

    test('should identify server position', () {
      expect(Position.p1.isServer, isTrue);
      
      for (final position in [Position.p2, Position.p3, Position.p4, Position.p5, Position.p6]) {
        expect(position.isServer, isFalse);
      }
    });

    test('fromNumber should return correct position', () {
      expect(Position.fromNumber(1), equals(Position.p1));
      expect(Position.fromNumber(2), equals(Position.p2));
      expect(Position.fromNumber(3), equals(Position.p3));
      expect(Position.fromNumber(4), equals(Position.p4));
      expect(Position.fromNumber(5), equals(Position.p5));
      expect(Position.fromNumber(6), equals(Position.p6));
    });

    test('fromNumber should throw for invalid numbers', () {
      expect(() => Position.fromNumber(0), throwsStateError);
      expect(() => Position.fromNumber(7), throwsStateError);
      expect(() => Position.fromNumber(-1), throwsStateError);
    });

    test('rotationOrder should be correct', () {
      final expected = [Position.p1, Position.p2, Position.p3, Position.p4, Position.p5, Position.p6];
      expect(Position.rotationOrder, equals(expected));
      expect(Position.rotationOrder.length, equals(6));
    });
  });
}
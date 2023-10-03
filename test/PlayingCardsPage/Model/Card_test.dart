import 'package:flutter_test/flutter_test.dart';
import 'package:high_and_low/PlayingCardsPage/Model/Card.dart';

void main() {
  Card _card;

  group('convert id to mark', () {
    void _testConvertIdToMark(int id, String correctMark) {
      _card = Card(id);
      expect(_card.mark(), correctMark);
    }

    test('for diamond', () {
      String _diamond = 'D';
      _testConvertIdToMark(0, _diamond);
      _testConvertIdToMark(12, _diamond);
    });
    test('for heart', () {
      String _heart = 'H';
      _testConvertIdToMark(13, _heart);
      _testConvertIdToMark(25, _heart);
    });
    test('for club', () {
      String _club = 'K';
      _testConvertIdToMark(26, _club);
      _testConvertIdToMark(38, _club);
    });
    test('for spade', () {
      String _spade = 'S';
      _testConvertIdToMark(39, _spade);
      _testConvertIdToMark(51, _spade);
    });
    test('for joker', () {
      String _joker = 'JOKER';
      _testConvertIdToMark(52, _joker);
      _testConvertIdToMark(53, _joker);
    });
    test('is fail', () {
      expect(() => Card(54), throwsA(TypeMatcher<ArgumentError>()));
      expect(() => Card(-1), throwsA(TypeMatcher<ArgumentError>()));
    });
  });

  group('convert id to number', () {
    void _testConvertIdToNumber(int id, int correctNumber) {
      _card = Card(id);
      expect(_card.number(), correctNumber);
    }

    test('is correct', () {
      _testConvertIdToNumber(0, 1);
      _testConvertIdToNumber(12, 13);
      _testConvertIdToNumber(13, 1);
      _testConvertIdToNumber(25, 13);
      _testConvertIdToNumber(26, 1);
      _testConvertIdToNumber(38, 13);
      _testConvertIdToNumber(39, 1);
      _testConvertIdToNumber(51, 13);
    });
  });
}

import 'dart:async';
import 'dart:math';

Future<void> streamWords(
    String inputText,
    int minChar,
    int errorTolerance,
    int wordLimit,
    List<String> combinedWords,
    StreamController<String> streamController) async {
  var chars = inputText;
  var evenPattern = "0";
  var oddPattern = "1";

  for (var i = minChar; i <= chars.length; i++) {
    if (combinedWords.length >= wordLimit) break;

    //Starts with vowel
    var types = StringBuffer();
    for (var j = 0; j < i; j++) {
      types.write(j.isEven ? evenPattern : oddPattern);
    }
    await generateByTypes(types, errorTolerance, combinedWords, wordLimit,
        chars, streamController);

    //Starts with consonant
    types = StringBuffer();
    for (var j = 0; j < i; j++) {
      types.write(j.isEven ? oddPattern : evenPattern);
    }
    await generateByTypes(types, errorTolerance, combinedWords, wordLimit,
        chars, streamController);
  }
}

int combinationTotal(int charTotal) {
  if (charTotal <= 0) {
    return 0;
  }
  var total = 1;
  for (var i = 1; i <= charTotal; i++) {
    total *= i;
  }
  return total;
}

Future<void> generateByTypes(
    StringBuffer types,
    int errorTolerance,
    List<String> combinedWords,
    int wordLimit,
    String chars,
    StreamController<String> streamController) async {
  var maxError = combinationTotal(
          types.toString().replaceAll(RegExp(r"[^012]"), "").length) *
      errorTolerance;
  var currentError = 0;

  while (currentError < maxError) {
    if (combinedWords.length >= wordLimit) break;
    var remainingConsonants =
        chars.split('').where((char) => !'AEIOUaeiou'.contains(char)).toList();
    var remainingVowels =
        chars.split('').where((char) => 'AEIOUaeiou'.contains(char)).toList();

    var generatedWord = '';
    for (var type in types.toString().split('')) {
      if (combinedWords.length >= wordLimit) break;
      if (type != '0' && type != '1' && type != '2') {
        generatedWord += type;
        if (remainingConsonants.contains(type)) {
          remainingConsonants.remove(type);
        } else if (remainingVowels.contains(type)) {
          remainingVowels.remove(type);
        }
        continue;
      }

      String? randomChar;
      if (type == '0') {
        if (remainingVowels.isEmpty) {
          currentError++;
          continue;
        }
        randomChar =
            remainingVowels.removeAt(Random().nextInt(remainingVowels.length));
      } else if (type == '1') {
        if (remainingConsonants.isEmpty) {
          currentError++;
          continue;
        }
        randomChar = remainingConsonants
            .removeAt(Random().nextInt(remainingConsonants.length));
      } else {
        List<String> randomList;
        if (Random().nextBool()) {
          randomList = remainingVowels;
        } else {
          randomList = remainingConsonants;
        }

        if (randomList.isEmpty) {
          if (remainingVowels.isNotEmpty) {
            randomList = remainingVowels;
          } else if (remainingConsonants.isNotEmpty) {
            randomList = remainingConsonants;
          } else {
            currentError++;
            continue;
          }
        }

        randomChar = randomList.removeAt(Random().nextInt(randomList.length));
      }

      generatedWord += randomChar;
    }

    if (!combinedWords.contains(generatedWord)) {
      await Future.delayed(const Duration(milliseconds: 1));
      combinedWords.add(generatedWord);

      // Sort the list by character length first
      combinedWords.sort((a, b) {
        if (a.length != b.length) {
          return a.length - b.length;
        }
        return a.compareTo(b); // If lengths are the same, sort alphabetically
      });

      streamController.sink.add(generatedWord);

      currentError = 0;
    } else {
      currentError++;
    }
  }
}

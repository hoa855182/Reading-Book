extension StringExtension on String? {
  String? get titleEachWord {
    if (this == null) {
      return null;
    }

    if (this!.length <= 1) {
      return this!.toUpperCase();
    }

    final List<String> words = this!.split(' ');

    // Capitalize first letter of each words
    final capitalizedWords = words.map((word) {
      if (word.trim().isNotEmpty) {
        final String firstLetter = word.trim().substring(0, 1).toUpperCase();
        final String remainingLetters = word.trim().substring(1).toLowerCase();

        return '$firstLetter$remainingLetters';
      }
      return '';
    });

    return capitalizedWords.join(' ');
  }
}

import 'string_validator.dart';

class RegexValidator implements StringValidator {
  RegexValidator({required this.regex});
  final RegExp? regex;

  /// value: the input string
  /// returns: true if the input string is a full match for regexSource
  @override
  bool isValid(String value) {
    if (regex != null) {
      try {
        final matches = regex!.allMatches(value);
        for (Match match in matches) {
          if (match.start == 0 && match.end == value.length) {
            return true;
          }
        }
        return false;
      } catch (e) {
        // Invalid regex
        assert(false, e.toString());
        return true;
      }
    } else {
      return true;
    }
  }
}

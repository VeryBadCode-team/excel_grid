import 'package:csv/csv.dart';

class CsvParser {
  static List<List<dynamic>> fromCsv(String text, {String seperator = ','}) {
    List<List<dynamic>> result = const CsvToListConverter().convert(
      text,
      fieldDelimiter: seperator,
      eol: '\n',
    );
    return result;
  }

  static String toCsv(List<List<String>> lines, {String seperator = ','}) {
    return const ListToCsvConverter().convert(
      lines,
      fieldDelimiter: seperator,
      eol: '\n',
    );
  }
}

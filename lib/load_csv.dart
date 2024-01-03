import 'package:csv/csv.dart';

import 'package:final_project_class_open/schedule.dart';

List<List<dynamic>> getListFromCsv() {
  final csvFile = getSchedule();
  return const CsvToListConverter(fieldDelimiter: ',', eol: '\n')
      .convert(csvFile)
      .toList();
}

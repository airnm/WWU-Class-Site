import 'dart:math';
import 'package:flutter/material.dart';
import 'package:final_project_class_open/class.dart';
import 'package:final_project_class_open/department.dart';
import 'package:final_project_class_open/subject.dart';
import 'package:final_project_class_open/term.dart';
import 'package:final_project_class_open/query.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Class Schedule',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF038D07)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Department _department = Department.allDepartments();
  Subject _subject = Subject.allSubjects();
  Term _term = Term.allTerms();
  int lineHeight = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 1200) {
            return wideLayout();
          } else if (constraints.maxWidth > 800) {
            return mediumLayout();
          } else if (constraints.maxWidth > 615) {
            return narrowLayout();
          } else {
            return const Center(
              child: Text('Minimum screed width is 615 px!'),
            );
          }
        },
      ),
    );
  }
  // change build context ^^
  // add narrow layout
      
     AppBar navBar(BuildContext context) {
     return AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Center(
          child: Text(
            'WWU Class Schedule',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
}
  Widget narrowLayout() {
    return Scaffold(
      appBar: navBar(context),
      drawer: drawer(),
      body: narrowResults(),
    );
  }

  Widget drawer() {
    return NavigationDrawer(
      children: [
        departmentDropdown(),
        subjectDropdown(),
        termDropdown(),
        const AboutListTile(
          applicationIcon: Icon(Icons.calendar_month),
          applicationName: 'WWU Class Schedule',
        ),
      ],
    );
  }

  Widget mediumLayout() {
    return Column(
      children: [
        navBar(context),
        searchCriteria(),
        mediumHeaderRow(),
        Expanded(child: mediumResults()),
      ],
    );
  }

  Widget wideLayout() {
    return Column(
      children: [
        navBar(context),
        searchCriteria(),
        wideHeaderRow(),
        Expanded(child: wideResults()),
      ],
    );
  }

  Widget mediumHeaderRow() {
    return Row(
       children: [
        Container(
          padding: const EdgeInsets.all(1.0),
          decoration: BoxDecoration(border: Border.all(width: 1.0)),
          child: Column(
      children: [
        Row(
          children: [
            cell(width: 55, foreground: Colors.white, text: 'Sub'),
            cell(width: 60, foreground: Colors.white, text: 'Sum 23'),
            cell(width: 60, foreground: Colors.white, text: 'Aut 23'),
            cell(width: 60, foreground: Colors.white, text: 'Wtr 24'),
            cell(width: 60, foreground: Colors.white, text: 'Spr 24'),
            cell(width: 60, foreground: Colors.white, text: 'Sum 24'),
            cell(width: 35, foreground: Colors.white, text: 'Sec'),
            cell(width: 30, foreground: Colors.white, text: 'GS'),
            cell(width: 30, foreground: Colors.white, text: 'Cr'),
            cell(
              width: 150,
              foreground: Colors.white,
              text: 'Meeting Time',
              alignment: Alignment.center,
            ),
          ],
        ),
        Row(
          children: [
            cell(width: 300, foreground: Colors.white, text: 'Course Title'),
            cell(width: 200, foreground: Colors.white, text: 'Instructor'),
            cell(width: 109, foreground: Colors.white, text: 'Campus'),
                ],
              ),            
            ],
          ),
        ),
      ],
    );
  }

  Widget wideHeaderRow() {
    return Row(
      children: [
        cell(width: 55, foreground: Colors.white, text: 'Sub'),
        cell(width: 60, foreground: Colors.white, text: 'Sum 23'),
        cell(width: 60, foreground: Colors.white, text: 'Aut 23'),
        cell(width: 60, foreground: Colors.white, text: 'Wtr 24'),
        cell(width: 60, foreground: Colors.white, text: 'Spr 24'),
        cell(width: 60, foreground: Colors.white, text: 'Sum 24'),
        cell(width: 35, foreground: Colors.white, text: 'Sec'),
        cell(width: 30, foreground: Colors.white, text: 'GS'),
        cell(width: 30, foreground: Colors.white, text: 'Cr'),
        cell(width: 300, foreground: Colors.white, text: 'Course Title'),
        cell(
          width: 150,
          foreground: Colors.white,
          text: 'Meeting Time',
          alignment: Alignment.center,
        ),
        cell(width: 200, foreground: Colors.white, text: 'Instructor'),
        cell(width: 60, foreground: Colors.white, text: 'Campus'),
      ],
    );
  }

  Container cell({
    required double width,
    required String text,
    Color background = const Color.fromRGBO(51, 102, 153, 1),
    Color foreground = Colors.black,
    Alignment alignment = Alignment.center,
  }) {
    return Container(
      alignment: alignment,
      width: width,
      margin: const EdgeInsets.all(0.5),
      padding: const EdgeInsets.symmetric(horizontal: 0.5),
      color: background,
      child: Text(
        addLines(text),
        style: TextStyle(color: foreground),
      ),
    );
  }

  Widget departmentDropdown() {
    final entries = <DropdownMenuEntry>[];
    for (final element in Department.instances) {
      entries.add(
        DropdownMenuEntry(
          value: element,
          label: element.toString(),
          ),
        );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownMenu(
        key: const Key('myDropdownMenu'),
        dropdownMenuEntries: entries,
        label: const Text('Department'),
        onSelected: (value) {
          setState(() {
            _department = value;
          });
        },
      ),
    );
  }

  Widget subjectDropdown() {
    final entries = <DropdownMenuEntry>[];
    for (final element in Subject.instances) {
      entries.add(DropdownMenuEntry(value: element, label: element.name));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownMenu(
        key: const Key('subjectDropdownMenu'),
        dropdownMenuEntries: entries,
        label: const Text('Subject'),
        onSelected: (value) {
          setState(() {
            _subject = value;
          });
        },
      ),
    );
  }

  Widget termDropdown() {
    final entries = <DropdownMenuEntry>[];
    for (final element in Term.instances) {
      entries.add(DropdownMenuEntry(value: element, label: element.name));
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownMenu(
        key: const Key('termDropdownMenu'),
        dropdownMenuEntries: entries,
        label: const Text('Term'),
        onSelected: (value) {
          setState(() {
            _term = value;
          });
        },
      ),
    );
  }

  Widget searchCriteria() {
    return ColoredBox(
      color: const Color.fromRGBO(160, 173, 159, 1),
      child: Wrap(
        children: [
          departmentDropdown(),
          subjectDropdown(),
          termDropdown(),
        ],
      ),
    );
  }

  String addLines(String input) {
    final int found = input.split('\n').length;
    var result = input;
    for (int i = found; i < lineHeight; ++i) {
      result += '\n';
    }
    return result;
  }

  Widget wideClassRow(Class aClass, bool isEven) {
    final background = isEven
        ? const Color.fromRGBO(194, 194, 194, 1)
        : const Color.fromRGBO(219, 219, 219, 1);
    lineHeight = max(
      aClass.schedule.toString().split('\n').length,
      aClass.instructors.length,
    );
    return Row(
      children: [
        cell(
          width: 55,
          background: background,
          text: aClass.course.subject!.code,
        ),
        cell(
          width: 60,
          background: const Color.fromRGBO(241, 242, 118, 1),
          text: aClass.term.name == 'Summer 2023' ? aClass.course.number : '',
        ),
        cell(
          width: 60,
          background: const Color.fromRGBO(242, 182, 0, 1),
          text: aClass.term.name == 'Fall 2023' ? aClass.course.number : '',
        ),
        cell(
          width: 60,
          background: const Color.fromRGBO(140, 162, 189, 1),
          text: aClass.term.name == 'Winter 2024' ? aClass.course.number : '',
        ),
        cell(
          width: 60,
          background: const Color.fromRGBO(83, 181, 115, 1),
          text: aClass.term.name == 'Spring 2024' ? aClass.course.number : '',
        ),
        cell(
          width: 60,
          background: const Color.fromRGBO(241, 242, 118, 1),
          text: aClass.term.name == 'Summer 2024' ? aClass.course.number : '',
        ),
        cell(
          width: 35,
          background: background,
          text: aClass.section,
        ),
        cell(
          width: 30,
          background: background,
          text: aClass.course.isGeneralStudies ? 'GS' : '',
        ),
        cell(
          width: 30,
          background: background,
          text: aClass.course.credits.toString(),
        ),
        cell(
          width: 300,
          background: background,
          text: aClass.course.title.toString(),
          alignment: Alignment.centerLeft,
        ),
        cell(
          width: 150,
          background: background,
          text: aClass.schedule.toString(),
          alignment: Alignment.centerRight,
        ),
        cell(
          width: 200,
          background: background,
          text: aClass.instructors.join('\n'),
          alignment: Alignment.centerLeft,
        ),
        cell(
          width: 60,
          background: background,
          text: aClass.campus.code.toString(),
        ),
      ],
    );
  }

  Widget mediumClassRow(Class aClass, bool isEven) {
    final background = isEven
        ? const Color.fromRGBO(194, 194, 194, 1)
        : const Color.fromRGBO(219, 219, 219, 1);
    lineHeight = max(
      aClass.schedule.toString().split('\n').length,
      aClass.instructors.length,
    );
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(1.0),
          decoration: BoxDecoration(border: Border.all(width: 1.0)),
          child: Column(
      children: [
        Row(
          children: [
            cell(
              width: 55,
              background: background,
              text: aClass.course.subject!.code,
            ),
            cell(
              width: 60,
              background: const Color.fromRGBO(241, 242, 118, 1),
              text:
                  aClass.term.name == 'Summer 2023' ? aClass.course.number : '',
            ),
            cell(
              width: 60,
              background: const Color.fromRGBO(242, 182, 0, 1),
              text: aClass.term.name == 'Fall 2023' ? aClass.course.number : '',
            ),
            cell(
              width: 60,
              background: const Color.fromRGBO(140, 162, 189, 1),
              text:
                  aClass.term.name == 'Winter 2024' ? aClass.course.number : '',
            ),
            cell(
              width: 60,
              background: const Color.fromRGBO(83, 181, 115, 1),
              text:
                  aClass.term.name == 'Spring 2024' ? aClass.course.number : '',
            ),
            cell(
              width: 60,
              background: const Color.fromRGBO(241, 242, 118, 1),
              text:
                  aClass.term.name == 'Summer 2024' ? aClass.course.number : '',
            ),
            cell(
              width: 35,
              background: background,
              text: aClass.section,
            ),
            cell(
              width: 30,
              background: background,
              text: aClass.course.isGeneralStudies ? 'GS' : '',
            ),
            cell(
              width: 30,
              background: background,
              text: aClass.course.credits.toString(),
            ),
            cell(
              width: 150,
              background: background,
              text: aClass.schedule.toString(),
            ),
          ],
        ),
        Row(
          children: [
            cell(
              width: 300,
              background: background,
              text: aClass.course.title.toString(),
            ),
            cell(
              width: 200,
              background: background,
              text: aClass.instructors.join('\n'),
            ),
            cell(
              width: 109,
              background: background,
              text: aClass.campus.code.toString(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // add narrow class row 
  Widget narrowClassRow(Class aClass, bool isEven) {
    final background = isEven
        ? const Color.fromRGBO(194, 194, 194, 1)
        : const Color.fromRGBO(219, 219, 219, 1);
    lineHeight = aClass.schedule.toString().split('\n').length;
    return Row(
      children: [
      Tooltip(
        message: '${aClass.course.subject!.code} ${aClass.course.number}'
            ' ${aClass.section}'
            ' ${aClass.course.isGeneralStudies ? 'GS' : ''}'
            ' - ${aClass.term.name} - ${aClass.course.credits}'
            ' - ${aClass.instructors.join(', ')}'
            ' - ${aClass.campus.name}',
        child: Row( 
            children: [
            cell(
              width: 55,
              background: background,
              text: aClass.course.subject!.code,
            ),
            cell(
              width: 60,
              background: const Color.fromRGBO(241, 242, 118, 1),
              text:
                  aClass.term.name == 'Summer 2023' ? aClass.course.number : '',
            ),
            cell(
              width: 60,
              background: const Color.fromRGBO(242, 182, 0, 1),
              text: aClass.term.name == 'Fall 2023' ? aClass.course.number : '',
            ),
            cell(
              width: 60,
              background: const Color.fromRGBO(140, 162, 189, 1),
              text:
                  aClass.term.name == 'Winter 2024' ? aClass.course.number : '',
            ),
            cell(
              width: 60,
              background: const Color.fromRGBO(83, 181, 115, 1),
              text:
                  aClass.term.name == 'Spring 2024' ? aClass.course.number : '',
            ),
            cell(
              width: 60,
              background: const Color.fromRGBO(241, 242, 118, 1),
              text:
                  aClass.term.name == 'Summer 2024' ? aClass.course.number : '',
            ),
            cell(
              width: 35,
              background: background,
              text: aClass.section,
            ),
            cell(
              width: 35,
              background: background,
              text: aClass.course.isGeneralStudies ? 'GS' : '',
            ),
            cell(
              width: 30,
              background: background,
              text: aClass.course.credits.toString(),
            ),
            cell(
              width: 150,
              background: background,
              text: aClass.schedule.toString(),
              ),
            ],
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }

  Widget wideResults() {
    final classes =
        Query(department: _department, subject: _subject, term: _term)
            .results()
            .toList();
    classes.sort();
    return ListView.builder(
      itemCount: classes.length,
      itemBuilder: (context, index) =>
          wideClassRow(classes[index], index % 2 == 0),
    );
  }

  Widget mediumResults() {
    final classes =
        Query(department: _department, subject: _subject, term: _term)
            .results()
            .toList();
    classes.sort();
    return ListView.builder(
      itemCount: classes.length,
      itemBuilder: (context, index) =>
          mediumClassRow(classes[index], index % 2 == 0),
    );
  }
  
  // add narrow results 
  Widget narrowResults() {
        final classes =
        Query(department: _department, subject: _subject, term: _term)
            .results()
            .toList();
    classes.sort();
    return ListView.builder(
      itemCount: classes.length,
      itemBuilder: (context, index) =>
          narrowClassRow(classes[index], index % 2 == 0),
    );
  }
}

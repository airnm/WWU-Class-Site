import 'package:final_project_class_open/campus.dart';
import 'package:final_project_class_open/course.dart';
import 'package:final_project_class_open/term.dart';
import 'package:final_project_class_open/instructor.dart';
import 'package:final_project_class_open/load_csv.dart';
import 'package:final_project_class_open/meeting_time.dart';

class Class implements Comparable<Class> {
  Class(
    this.course,
    this.term,
    this.maxEnrollment,
    this.schedule,
    this.classroom,
    this.instructors,
    this.campus, [
    this.video = '',
    this.consent = '',
    this.specialNotes = '',
    this.fee = 0,
    this.currEnrollment = 0,
    this.waitlist = 0,
    this.section = 'A',
    this.isOpenForEnrollment = true,
    this.isSaved = false,
  ]);

  Course course;
  Term term;
  String section;
  int maxEnrollment;
  int currEnrollment;
  bool isOpenForEnrollment;
  int waitlist;
  int fee;
  MeetingTime schedule;
  String classroom;
  Set<Instructor> instructors;
  Campus campus;
  String video;
  String consent;
  String specialNotes;
  bool isSaved;

  static final _instances = <Class>{};

  static Set<Class> get instances {
    if (_instances.isEmpty) {
      Class._initialize();
    }
    return _instances;
  }

  static void _initialize() {
    Course.getAllCourses();
    final classListFromCsv = getListFromCsv();
    classListFromCsv.removeAt(0);
    for (final listing in classListFromCsv) {
      final Course currCourse =
          Course.instances.firstWhere((each) => each.title == listing[14]);
      final Set<Instructor> currInstructors = Instructor.instances
          .where((each) => listing[23].contains(each.name))
          .toSet();
      final Campus currCampus =
          Campus.instances.firstWhere((each) => each.code == listing[1]);
      var termYear = (listing[2] / 1000).truncate().toString() +
          (listing[2] % 2000).toString();
      var termMonth = '';
      var termFound = '';
      for (int i = 8; i <= 12; i++) {
        termFound = listing[i].toString();
        if (termFound != '') {
          if (i <= 9) {
            termYear = (int.parse(termYear) - 1).toString();
          }
          if (i == 9) {
            termMonth = '9';
          } else if (i == 10) {
            termMonth = '1';
          } else if (i == 11) {
            termMonth = '3';
          } else {
            termMonth = '6';
          }
          break;
        }
      }
      final termCode = int.parse(termYear + termMonth);
      final Term currTerm =
          Term.instances.firstWhere((each) => each.code == termCode);
      _instances.add(
        Class(
          currCourse,
          currTerm,
          listing[18],
          MeetingTime.fromString(listing[21]), // schedule
          listing[22],
          currInstructors,
          currCampus,
        ),
      );
    }
  }

  void changeEnrollmentStatus() {
    isOpenForEnrollment = !isOpenForEnrollment;
  }

  void updateWaitlist(String updateType) {
    if (updateType == 'add') {
      waitlist = waitlist + 1;
    } else if (updateType == 'drop' && waitlist > 0) {
      waitlist = waitlist - 1;
    } else {
      throw 'waitlist out of bounds';
    }
  }

  @override
  int compareTo(Class other) {
    final aString =
        '${course.subject!.code} ${course.number} ${term.code} $section';
    final bSrting =
        '${other.course.subject!.code} ${other.course.number} ${other.term.code} ${other.section}';
    return aString.compareTo(bSrting);
  }
}

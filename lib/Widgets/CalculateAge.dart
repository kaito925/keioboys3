import 'package:cloud_firestore/cloud_firestore.dart';

int calculateAge(Timestamp birthday) {
  int age = DateTime.now().year - birthday.toDate().year;
  if ((DateTime.now().month - birthday.toDate().month) > 0) {
  } else if (DateTime.now().month - birthday.toDate().month < 0) {
    age = age - 1;
  } else {
    if (DateTime.now().day - birthday.toDate().day >= 0) {
    } else {
      age = age - 1;
    }
  }
  return age;
}

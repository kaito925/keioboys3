//著作ok

import 'package:cloud_functions/cloud_functions.dart';
import 'package:Keioboys/FB/MessageFB.dart';
import 'package:Keioboys/Widgets/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchNewFB {
  final FirebaseFirestore _fireStore;

  SearchNewFB({
    FirebaseFirestore fireStore,
  }) : _fireStore = fireStore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot> getUserList(interestedGender) {
    List interestedGenderList = [];
    if (interestedGender == "みんな") {
      interestedGenderList = ["男性", "女性"];
    } else {
      interestedGenderList.add(interestedGender);
    }
    return _fireStore
        .collection('users')
        .where(
          'visible',
          isEqualTo: true,
        )
        .where('gender', whereIn: interestedGenderList)
        .orderBy('lastCheckedNotificationTime', descending: true)
        .limit(50)
        .snapshots();
  }

  Future<UserData> getUserDetails({userId, decision}) async {
    UserData _user = UserData();

    await _fireStore.collection('users').doc(userId).get().then((user) {
      _user.uid = user.id;
      _user.token = user['token'];
      _user.name = user['name'];
      _user.birthday = user['birthday'];
      _user.gender = user['gender'];
      _user.interestedGender = user['interestedGender'];
      _user.profile = user['profile'];
      _user.school = user['school'];
      _user.company = user['company'];
      _user.location = user['location'];
      _user.city = user['city'];
      _user.photo1 = user['photo1'];
      _user.photo2 = user['photo2'];
      _user.photo3 = user['photo3'];
      _user.photo4 = user['photo4'];
      _user.photo5 = user['photo5'];
      _user.photo6 = user['photo6'];
      _user.decision = decision;
    });
    return _user;
  }
}

//著作ok

import 'package:cloud_functions/cloud_functions.dart';
import 'package:Keioboys/FB/MessageFB.dart';
import 'package:Keioboys/Widgets/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchFB {
  final FirebaseFirestore _fireStore;
  MessageFB _messageFB = MessageFB();
//  final CloudFunctions cf = CloudFunctions(region: 'asia-northeast1');

  MatchFB({
    FirebaseFirestore fireStore,
  }) : _fireStore = fireStore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMatchList(userId) {
    return _fireStore
        .collection('users')
        .doc(userId)
        .collection('matchList')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<DocumentSnapshot> getAgeVerification(userId) {
    return _fireStore.collection('users').doc(userId).snapshots();
  }

  Stream<QuerySnapshot> getLikedList(userId) {
    return _fireStore
        .collection('users')
        .doc(userId)
        .collection('likedList')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getSuperLikedList(userId) {
    return _fireStore
        .collection('users')
        .doc(userId)
        .collection('superLikedList')
        .orderBy('timestamp', descending: true)
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

//  Future goMessage({currentUserId, thisUserId}) async {
//    _fireStore
//        .collection('users')
//        .document(currentUserId)
//        .collection('messagingList')
//        .document(thisUserId)
//        .setData({
//      'timestamp': DateTime.now(),
//    });
//    _fireStore
//        .collection('users')
//        .document(thisUserId)
//        .collection('messagingList')
//        .document(currentUserId)
//        .setData({
//      'timestamp': DateTime.now(),
//    });
//    _fireStore
//        .collection('users')
//        .document(currentUserId)
//        .collection('matchList')
//        .document(thisUserId)
//        .delete();
//    _fireStore
//        .collection('users')
//        .document(thisUserId)
//        .collection('matchList')
//        .document(currentUserId)
//        .delete();
//  }

  Future acceptUser({
    currentUser,
    selectedUser,
    currentUserDecision,
    selectedUserDecision,
  }) async {
    int matchCountLikedIAcceptLike;
    int matchCountLikedIAcceptSuperLike;
    int matchCountLikedIAccept;

    int matchCountSuperLikedIAcceptLike;
    int matchCountSuperLikedIAcceptSuperLike;
    int matchCountSuperLikedIAccept;

    int matchCountILikeAcceptLiked;
    int matchCountILikeAcceptSuperLiked;
    int matchCountILikeAccepted;

    int matchCountISuperLikeAcceptLiked;
    int matchCountISuperLikeAcceptSuperLiked;
    int matchCountISuperLikeAccepted;

    String token;
    String email;

//    final HttpsCallable sendNotification = cf.getHttpsCallable(
//      functionName: 'sendToDevice',
//    );

    final functions = FirebaseFunctions.instanceFor(region: 'asia-northeast1');
    final HttpsCallable sendNotification = functions.httpsCallable(
      'sendToDevice',
    );
    final HttpsCallable sendEmail = functions.httpsCallable(
      'sendEmail',
    );

    if (token == null) {
      token = await _messageFB.getToken(
        userId: selectedUser.uid,
      );
    }

    if (token != '' && token != 'web') {
      final HttpsCallableResult result = await sendNotification.call({
        'token': token,
        'sender': currentUser.name,
        'message': '新しくマッチしました！'
      });
    } else {
      if (email == null) {
        email = await _messageFB.getEmail(
          userId: selectedUser.uid,
        );
      }
      var messageHtml = '''<div>
                          <p>${selectedUser.name}さん</p>
                          <p>${currentUser.name}さんと新しくマッチしました。<br>早速メッセージを送りましょう！</p>
                          <br>
                          <br>
                          <body style="text-align: center">
                            <a href="https://keioboys.page.link/m" 
                            style="border-radius: 5px;
                            background-color: #fa196e;
                            padding: 15px;
                            text-decoration: none;
                            color: white;
                            ">今すぐメッセージ</a>
                          </body>
                          </div>''';
      print('email: $email');
      final HttpsCallableResult result = await sendEmail.call({
        'email': '$email',
        'subject': '【Keioboys】 新しいマッチのお知らせ',
        'html': messageHtml,
      });
    }

    _fireStore
        .collection('users')
        .doc(currentUser.uid)
        .collection('matchList')
        .doc(selectedUser.uid)
        .set(
      {
        'name': selectedUser.name,
        'birthday': selectedUser.birthday,
        'photo1': selectedUser.photo1,
        'currentUserDecision': currentUserDecision,
        'selectedUserDecision': selectedUserDecision,
        'timestamp': FieldValue.serverTimestamp(),
      },
    );
    _fireStore
        .collection('users')
        .doc(selectedUser.uid)
        .collection('matchList')
        .doc(currentUser.uid)
        .set(
      {
        'name': currentUser.name,
        'birthday': currentUser.birthday,
        'photo1': currentUser.photo1,
        'currentUserDecision': selectedUserDecision,
        'selectedUserDecision': currentUserDecision,
        'timestamp': FieldValue.serverTimestamp(),
      },
    );

    if (selectedUserDecision == 'like' && currentUserDecision == 'acceptLike') {
      deleteLikedUser(
        currentUser.uid,
        selectedUser.uid,
      );

      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        matchCountLikedIAcceptLike = count['matchCountLikedIAcceptLike'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'matchCountLikedIAcceptLike': matchCountLikedIAcceptLike + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        matchCountILikeAcceptLiked = count['matchCountILikeAcceptLiked'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUser.uId)
          .collection('countList')
          .doc('counts')
          .update({
        'matchCountILikeAcceptLiked': matchCountILikeAcceptLiked + 1,
      });
    } else if (selectedUserDecision == 'like' &&
        currentUserDecision == 'acceptSuperLike') {
      deleteLikedUser(
        currentUser.uid,
        selectedUser.uid,
      );

      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        matchCountLikedIAcceptSuperLike =
            count['matchCountLikedIAcceptSuperLike'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'matchCountLikedIAcceptSuperLike': matchCountLikedIAcceptSuperLike + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUser.uId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        matchCountILikeAcceptSuperLiked =
            count['matchCountILikeAcceptSuperLiked'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUser.uId)
          .collection('countList')
          .doc('counts')
          .update({
        'matchCountILikeAcceptSuperLiked': matchCountILikeAcceptSuperLiked + 1,
      });
    } else if (selectedUserDecision == 'like' &&
        currentUserDecision == 'accept') {
      deleteLikedUser(
        currentUser.uid,
        selectedUser.uid,
      );

      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        matchCountLikedIAccept = count['matchCountLikedIAccept'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'matchCountLikedIAccept': matchCountLikedIAccept + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        matchCountILikeAccepted = count['matchCountILikeAccepted'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'matchCountILikeAccepted': matchCountILikeAccepted + 1,
      });
    } else if (selectedUserDecision == 'superLike' &&
        currentUserDecision == 'acceptLike') {
      deleteSuperLikedUser(
        currentUser.uid,
        selectedUser.uid,
      );

      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        matchCountSuperLikedIAcceptLike =
            count['matchCountSuperLikedIAcceptLike'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'matchCountSuperLikedIAcceptLike': matchCountSuperLikedIAcceptLike + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUser.uId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        matchCountISuperLikeAcceptLiked =
            count['matchCountISuperLikeAcceptLiked'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUser.uId)
          .collection('countList')
          .doc('counts')
          .update({
        'matchCountISuperLikeAcceptLiked': matchCountISuperLikeAcceptLiked + 1,
      });
    } else if (selectedUserDecision == 'superLike' &&
        currentUserDecision == 'acceptSuperLike') {
      deleteSuperLikedUser(
        currentUser.uid,
        selectedUser.uid,
      );

      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        matchCountSuperLikedIAcceptSuperLike =
            count['matchCountSuperLikedIAcceptSuperLike'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'matchCountSuperLikedIAcceptSuperLike':
            matchCountSuperLikedIAcceptSuperLike + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUser.uId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        matchCountISuperLikeAcceptSuperLiked =
            count['matchCountISuperLikeAcceptSuperLiked'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUser.uId)
          .collection('countList')
          .doc('counts')
          .update({
        'matchCountISuperLikeAcceptSuperLiked':
            matchCountISuperLikeAcceptSuperLiked + 1,
      });
    } else if (selectedUserDecision == 'superLike' &&
        currentUserDecision == 'accept') {
      deleteSuperLikedUser(
        currentUser.uid,
        selectedUser.uid,
      );

      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        matchCountSuperLikedIAccept = count['matchCountSuperLikedIAccept'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'matchCountSuperLikedIAccept': matchCountSuperLikedIAccept + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUser.uId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        matchCountISuperLikeAccepted = count['matchCountISuperLikeAccepted'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUser.uId)
          .collection('countList')
          .doc('counts')
          .update({
        'matchCountISuperLikeAccepted': matchCountISuperLikeAccepted + 1,
      });
    }

//    return
//      await _fireStore
//        .collection('users')
//        .document(selectedUserId)
//        .collection('matchedlist')
//        .document(currentUserId)
//        .setData({
//      'name': currentUserName,
//      'photo': currentUserPhotoUrl,
//    });
  }

  Future notAcceptUser({
    currentUser,
    selectedUser,
    selectedUserDecision,
  }) async {
    int notAcceptCountLiked;
    int notAcceptCountSuperLiked;
    int notAcceptedCountILike;
    int notAcceptedCountISuperLike;

    if (selectedUserDecision == 'like') {
      deleteLikedUser(
        currentUser.uid,
        selectedUser.uid,
      );

      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        notAcceptCountLiked = count['notAcceptCountLiked'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'notAcceptCountLiked': notAcceptCountLiked + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        notAcceptedCountILike = count['notAcceptedCountILike'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'notAcceptedCountILike': notAcceptedCountILike + 1,
      });
    } else {
      deleteSuperLikedUser(
        currentUser.uid,
        selectedUser.uid,
      );

      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        notAcceptCountSuperLiked = count['notAcceptCountSuperLiked'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'notAcceptCountSuperLiked': notAcceptCountSuperLiked + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUser.uId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        notAcceptedCountISuperLike = count['notAcceptedCountISuperLike'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'notAcceptedCountISuperLike': notAcceptedCountISuperLike + 1,
      });
    }

//    return
//      await _fireStore
//        .collection('users')
//        .document(selectedUserId)
//        .collection('matchedlist')
//        .document(currentUserId)
//        .setData({
//      'name': currentUserName,
//      'photo': currentUserPhotoUrl,
//    });
  }

  void deleteLikedUser(currentUserId, likedUserId) async {
    _fireStore
        .collection('users')
        .doc(currentUserId)
        .collection('likedList')
        .doc(likedUserId)
        .delete();

    _fireStore
        .collection('users')
        .doc(likedUserId)
        .collection('iLikeList')
        .doc(currentUserId)
        .delete();
  }

  void deleteSuperLikedUser(currentUserId, superLikedUserId) async {
    _fireStore
        .collection('users')
        .doc(currentUserId)
        .collection('superLikedList')
        .doc(superLikedUserId)
        .delete();

    _fireStore
        .collection('users')
        .doc(superLikedUserId)
        .collection('iSuperLikeList')
        .doc(currentUserId)
        .delete();
  }
}

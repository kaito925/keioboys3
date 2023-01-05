//著作権ok

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:google_geocoding/google_geocoding.dart' as geocoder;
import 'package:Keioboys/Widgets/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:geocoder/geocoder.dart';
//import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import 'package:location/location.dart';

import 'package:Keioboys/consts.dart';

class UserFB {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _fireStore;
  final FirebaseStorage _fireStorage;

  UserFB({
    FirebaseAuth firebaseAuth,
    FirebaseFirestore fireStore,
    FirebaseFirestore firebaseStorage,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _fireStore = fireStore ?? FirebaseFirestore.instance,
        _fireStorage = firebaseStorage ?? FirebaseStorage.instance;

  Future<void> signOut({currentUserId}) {
    _fireStore.collection('users').doc(currentUserId).update({
      'token': '',
    });
    return _firebaseAuth.signOut();
  }

  // gyarifegi@exdonuts.com
  Future<String> signInWithEmail(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final currentUser = _firebaseAuth.currentUser;
      _fireStore.collection('users').doc(currentUser.uid).update({
        'password': password,
      });
      return 'success';
    } catch (error) {
      print('error: $error');
      return error.code;
    }
  }

  Future<String> changeEmail({String password, String newEmail}) async {
    try {
      final currentUser = await _firebaseAuth.currentUser;
      await _firebaseAuth.signInWithEmailAndPassword(
        email: currentUser.email,
        password: password,
      );
//      await currentUser.reauthenticateWithCredential(
//        EmailAuthProvider.getCredential(
//          email: currentUser.email,
//          password: password,
//        ),
//      );
      await currentUser.updateEmail(newEmail);
      await currentUser.sendEmailVerification();
      return 'success';
    } catch (error) {
      print('error: $error');
      return error.code;
    }
  }

  Future<String> changePassword({String password, String newPassword}) async {
    try {
      // TODO テストしてない
      final currentUser = await _firebaseAuth.currentUser;
//      final currentUser = _firebaseAuth.currentUser;
//      currentUser.reauthenticateWithCredential(
//        EmailAuthProvider.credential(
//          currentUser.email,
//          password,
//        ),
//      );
      await _firebaseAuth.signInWithEmailAndPassword(
        email: currentUser.email,
        password: password,
      );
      // TODO テストしてない
      await currentUser.updatePassword(newPassword);
      return 'success';
    } catch (error) {
      print('error: $error');
      return error.code;
    }
  }

  Future<String> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return 'success';
    } catch (error) {
      print('error: $error');
      return error.code;
    }
  }

  Future<bool> isFirstTime(String userId) async {
    bool firstTime;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((user) {
      firstTime = !user.exists;
    });
    return firstTime;
  }

  Future<String> signUpAndPreProfile({
    String email,
    String password,
    String name,
    DateTime birthday,
    String gender,
    File photoMobile,
    Uint8List photoWeb,
    String school,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final currentUser = _firebaseAuth.currentUser;
      currentUser.sendEmailVerification();
      String url;
      UploadTask uploadTask0;
      if (web) {
        uploadTask0 = _fireStorage
            .ref()
            .child('userPhotos')
            .child(currentUser.uid)
            .child('photo1')
            .putData(photoWeb, SettableMetadata(contentType: 'image/png'));
      } else if (android || ios) {
        uploadTask0 = _fireStorage
            .ref()
            .child('userPhotos')
            .child(currentUser.uid)
            .child('photo1')
            .putFile(photoMobile);
      }

      var ref1 = await uploadTask0.whenComplete(() => null);
      url = await ref1.ref.getDownloadURL();

//      await uploadTask0.whenComplete(() async {
//        print('HHaaaa');
//        url = await uploadTask0.snapshot.ref.getDownloadURL();
//      });

      _fireStore.collection('users').doc(currentUser.uid).set({
        'uid': currentUser.uid,
        'token': '',
        'email': email,
        'password': password,
        'name': name,
        'birthday': birthday,
        'gender': gender,
        'interestedGender': (gender == '男性') ? '女性' : '男性',
        'profile': '',
        'school': school,
        'company': '',
//        'address': '',
        'location': null,
        'city': '',
//        'preciseAddress': '',
        'photo1': url,
        'photo2': null,
        'photo3': null,
        'photo4': null,
        'photo5': null,
        'photo6': null,
//        'photo7': null,
//        'photo8': null,
//        'photo9': null,
        'score': math.Random().nextInt(20) + 50,
        'openToday': 1,
        'open2Weeks': 1,
        'openTotal': 1,
        'boostEndTime': null,
        'superBoostEndTime': null,
        'registerDate': DateTime.now(),
        'visible': true,
        'cardCountToday': 0,
        'lastCardTime': DateTime.utc(2020, 1, 1),
        'likeCountToday': 0,
        'lastLikeTime': DateTime.utc(2020, 1, 1),
        'superLikeCountToday': 0,
        'lastSuperLikeTime': DateTime.utc(2020, 1, 1),
        'lastCheckedNotificationTime': DateTime.utc(2020, 1, 1),
        'ageVerification': null,
        'ageVerificationPhoto': null,
        'review': null,
      });

      String initialMessage =
          'こんにちは！Keioboys運営です。\nご登録ありがとうございます。\n\n他にもご不明点やご要望がある場合にもお気軽にお尋ねください。\n\n最後にアンケートになりますが、$nameさんはどこでKeioboysを知りましたか？？\n1.Twitter\n2.Instagram\n3.チラシ(手渡し)\n4.チラシ(ポスト)\n5.Google検索\n6.インスタ広告\n7.友達から聞いた\n8.その他';

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('messagingList')
          .doc('hJBNCtQKnJfwlqVonB0dzUJfbrn2')
          .collection('messages')
          .doc()
          .set({
        'text': initialMessage,
        'timestamp': FieldValue.serverTimestamp(),
        'fromMe': false
      });
      _fireStore
          .collection('users')
          .doc('hJBNCtQKnJfwlqVonB0dzUJfbrn2')
          .collection('messagingList')
          .doc(currentUser.uid)
          .collection('messages')
          .doc()
          .set({
        'text': initialMessage,
        'timestamp': FieldValue.serverTimestamp(),
        'fromMe': true
      });
      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('messagingList') //TODO なおしていってテストしてみる
          .doc('hJBNCtQKnJfwlqVonB0dzUJfbrn2')
          .set({
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastOpenedTime': FieldValue.serverTimestamp(),
        'lastSelectedUserSentMessageTime': DateTime.now(),
        'currentUserDecision': 'management',
        'selectedUserDecision': 'management',
        'firstMessageFromMe': true,
        'selectedUserName': '運営',
        'selectedUserPhoto1':
            'https://firebasestorage.googleapis.com/v0/b/stars-jp-stars.appspot.com/o/userPhotos%2FhJBNCtQKnJfwlqVonB0dzUJfbrn2%2F16044728081972910901?alt=media&token=3cad3de0-1868-4a90-94fa-51c285a45499',
        'lastMessage': initialMessage,
      });
      _fireStore
          .collection('users')
          .doc('hJBNCtQKnJfwlqVonB0dzUJfbrn2')
          .collection('messagingList')
          .doc(currentUser.uid)
          .set({
        'lastMessageTime': FieldValue.serverTimestamp(),
        'lastOpenedTime': DateTime.now(),
        'lastSelectedUserSentMessageTime': FieldValue.serverTimestamp(),
        'currentUserDecision': 'management',
        'selectedUserDecision': 'management',
        'firstMessageFromMe': false,
        'selectedUserName': name,
        'selectedUserPhoto1': url,
        'lastMessage': initialMessage,
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .set({
        'iLikeCount': 1,
        'likedCount': 1,
        'iSuperLikeCount': 1,
        'superLikedCount': 1,
        'iSkipCountLiked': 1,
        'iSkipCountSuperLiked': 1,
        'iSkipCountNotYet': 1,
        'skippedCountILike': 1,
        'skippedCountISuperLike': 1,
        'skippedCountNotYet': 1,
        'matchCountLikedIAcceptLike': 1,
        'matchCountLikedIAcceptSuperLike': 1,
        'matchCountLikedIAccept': 1,
        'matchCountSuperLikedIAcceptLike': 1,
        'matchCountSuperLikedIAcceptSuperLike': 1,
        'matchCountSuperLikedIAccept': 1,
        'matchCountILikeAcceptLiked': 1,
        'matchCountILikeAcceptSuperLiked': 1,
        'matchCountILikeAccepted': 1,
        'matchCountISuperLikeAcceptLiked': 1,
        'matchCountISuperLikeAcceptSuperLiked': 1,
        'matchCountISuperLikeAccepted': 1,
        'notAcceptCountLiked': 1,
        'notAcceptCountSuperLiked': 1,
        'notAcceptedCountILike': 1,
        'notAcceptedCountISuperLike': 1,
        'messagingCountLikedIAcceptLikeISend': 1,
        'messagingCountILikeAcceptLikedISend': 1,
        'messagingCountSuperLikedIAcceptSuperLikeISend': 1,
        'messagingCountISuperLikeAcceptSuperLikedISend': 1,
        'messagingCountLikedIAcceptSuperLikeISend': 1,
        'messagingCountLikedIAcceptISend': 1,
        'messagingCountSuperLikedIAcceptLikeISend': 1,
        'messagingCountSuperLikedIAcceptISend': 1,
        'messagingCountILikeAcceptSuperLikedISend': 1,
        'messagingCountILikeAcceptedISend': 1,
        'messagingCountISuperLikeAcceptLikedISend': 1,
        'messagingCountISuperLikeAcceptedISend': 1,
        'messagingCountLikedIAcceptLikeSent': 1,
        'messagingCountILikeAcceptLikedSent': 1,
        'messagingCountSuperLikedIAcceptSuperLikeSent': 1,
        'messagingCountISuperLikeAcceptSuperLikedSent': 1,
        'messagingCountLikedIAcceptSuperLikeSent': 1,
        'messagingCountLikedIAcceptSent': 1,
        'messagingCountSuperLikedIAcceptLikeSent': 1,
        'messagingCountSuperLikedIAcceptSent': 1,
        'messagingCountILikeAcceptSuperLikedSent': 1,
        'messagingCountILikeAcceptedSent': 1,
        'messagingCountISuperLikeAcceptLikedSent': 1,
        'messagingCountISuperLikeAcceptedSent': 1,
        'unMatchCountLikedIAcceptLikeIFirstSend': 1,
        'unMatchCountLikedIAcceptSuperLikeIFirstSend': 1,
        'unMatchCountLikedIAcceptIFirstSend': 1,
        'unMatchCountSuperLikedIAcceptLikeIFirstSend': 1,
        'unMatchCountSuperLikedIAcceptSuperLikeIFirstSend': 1,
        'unMatchCountSuperLikedIAcceptIFirstSend': 1,
        'unMatchCountILikeAcceptLikedIFirstSend': 1,
        'unMatchCountILikeAcceptSuperLikedIFirstSend': 1,
        'unMatchCountILikeAcceptedIFirstSend': 1,
        'unMatchCountISuperLikeAcceptLikedIFirstSend': 1,
        'unMatchCountISuperLikeAcceptSuperLikedIFirstSend': 1,
        'unMatchCountISuperLikeAcceptedIFirstSend': 1,
        'unMatchCountLikedIAcceptLikeFirstSent': 1,
        'unMatchCountLikedIAcceptSuperLikeFirstSent': 1,
        'unMatchCountLikedIAcceptFirstSent': 1,
        'unMatchCountSuperLikedIAcceptLikeFirstSent': 1,
        'unMatchCountSuperLikedIAcceptSuperLikeFirstSent': 1,
        'unMatchCountSuperLikedIAcceptFirstSent': 1,
        'unMatchCountILikeAcceptLikedFirstSent': 1,
        'unMatchCountILikeAcceptSuperLikedFirstSent': 1,
        'unMatchCountILikeAcceptedFirstSent': 1,
        'unMatchCountISuperLikeAcceptLikedFirstSent': 1,
        'unMatchCountISuperLikeAcceptSuperLikedFirstSent': 1,
        'unMatchCountISuperLikeAcceptedFirstSent': 1,
        'unMatchedCountLikedIAcceptLikeIFirstSend': 0,
        'unMatchedCountLikedIAcceptSuperLikeIFirstSend': 0,
        'unMatchedCountLikedIAcceptIFirstSend': 0,
        'unMatchedCountSuperLikedIAcceptLikeIFirstSend': 0,
        'unMatchedCountSuperLikedIAcceptSuperLikeIFirstSend': 0,
        'unMatchedCountSuperLikedIAcceptIFirstSend': 0,
        'unMatchedCountILikeAcceptLikedIFirstSend': 0,
        'unMatchedCountILikeAcceptSuperLikedIFirstSend': 0,
        'unMatchedCountILikeAcceptedIFirstSend': 0,
        'unMatchedCountISuperLikeAcceptLikedIFirstSend': 0,
        'unMatchedCountISuperLikeAcceptSuperLikedIFirstSend': 0,
        'unMatchedCountISuperLikeAcceptedIFirstSend': 0,
        'unMatchedCountLikedIAcceptLikeFirstSent': 0,
        'unMatchedCountLikedIAcceptSuperLikeFirstSent': 0,
        'unMatchedCountLikedIAcceptFirstSent': 0,
        'unMatchedCountSuperLikedIAcceptLikeFirstSent': 0,
        'unMatchedCountSuperLikedIAcceptSuperLikeFirstSent': 0,
        'unMatchedCountSuperLikedIAcceptFirstSent': 0,
        'unMatchedCountILikeAcceptLikedFirstSent': 0,
        'unMatchedCountILikeAcceptSuperLikedFirstSent': 0,
        'unMatchedCountILikeAcceptedFirstSent': 0,
        'unMatchedCountISuperLikeAcceptLikedFirstSent': 0,
        'unMatchedCountISuperLikeAcceptSuperLikedFirstSent': 0,
        'unMatchedCountISuperLikeAcceptedFirstSent': 0,
        'deletedLikedUserCount': 1,
        'deletedSuperLikedUserCount': 1,
        'deletedILikeUserCount': 1,
        'deletedISuperLikeUserCount': 1,
        'deletedMatchUserCount': 1,
        'deletedMessagingUserCount': 1,
      });

      if (gender == '男性') {
        int maleUserCount;
        int maleNewCount;

        await _fireStore
            .collection('usersCountList')
            .doc('counts')
            .get()
            .then((counts) {
          maleUserCount = counts['maleUserCount'];
          maleNewCount = counts['maleNewCount'];
        });
        _fireStore.collection('usersCountList').doc('counts').update({
          'maleUserCount': maleUserCount + 1,
          'maleNewCount': maleNewCount + 1,
        });
      } else {
        int femaleUserCount;
        int femaleNewCount;
        await _fireStore
            .collection('usersCountList')
            .doc('counts')
            .get()
            .then((counts) {
          femaleUserCount = counts['femaleUserCount'];
          femaleNewCount = counts['femaleNewCount'];
        });
        _fireStore.collection('usersCountList').doc('counts').update({
          'femaleUserCount': femaleUserCount + 1,
          'femaleNewCount': femaleNewCount + 1,
        });
      }
      return 'success';
    } catch (error) {
      print('error: $error');
      return error.code;
    }
  }

  Future<String> ageVerification({
    Uint8List photoWeb,
    File photoMobile,
    String currentUserId,
  }) async {
    try {
      String url;
      UploadTask uploadTask;
      final functions =
          FirebaseFunctions.instanceFor(region: 'asia-northeast1');
      final HttpsCallable sendNotification = functions.httpsCallable(
        'sendToDevice',
      );
      if (web) {
        uploadTask = _fireStorage
            .ref()
            .child('ageVerificationPhotos')
            .child(currentUserId)
            .putData(photoWeb, SettableMetadata(contentType: 'image/png'));
      } else if (android || ios) {
        uploadTask = _fireStorage
            .ref()
            .child('ageVerificationPhotos')
            .child(currentUserId)
            .putFile(photoMobile);
      }
      await uploadTask.whenComplete(() async {
        url = await uploadTask.snapshot.ref.getDownloadURL();
      });

      await _fireStore.collection('ageVerification').doc(currentUserId).set({
        'ageVerificationPhoto': url,
        'ageVerification': null,
        'userId': currentUserId,
        'timestamp': Timestamp.now(),
      });
      await _fireStore.collection('users').doc(currentUserId).update({
        'ageVerificationPhoto': 'submitted',
        'ageVerification': null,
      });
      final HttpsCallableResult result = await sendNotification.call({
        'token':
            'd1Gsvx-7QfuNLJHq5MKmu-:APA91bG_QbYEh6Gnqf62-8H1CJezlHJP0v48zi0mzV8DtZriv64OxEG7nsTYro6proNBoWMeVgQfhjFxwBpOd9ioyCdFSCBWkrrLFWamdlP1SAQ3FvVFDggPm3GYVv_5owXhCFaf2t0D',
        'sender': '年齢確認',
        'message': '年齢確認です。すぐ対応！'
      });
      return 'success';
    } catch (error) {
      print('error: $error');
      return error.code;
    }
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<String> getCurrentUserId() async {
    return (await _firebaseAuth.currentUser).uid;
  }

  Future<String> deleteAccount(password) async {
    int deletedLikedUserCount;
    int deletedSuperLikedUserCount;
    int deletedILikeUserCount;
    int deletedISuperLikeUserCount;
    int deletedMatchUserCount;
    int deletedMessagingUserCount;

    try {
      final currentUser = await _firebaseAuth.currentUser;
      print('currentUser: $currentUser');
      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('iLikeList')
          .get()
          .then((docs) async {
        for (var doc in docs.docs) {
          if (docs.docs != null) {
            print('docs.docs; ${docs.docs}');
            await _fireStore
                .collection('users')
                .doc(doc.id)
                .collection('countList')
                .doc('counts')
                .get()
                .then((count) {
              deletedLikedUserCount = count['deletedLikedUserCount'];
            });
            _fireStore
                .collection('users')
                .doc(doc.id)
                .collection('countList')
                .doc('counts')
                .update({
              'deletedLikedUserCount': deletedLikedUserCount + 1,
            });

            _fireStore
                .collection('deletedUsers')
                .doc(currentUser.uid)
                .collection('iLikeList')
                .doc(doc.id)
                .set({});

            _fireStore
                .collection('users')
                .doc(doc.id)
                .collection('likedList')
                .doc(currentUser.uid)
                .delete();
            _fireStore
                .collection('users')
                .doc(currentUser.uid)
                .collection('iLikeList')
                .doc(doc.id)
                .delete();
          }
        }
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('iSuperLikeList')
          .get()
          .then((docs) async {
        for (var doc in docs.docs) {
          if (docs.docs != null) {
            await _fireStore
                .collection('users')
                .doc(doc.id)
                .collection('countList')
                .doc('counts')
                .get()
                .then((count) {
              deletedSuperLikedUserCount = count['deletedSuperLikedUserCount'];
            });

            _fireStore
                .collection('users')
                .doc(doc.id)
                .collection('countList')
                .doc('counts')
                .update({
              'deletedSuperLikedUserCount': deletedSuperLikedUserCount + 1,
            });

            _fireStore
                .collection('deletedUsers')
                .doc(currentUser.uid)
                .collection('iSuperLikeList')
                .doc(doc.id)
                .set({});

            _fireStore
                .collection('users')
                .doc(doc.id)
                .collection('superLikedList')
                .doc(currentUser.uid)
                .delete();
            _fireStore
                .collection('users')
                .doc(currentUser.uid)
                .collection('iSuperLikeList')
                .doc(doc.id)
                .delete();
          }
        }
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('likedList')
          .get()
          .then((docs) async {
        for (var doc in docs.docs) {
          if (docs.docs != null) {
            await _fireStore
                .collection('users')
                .doc(doc.id)
                .collection('countList')
                .doc('counts')
                .get()
                .then((count) {
              deletedILikeUserCount = count['deletedILikeUserCount'];
            });

            _fireStore
                .collection('users')
                .doc(doc.id)
                .collection('countList')
                .doc('counts')
                .update({
              'deletedILikeUserCount': deletedILikeUserCount + 1,
            });

            _fireStore
                .collection('deletedUsers')
                .doc(currentUser.uid)
                .collection('likedList')
                .doc(doc.id)
                .set({});

            _fireStore
                .collection('users')
                .doc(doc.id)
                .collection('iLikeList')
                .doc(currentUser.uid)
                .delete();
            _fireStore
                .collection('users')
                .doc(currentUser.uid)
                .collection('likedList')
                .doc(doc.id)
                .delete();
          }
        }
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('superLikedList')
          .get()
          .then((docs) async {
        for (var doc in docs.docs) {
          if (docs.docs != null) {
            await _fireStore
                .collection('users')
                .doc(doc.id)
                .collection('countList')
                .doc('counts')
                .get()
                .then((count) {
              deletedISuperLikeUserCount = count['deletedISuperLikeUserCount'];
            });

            _fireStore
                .collection('users')
                .doc(doc.id)
                .collection('countList')
                .doc('counts')
                .update({
              'deletedISuperLikeUserCount': deletedISuperLikeUserCount + 1,
            });

            _fireStore
                .collection('deletedUsers')
                .doc(currentUser.uid)
                .collection('superLikedList')
                .doc(doc.id)
                .set({});

            _fireStore
                .collection('users')
                .doc(doc.id)
                .collection('iSuperLikeList')
                .doc(currentUser.uid)
                .delete();
            _fireStore
                .collection('users')
                .doc(currentUser.uid)
                .collection('superLikedList')
                .doc(doc.id)
                .delete();
          }
        }
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('matchList')
          .get()
          .then((docs) async {
        for (var doc in docs.docs) {
          if (docs.docs != null) {
            await _fireStore
                .collection('users')
                .doc(doc.id)
                .collection('countList')
                .doc('counts')
                .get()
                .then((count) {
              deletedMatchUserCount = count['deletedMatchUserCount'];
            });

            _fireStore
                .collection('users')
                .doc(doc.id)
                .collection('countList')
                .doc('counts')
                .update({
              'deletedMatchUserCount': deletedMatchUserCount + 1,
            });

            _fireStore
                .collection('deletedUsers')
                .doc(currentUser.uid)
                .collection('matchList')
                .doc(doc.id)
                .set({});

            _fireStore
                .collection('users')
                .doc(doc.id)
                .collection('matchList')
                .doc(currentUser.uid)
                .delete();
            _fireStore
                .collection('users')
                .doc(currentUser.uid)
                .collection('matchList')
                .doc(doc.id)
                .delete();
          }
        }
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('messagingList')
          .get()
          .then((docs) async {
        for (var doc in docs.docs) {
          if (docs.docs != null) {
            await _fireStore
                .collection('users')
                .doc(doc.id)
                .collection('countList')
                .doc('counts')
                .get()
                .then((count) {
              deletedMessagingUserCount = count['deletedMessagingUserCount'];
            });

            _fireStore
                .collection('users')
                .doc(doc.id)
                .collection('countList')
                .doc('counts')
                .update({
              'deletedMessagingUserCount': deletedMessagingUserCount + 1,
            });

            _fireStore
                .collection('deletedUsers')
                .doc(currentUser.uid)
                .collection('messagingList')
                .doc(doc.id)
                .set({});

            _fireStore
                .collection('users')
                .doc(doc.id)
                .collection('messagingList')
                .doc(currentUser.uid)
                .delete();
            _fireStore
                .collection('users')
                .doc(currentUser.uid)
                .collection('messagingList')
                .doc(doc.id)
                .delete();
          }
        }
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('swipedList')
          .get()
          .then((docs) {
        for (var doc in docs.docs) {
          if (docs.docs != null) {
            _fireStore
                .collection('deletedUsers')
                .doc(currentUser.uid)
                .collection('swipedList')
                .doc(doc.id)
                .set({});
            _fireStore
                .collection('users')
                .doc(currentUser.uid)
                .collection('swipedList')
                .doc(doc.id)
                .delete();
          }
        }
      });
      var countList = await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get();

      _fireStore
          .collection('deletedUsers')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .set({
        'iLikeCount': countList['iLikeCount'],
        'likedCount': countList['likedCount'],
        'iSuperLikeCount': countList['iSuperLikeCount'],
        'superLikedCount': countList['superLikedCount'],
        'iSkipCountLiked': countList['iSkipCountLiked'],
        'iSkipCountSuperLiked': countList['iSkipCountSuperLiked'],
        'iSkipCountNotYet': countList['iSkipCountNotYet'],
        'skippedCountISuperLike': countList['skippedCountISuperLike'],
        'skippedCountNotYet': countList['skippedCountNotYet'],
        'matchCountLikedIAcceptLike': countList['matchCountLikedIAcceptLike'],
        'matchCountLikedIAcceptSuperLike':
            countList['matchCountLikedIAcceptSuperLike'],
        'matchCountLikedIAccept': countList['matchCountLikedIAccept'],
        'matchCountSuperLikedIAcceptLike':
            countList['matchCountSuperLikedIAcceptLike'],
        'matchCountSuperLikedIAcceptSuperLike':
            countList['matchCountSuperLikedIAcceptSuperLike'],
        'matchCountSuperLikedIAccept': countList['matchCountSuperLikedIAccept'],
        'matchCountILikeAcceptLiked': countList['matchCountILikeAcceptLiked'],
        'matchCountILikeAcceptSuperLiked':
            countList['matchCountILikeAcceptSuperLiked'],
        'matchCountILikeAccepted': countList['matchCountILikeAccepted'],
        'matchCountISuperLikeAcceptLiked':
            countList['matchCountISuperLikeAcceptLiked'],
        'matchCountISuperLikeAcceptSuperLiked':
            countList['matchCountISuperLikeAcceptSuperLiked'],
        'matchCountISuperLikeAccepted':
            countList['matchCountISuperLikeAccepted'],
        'notAcceptCountLiked': countList['notAcceptCountLiked'],
        'notAcceptCountSuperLiked': countList['notAcceptCountSuperLiked'],
        'notAcceptedCountILike': countList['notAcceptedCountILike'],
        'notAcceptedCountISuperLike': countList['notAcceptedCountISuperLike'],
        'messagingCountLikedIAcceptLikeISend':
            countList['messagingCountLikedIAcceptLikeISend'],
        'messagingCountILikeAcceptLikedISend':
            countList['messagingCountILikeAcceptLikedISend'],
        'messagingCountSuperLikedIAcceptSuperLikeISend':
            countList['messagingCountSuperLikedIAcceptSuperLikeISend'],
        'messagingCountISuperLikeAcceptSuperLikedISend':
            countList['messagingCountISuperLikeAcceptSuperLikedISend'],
        'messagingCountLikedIAcceptSuperLikeISend':
            countList['messagingCountLikedIAcceptSuperLikeISend'],
        'messagingCountLikedIAcceptISend':
            countList['messagingCountLikedIAcceptISend'],
        'messagingCountSuperLikedIAcceptLikeISend':
            countList['messagingCountSuperLikedIAcceptLikeISend'],
        'messagingCountSuperLikedIAcceptISend':
            countList['messagingCountSuperLikedIAcceptISend'],
        'messagingCountILikeAcceptSuperLikedISend':
            countList['messagingCountILikeAcceptSuperLikedISend'],
        'messagingCountILikeAcceptedISend':
            countList['messagingCountILikeAcceptedISend'],
        'messagingCountISuperLikeAcceptLikedISend':
            countList['messagingCountISuperLikeAcceptLikedISend'],
        'messagingCountISuperLikeAcceptedISend':
            countList['messagingCountISuperLikeAcceptedISend'],
        'messagingCountLikedIAcceptLikeSent':
            countList['messagingCountLikedIAcceptLikeSent'],
        'messagingCountILikeAcceptLikedSent':
            countList['messagingCountILikeAcceptLikedSent'],
        'messagingCountSuperLikedIAcceptSuperLikeSent':
            countList['messagingCountSuperLikedIAcceptSuperLikeSent'],
        'messagingCountISuperLikeAcceptSuperLikedSent':
            countList['messagingCountISuperLikeAcceptSuperLikedSent'],
        'messagingCountLikedIAcceptSuperLikeSent':
            countList['messagingCountLikedIAcceptSuperLikeSent'],
        'messagingCountLikedIAcceptSent':
            countList['messagingCountLikedIAcceptSent'],
        'messagingCountSuperLikedIAcceptLikeSent':
            countList['messagingCountSuperLikedIAcceptLikeSent'],
        'messagingCountSuperLikedIAcceptSent':
            countList['messagingCountSuperLikedIAcceptSent'],
        'messagingCountILikeAcceptSuperLikedSent':
            countList['messagingCountILikeAcceptSuperLikedSent'],
        'messagingCountILikeAcceptedSent':
            countList['messagingCountILikeAcceptedSent'],
        'messagingCountISuperLikeAcceptLikedSent':
            countList['messagingCountISuperLikeAcceptLikedSent'],
        'messagingCountISuperLikeAcceptedSent':
            countList['messagingCountISuperLikeAcceptedSent'],
        'unMatchCountLikedIAcceptLikeIFirstSend':
            countList['unMatchCountLikedIAcceptLikeIFirstSend'],
        'unMatchCountLikedIAcceptSuperLikeIFirstSend':
            countList['unMatchCountLikedIAcceptSuperLikeIFirstSend'],
        'unMatchCountLikedIAcceptIFirstSend':
            countList['unMatchCountLikedIAcceptIFirstSend'],
        'unMatchCountSuperLikedIAcceptLikeIFirstSend':
            countList['unMatchCountSuperLikedIAcceptLikeIFirstSend'],
        'unMatchCountSuperLikedIAcceptSuperLikeIFirstSend':
            countList['unMatchCountSuperLikedIAcceptSuperLikeIFirstSend'],
        'unMatchCountSuperLikedIAcceptIFirstSend':
            countList['unMatchCountSuperLikedIAcceptIFirstSend'],
        'unMatchCountILikeAcceptLikedIFirstSend':
            countList['unMatchCountILikeAcceptLikedIFirstSend'],
        'unMatchCountILikeAcceptSuperLikedIFirstSend':
            countList['unMatchCountILikeAcceptSuperLikedIFirstSend'],
        'unMatchCountILikeAcceptedIFirstSend':
            countList['unMatchCountILikeAcceptedIFirstSend'],
        'unMatchCountISuperLikeAcceptLikedIFirstSend':
            countList['unMatchCountISuperLikeAcceptLikedIFirstSend'],
        'unMatchCountISuperLikeAcceptSuperLikedIFirstSend':
            countList['unMatchCountISuperLikeAcceptSuperLikedIFirstSend'],
        'unMatchCountISuperLikeAcceptedIFirstSend':
            countList['unMatchCountISuperLikeAcceptedIFirstSend'],
        'unMatchCountLikedIAcceptLikeFirstSent':
            countList['unMatchCountLikedIAcceptLikeFirstSent'],
        'unMatchCountLikedIAcceptSuperLikeFirstSent':
            countList['unMatchCountLikedIAcceptSuperLikeFirstSent'],
        'unMatchCountLikedIAcceptFirstSent':
            countList['unMatchCountLikedIAcceptFirstSent'],
        'unMatchCountSuperLikedIAcceptLikeFirstSent':
            countList['unMatchCountSuperLikedIAcceptLikeFirstSent'],
        'unMatchCountSuperLikedIAcceptSuperLikeFirstSent':
            countList['unMatchCountSuperLikedIAcceptSuperLikeFirstSent'],
        'unMatchCountSuperLikedIAcceptFirstSent':
            countList['unMatchCountSuperLikedIAcceptFirstSent'],
        'unMatchCountILikeAcceptLikedFirstSent':
            countList['unMatchCountILikeAcceptLikedFirstSent'],
        'unMatchCountILikeAcceptSuperLikedFirstSent':
            countList['unMatchCountILikeAcceptSuperLikedFirstSent'],
        'unMatchCountILikeAcceptedFirstSent':
            countList['unMatchCountILikeAcceptedFirstSent'],
        'unMatchCountISuperLikeAcceptLikedFirstSent':
            countList['unMatchCountISuperLikeAcceptLikedFirstSent'],
        'unMatchCountISuperLikeAcceptSuperLikedFirstSent':
            countList['unMatchCountISuperLikeAcceptSuperLikedFirstSent'],
        'unMatchCountISuperLikeAcceptedFirstSent':
            countList['unMatchCountISuperLikeAcceptedFirstSent'],
        'unMatchedCountLikedIAcceptLikeIFirstSend':
            countList['unMatchedCountLikedIAcceptLikeIFirstSend'],
        'unMatchedCountLikedIAcceptSuperLikeIFirstSend':
            countList['unMatchedCountLikedIAcceptSuperLikeIFirstSend'],
        'unMatchedCountLikedIAcceptIFirstSend':
            countList['unMatchedCountLikedIAcceptIFirstSend'],
        'unMatchedCountSuperLikedIAcceptLikeIFirstSend':
            countList['unMatchedCountSuperLikedIAcceptLikeIFirstSend'],
        'unMatchedCountSuperLikedIAcceptSuperLikeIFirstSend':
            countList['unMatchedCountSuperLikedIAcceptSuperLikeIFirstSend'],
        'unMatchedCountSuperLikedIAcceptIFirstSend':
            countList['unMatchedCountSuperLikedIAcceptIFirstSend'],
        'unMatchedCountILikeAcceptLikedIFirstSend':
            countList['unMatchedCountILikeAcceptLikedIFirstSend'],
        'unMatchedCountILikeAcceptSuperLikedIFirstSend':
            countList['unMatchedCountILikeAcceptSuperLikedIFirstSend'],
        'unMatchedCountILikeAcceptedIFirstSend':
            countList['unMatchedCountILikeAcceptedIFirstSend'],
        'unMatchedCountISuperLikeAcceptLikedIFirstSend':
            countList['unMatchedCountISuperLikeAcceptLikedIFirstSend'],
        'unMatchedCountISuperLikeAcceptSuperLikedIFirstSend':
            countList['unMatchedCountISuperLikeAcceptSuperLikedIFirstSend'],
        'unMatchedCountISuperLikeAcceptedIFirstSend':
            countList['unMatchedCountISuperLikeAcceptedIFirstSend'],
        'unMatchedCountLikedIAcceptLikeFirstSent':
            countList['unMatchedCountLikedIAcceptLikeFirstSent'],
        'unMatchedCountLikedIAcceptSuperLikeFirstSent':
            countList['unMatchedCountLikedIAcceptSuperLikeFirstSent'],
        'unMatchedCountLikedIAcceptFirstSent':
            countList['unMatchedCountLikedIAcceptFirstSent'],
        'unMatchedCountSuperLikedIAcceptLikeFirstSent':
            countList['unMatchedCountSuperLikedIAcceptLikeFirstSent'],
        'unMatchedCountSuperLikedIAcceptSuperLikeFirstSent':
            countList['unMatchedCountSuperLikedIAcceptSuperLikeFirstSent'],
        'unMatchedCountSuperLikedIAcceptFirstSent':
            countList['unMatchedCountSuperLikedIAcceptFirstSent'],
        'unMatchedCountILikeAcceptLikedFirstSent':
            countList['unMatchedCountILikeAcceptLikedFirstSent'],
        'unMatchedCountILikeAcceptSuperLikedFirstSent':
            countList['unMatchedCountILikeAcceptSuperLikedFirstSent'],
        'unMatchedCountILikeAcceptedFirstSent':
            countList['unMatchedCountILikeAcceptedFirstSent'],
        'unMatchedCountISuperLikeAcceptLikedFirstSent':
            countList['unMatchedCountISuperLikeAcceptLikedFirstSent'],
        'unMatchedCountISuperLikeAcceptSuperLikedFirstSent':
            countList['unMatchedCountISuperLikeAcceptSuperLikedFirstSent'],
        'unMatchedCountISuperLikeAcceptedFirstSent':
            countList['unMatchedCountISuperLikeAcceptedFirstSent'],
        'deletedLikedUserCount': countList['deletedLikedUserCount'],
        'deletedSuperLikedUserCount': countList['deletedSuperLikedUserCount'],
        'deletedILikeUserCount': countList['deletedILikeUserCount'],
        'deletedISuperLikeUserCount': countList['deletedISuperLikeUserCount'],
        'deletedMatchUserCount': countList['deletedMatchUserCount'],
        'deletedMessagingUserCount': countList['deletedMessagingUserCount'],
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .delete();

      var userInfo = await _fireStore
          .collection('users')
          .doc(
            currentUser.uid,
          )
          .get();

      await _fireStore
          .collection('deletedUsers')
          .doc(
            currentUser.uid,
          )
          .set({
        'uid': userInfo['uid'],
        'token': userInfo['token'],
        'email': userInfo['email'],
        'name': userInfo['name'],
        'birthday': userInfo['birthday'],
        'gender': userInfo['gender'],
        'interestedGender': userInfo['interestedGender'],
        'profile': userInfo['profile'],
        'school': userInfo['school'],
        'company': userInfo['company'],
        'location': userInfo['location'],
        'city': userInfo['city'],
        'photo1': userInfo['photo1'],
        'photo2': userInfo['photo2'],
        'photo3': userInfo['photo3'],
        'photo4': userInfo['photo4'],
        'photo5': userInfo['photo5'],
        'photo6': userInfo['photo6'],
        'score': userInfo['score'],
        'openToday': userInfo['openToday'],
        'open2Weeks': userInfo['open2Weeks'],
        'openTotal': userInfo['openTotal'],
        'boostEndTime': userInfo['boostEndTime'],
        'superBoostEndTime': userInfo['superBoostEndTime'],
        'registerDate': userInfo['registerDate'],
        'visible': userInfo['visible'],
        'cardCountToday': userInfo['cardCountToday'],
        'lastCardTime': userInfo['lastCardTime'],
        'likeCountToday': userInfo['likeCountToday'],
        'lastLikeTime': userInfo['lastLikeTime'],
        'superLikeCountToday': userInfo['superLikeCountToday'],
        'lastSuperLikeTime': userInfo['lastSuperLikeTime'],
        'lastCheckedNotificationTime': userInfo['lastCheckedNotificationTime'],
        'ageVerification': userInfo['ageVerification'],
        'ageVerificationPhoto': userInfo['ageVerificationPhoto'],
        'review': userInfo['review'],
      });
      if (userInfo['gender'] == '男性') {
        int maleUserCount;
        int maleDeletedCount;

        await _fireStore
            .collection('usersCountList')
            .doc('counts')
            .get()
            .then((counts) {
          maleUserCount = counts['maleUserCount'];
          maleDeletedCount = counts['maleDeletedCount'];
        });
        _fireStore.collection('usersCountList').doc('counts').update({
          'maleUserCount': maleUserCount - 1,
          'maleDeletedCount': maleDeletedCount - 1,
        });
      } else {
        int femaleUserCount;
        int femaleDeletedCount;
        await _fireStore
            .collection('usersCountList')
            .doc('counts')
            .get()
            .then((counts) {
          femaleUserCount = counts['femaleUserCount'];
          femaleDeletedCount = counts['femaleDeletedCount'];
        });
        _fireStore.collection('usersCountList').doc('counts').update({
          'femaleUserCount': femaleUserCount - 1,
          'femaleDeletedCount': femaleDeletedCount - 1,
        });
      }

      await _fireStore
          .collection('users')
          .doc(
            currentUser.uid,
          )
          .delete();

//      await currentUser.reauthenticateWithCredential(
//        EmailAuthProvider.getCredential(
//          email: currentUser.email,
//          password: password,
//        ),
//      );

      await currentUser.delete();
      await _firebaseAuth.signOut();
      return 'success';
    } catch (error) {
      print('error: $error');
      return error.code;
    }
  }

  Future<String> reAuthenticate(password) async {
    try {
      final currentUser = await _firebaseAuth.currentUser;
      print('currentUser: ${currentUser.uid}');
      print('currentUser: ${currentUser.email}');
      print('password: $password');
      await _firebaseAuth.signInWithEmailAndPassword(
        email: currentUser.email,
        password: password,
      );
      return 'success';
    } catch (error) {
      print('error: $error');
      return error.code;
    }
  }

  Future<String> sendEmailCode() async {
    try {
      final currentUser = await _firebaseAuth.currentUser;
      currentUser.sendEmailVerification();
      return 'success';
    } catch (error) {
      print('error: $error');
      return error.code;
    }
  }

  Future<bool> isEmailVerified() async {
    bool _result;
    await _firebaseAuth.currentUser
      ..reload();
    dynamic currentUser = _firebaseAuth.currentUser;
    _result = currentUser.emailVerified;
    return _result;
  }

//  Future<void> profileSetUp(
//      File photo,
//      String userId,
//      String name,
//      String gender,
//      String interestedGender,
//      DateTime age,
//      GeoPoint location) async {
//    UploadTask UploadTask;
//    UploadTask = FirebaseStorage.instance
//        .ref()
//        .child('userPhotos')
//        .child(userId)
//        .child(userId)
//        .putFile(photo);
//
//    return await UploadTask.onComplete.then((ref) async {
//      print('プロフィールのアップロードが完了しました。');
//      await ref.ref.getDownloadURL().then((url) async {
//        await _fireStore.collection('users').doc(userId).set({
//          'uid': userId,
//          'photo': url,
//          'name': name,
//          'age': age,
//          'location': location,
//          'gender': gender,
//          'interestedGender': interestedGender,
//        });
//      });
//    });
//  }

//  Future<void> preProfileSetUp(
//    String userId,
//    String name,
//    DateTime birthday,
//    String gender,
//    String interestedGender,
//    File photo,
//  ) async {
//    String url;
//    UploadTask UploadTask;
//    try {
//      UploadTask = FirebaseStorage.instance
//          .ref()
//          .child('userPhotos')
//          .child(userId)
//          .child('photo1')
//          .putFile(photo);
//      var ref1 = await UploadTask.onComplete;
//      url = await ref1.ref.getDownloadURL();
//      await _fireStore.collection('users').doc(userId).set({
//        'uid': userId,
//        'name': name,
//        'age': birthday,
//        'gender': gender,
//        'interestedGender': interestedGender,
//        'profile': '',
//        'school': '',
//        'company': '',
////        'address': '',
//        'location': null,
//        'city': '',
////        'preciseAddress': '',
//        'photo': url,
//        'photo2': null,
//        'photo3': null,
//        'photo4': null,
//        'photo5': null,
//        'photo6': null,
////        'photo7': null,
////        'photo8': null,
////        'photo9': null,
//        'score': math.Random().nextInt(100),
//        'openToday': 1,
//        'openTotal': 1,
//        'boostEndTime': null,
//        'superBoostEndTime': null,
//        'registerDate': DateTime.now(),
//        'visible': true,
//      });
//      print('プリプロフィールのアップロードが完了しました。');
//    } catch (error) {
//      print('error: $error');
//    }
//  }

  Future<void> updateProfile({
    String userId,
//    String name,
    String profile,
    String school,
    String company,
//    String address,
    File photoMobile1,
    File photoMobile2,
    File photoMobile3,
    File photoMobile4,
    File photoMobile5,
    File photoMobile6,
    Uint8List photoWeb1,
    Uint8List photoWeb2,
    Uint8List photoWeb3,
    Uint8List photoWeb4,
    Uint8List photoWeb5,
    Uint8List photoWeb6,
    String initWidgetPhoto1,
    String initWidgetPhoto2,
    String initWidgetPhoto3,
    String initWidgetPhoto4,
    String initWidgetPhoto5,
    String initWidgetPhoto6,
    String changedWidgetPhoto1,
    String changedWidgetPhoto2,
    String changedWidgetPhoto3,
    String changedWidgetPhoto4,
    String changedWidgetPhoto5,
    String changedWidgetPhoto6,
  }) async {
    print('プロフィールのアップロードを始めます。');
    UploadTask uploadTask1;
    UploadTask uploadTask2;
    UploadTask uploadTask3;
    UploadTask uploadTask4;
    UploadTask uploadTask5;
    UploadTask uploadTask6;
//    UploadTask UploadTask7;
//    UploadTask UploadTask8;
//    UploadTask UploadTask9;
    var url1;
    var url2;
    var url3;
    var url4;
    var url5;
    var url6;
//    var url7;
//    var url8;
//    var url9;
//早くならんか(できれば)

    //基本的に今までの方法
    //file名をランダムにする
    //initwidgetがもうどこでも使われてないとき(init1==changed123456でないとき)、それを削除(urlからfile名抽出して)

    try {
      if (web) {
        if (photoWeb1 != null) {
          uploadTask1 = _fireStorage
              .ref()
              .child('userPhotos')
              .child(userId)
              .child(math.Random().nextInt(4294967296).toString() +
                  math.Random().nextInt(4294967296).toString())
              .putData(photoWeb1, SettableMetadata(contentType: 'image/png'));
          await uploadTask1.whenComplete(() async {
            url1 = await uploadTask1.snapshot.ref.getDownloadURL();
          });
        }
        if (photoWeb2 != null) {
          uploadTask2 = _fireStorage
              .ref()
              .child('userPhotos')
              .child(userId)
              .child(math.Random().nextInt(4294967296).toString() +
                  math.Random().nextInt(4294967296).toString())
              .putData(photoWeb2, SettableMetadata(contentType: 'image/png'));
          await uploadTask2.whenComplete(() async {
            url2 = await uploadTask2.snapshot.ref.getDownloadURL();
          });
        }
        if (photoWeb3 != null) {
          uploadTask3 = _fireStorage
              .ref()
              .child('userPhotos')
              .child(userId)
              .child(math.Random().nextInt(4294967296).toString() +
                  math.Random().nextInt(4294967296).toString())
              .putData(photoWeb3, SettableMetadata(contentType: 'image/png'));

          await uploadTask3.whenComplete(() async {
            url3 = await uploadTask3.snapshot.ref.getDownloadURL();
          });
        }
        if (photoWeb4 != null) {
          uploadTask4 = _fireStorage
              .ref()
              .child('userPhotos')
              .child(userId)
              .child(math.Random().nextInt(4294967296).toString() +
                  math.Random().nextInt(4294967296).toString())
              .putData(photoWeb4, SettableMetadata(contentType: 'image/png'));

          await uploadTask4.whenComplete(() async {
            url4 = await uploadTask4.snapshot.ref.getDownloadURL();
          });
        }
        if (photoWeb5 != null) {
          uploadTask5 = _fireStorage
              .ref()
              .child('userPhotos')
              .child(userId)
              .child(math.Random().nextInt(4294967296).toString() +
                  math.Random().nextInt(4294967296).toString())
              .putData(photoWeb5, SettableMetadata(contentType: 'image/png'));

          await uploadTask5.whenComplete(() async {
            url5 = await uploadTask5.snapshot.ref.getDownloadURL();
          });
        }
        if (photoWeb6 != null) {
          uploadTask6 = _fireStorage
              .ref()
              .child('userPhotos')
              .child(userId)
              .child(math.Random().nextInt(4294967296).toString() +
                  math.Random().nextInt(4294967296).toString())
              .putData(photoWeb6, SettableMetadata(contentType: 'image/png'));
          await uploadTask6.whenComplete(() async {
            url6 = await uploadTask6.snapshot.ref.getDownloadURL();
          });
        }
      } else if (android || ios) {
        if (photoMobile1 != null) {
          uploadTask1 = _fireStorage
              .ref()
              .child('userPhotos')
              .child(userId)
              .child(math.Random().nextInt(4294967296).toString() +
                  math.Random().nextInt(4294967296).toString())
              .putFile(photoMobile1);
          await uploadTask1.whenComplete(() async {
            url1 = await uploadTask1.snapshot.ref.getDownloadURL();
          });
        }
        if (photoMobile2 != null) {
          uploadTask2 = _fireStorage
              .ref()
              .child('userPhotos')
              .child(userId)
              .child(math.Random().nextInt(4294967296).toString() +
                  math.Random().nextInt(4294967296).toString())
              .putFile(photoMobile2);
          await uploadTask2.whenComplete(() async {
            url2 = await uploadTask2.snapshot.ref.getDownloadURL();
          });
        }
        if (photoMobile3 != null) {
          uploadTask3 = _fireStorage
              .ref()
              .child('userPhotos')
              .child(userId)
              .child(math.Random().nextInt(4294967296).toString() +
                  math.Random().nextInt(4294967296).toString())
              .putFile(photoMobile3);

          await uploadTask3.whenComplete(() async {
            url3 = await uploadTask3.snapshot.ref.getDownloadURL();
          });
        }
        if (photoMobile4 != null) {
          uploadTask4 = _fireStorage
              .ref()
              .child('userPhotos')
              .child(userId)
              .child(math.Random().nextInt(4294967296).toString() +
                  math.Random().nextInt(4294967296).toString())
              .putFile(photoMobile4);

          await uploadTask4.whenComplete(() async {
            url4 = await uploadTask4.snapshot.ref.getDownloadURL();
          });
        }
        if (photoMobile5 != null) {
          uploadTask5 = _fireStorage
              .ref()
              .child('userPhotos')
              .child(userId)
              .child(math.Random().nextInt(4294967296).toString() +
                  math.Random().nextInt(4294967296).toString())
              .putFile(photoMobile5);

          await uploadTask5.whenComplete(() async {
            url5 = await uploadTask5.snapshot.ref.getDownloadURL();
          });
        }
        if (photoMobile6 != null) {
          uploadTask6 = _fireStorage
              .ref()
              .child('userPhotos')
              .child(userId)
              .child(math.Random().nextInt(4294967296).toString() +
                  math.Random().nextInt(4294967296).toString())
              .putFile(photoMobile6);
          await uploadTask6.whenComplete(() async {
            url6 = await uploadTask6.snapshot.ref.getDownloadURL();
          });
        }
      }

      _fireStore.collection('users').doc(userId).update({
//        'name': name,
        'profile': profile,
        'school': school,
        'company': company,
//        'address': address,
        'photo1': (url1 == null) ? changedWidgetPhoto1 : url1,
        'photo2': (url2 == null) ? changedWidgetPhoto2 : url2,
        'photo3': (url3 == null) ? changedWidgetPhoto3 : url3,
        'photo4': (url4 == null) ? changedWidgetPhoto4 : url4,
        'photo5': (url5 == null) ? changedWidgetPhoto5 : url5,
        'photo6': (url6 == null) ? changedWidgetPhoto6 : url6,
//        'photo7': (photo7.runtimeType == String)
//            ? photo7
//            : (photo7.runtimeType == Null) ? null : url7,
//        'photo8': (photo8.runtimeType == String)
//            ? photo8
//            : (photo8.runtimeType == Null) ? null : url8,
//        'photo9': (photo9.runtimeType == String)
//            ? photo9
//            : (photo9.runtimeType == Null) ? null : url9,
      });
      print('プロフィールのアップロードが完了しました。');

      final exp1 = RegExp(r'[a-zA-Z0-9:/.-]*userPhotos%2F[a-zA-Z0-9]*%2F');
      final exp2 = RegExp(r'[?]alt=media&token=[a-z0-9-]*');
      if (initWidgetPhoto1 != changedWidgetPhoto1 &&
          initWidgetPhoto1 != changedWidgetPhoto2 &&
          initWidgetPhoto1 != changedWidgetPhoto3 &&
          initWidgetPhoto1 != changedWidgetPhoto4 &&
          initWidgetPhoto1 != changedWidgetPhoto5 &&
          initWidgetPhoto1 != changedWidgetPhoto6) {
        String fileName =
            initWidgetPhoto1.replaceFirst(exp1, '').replaceFirst(exp2, '');
        _fireStorage
            .ref()
            .child('userPhotos')
            .child(userId)
            .child(fileName)
            .delete();
      }
      if (initWidgetPhoto2 != changedWidgetPhoto1 &&
          initWidgetPhoto2 != changedWidgetPhoto2 &&
          initWidgetPhoto2 != changedWidgetPhoto3 &&
          initWidgetPhoto2 != changedWidgetPhoto4 &&
          initWidgetPhoto2 != changedWidgetPhoto5 &&
          initWidgetPhoto2 != changedWidgetPhoto6) {
        String fileName =
            initWidgetPhoto2.replaceFirst(exp1, '').replaceFirst(exp2, '');
        _fireStorage
            .ref()
            .child('userPhotos')
            .child(userId)
            .child(fileName)
            .delete();
      }
      if (initWidgetPhoto3 != changedWidgetPhoto1 &&
          initWidgetPhoto3 != changedWidgetPhoto2 &&
          initWidgetPhoto3 != changedWidgetPhoto3 &&
          initWidgetPhoto3 != changedWidgetPhoto4 &&
          initWidgetPhoto3 != changedWidgetPhoto5 &&
          initWidgetPhoto3 != changedWidgetPhoto6) {
        String fileName =
            initWidgetPhoto3.replaceFirst(exp1, '').replaceFirst(exp2, '');
        _fireStorage
            .ref()
            .child('userPhotos')
            .child(userId)
            .child(fileName)
            .delete();
      }
      if (initWidgetPhoto4 != changedWidgetPhoto1 &&
          initWidgetPhoto4 != changedWidgetPhoto2 &&
          initWidgetPhoto4 != changedWidgetPhoto3 &&
          initWidgetPhoto4 != changedWidgetPhoto4 &&
          initWidgetPhoto4 != changedWidgetPhoto5 &&
          initWidgetPhoto4 != changedWidgetPhoto6) {
        String fileName =
            initWidgetPhoto4.replaceFirst(exp1, '').replaceFirst(exp2, '');
        _fireStorage
            .ref()
            .child('userPhotos')
            .child(userId)
            .child(fileName)
            .delete();
      }
      if (initWidgetPhoto5 != changedWidgetPhoto1 &&
          initWidgetPhoto5 != changedWidgetPhoto2 &&
          initWidgetPhoto5 != changedWidgetPhoto3 &&
          initWidgetPhoto5 != changedWidgetPhoto4 &&
          initWidgetPhoto5 != changedWidgetPhoto5 &&
          initWidgetPhoto5 != changedWidgetPhoto6) {
        String fileName =
            initWidgetPhoto5.replaceFirst(exp1, '').replaceFirst(exp2, '');
        _fireStorage
            .ref()
            .child('userPhotos')
            .child(userId)
            .child(fileName)
            .delete();
      }
      if (initWidgetPhoto6 != changedWidgetPhoto1 &&
          initWidgetPhoto6 != changedWidgetPhoto2 &&
          initWidgetPhoto6 != changedWidgetPhoto3 &&
          initWidgetPhoto6 != changedWidgetPhoto4 &&
          initWidgetPhoto6 != changedWidgetPhoto5 &&
          initWidgetPhoto6 != changedWidgetPhoto6) {
        String fileName =
            initWidgetPhoto6.replaceFirst(exp1, '').replaceFirst(exp2, '');
        _fireStorage
            .ref()
            .child('userPhotos')
            .child(userId)
            .child(fileName)
            .delete();
      }
    } catch (error) {
      print('error: $error');
    }
  }

  Future<void> updateInterestedGender(
    String userId,
    String interestedGender,
  ) async {
    try {
      _fireStore.collection('users').doc(userId).update({
        'interestedGender': interestedGender,
      });
    } catch (error) {
      print('error: $error');
    }
  }

  Future<void> updateVisible(
    String userId,
    bool visible,
  ) async {
    try {
      _fireStore.collection('users').doc(userId).update({
        'visible': visible,
      });
    } catch (error) {
      print('error: $error');
    }
  }

  Future<void> updateCheckedNotificationTime({
    currentUserId,
  }) async {
    try {
      _fireStore.collection('users').doc(currentUserId).update({
        'lastCheckedNotificationTime': FieldValue.serverTimestamp(),
      });
    } catch (error) {
      print('error: $error');
    }
  }

  Future<void> hideCity(
    String userId,
    bool showCity,
  ) async {
    try {
      String city;
      if (showCity) {
        Location locationService = Location();
        bool isLocationServiceEnabled = await locationService.serviceEnabled();
        if (isLocationServiceEnabled == false) {
//        await locationService.requestService();
        }
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          await Geolocator.requestPermission();
        }
        Position position;
        if (android || ios) {
          position = await Geolocator.getLastKnownPosition();
        } else if (web) {
          position = await Geolocator.getCurrentPosition();
        }
        GeoPoint location = GeoPoint(position.latitude, position.longitude);
        var googleGeocoding =
            geocoder.GoogleGeocoding("AIzaSyDGHRocEMdaLLWx3Jip2GpQQSgQGnkzwQI");
        var addresses = await googleGeocoding.geocoding
            .getReverse(geocoder.LatLon(position.latitude, position.longitude));

        List addressList = [];
        for (var i = addresses.results.first.addressComponents.length - 1;
            i > -1;
            i--) {
          addressList
              .add(addresses.results.first.addressComponents[i].longName);
        }
        print('city: ${addressList[3]}');
        city = addressList[3];
      } else {
        city = 'hide';
      }
      _fireStore.collection('users').doc(userId).update({
        'city': city,
      });
    } catch (error) {
      print('error: $error');
    }
  }

  Future<List> updateInfo({
    UserData currentUser,
    var context,
  }) async {
    GeoPoint location;
//    int openToday;
//    int openTotal;
    int openTodayForScore;
    int openTotalForScore;
    int boost = 0;
//    DateTime boostEndTime;
    int superBoost = 0;
//    DateTime superBoostEndTime;
//    DateTime registerDate;
    DateTime threeDaysAfterRegister;
    DateTime twoWeeksAfterRegister;
    int bonus3days = 0;
    int bonus2weeks = 0;
    String city;
//    bool ageVerification;
    bool ageVerificationNew;

//    try {
//      await _fireStore
//          .collection('users')
//          .doc(currentUser.uid)
//          .get()
//          .then((user) {
//        city = user['city'];
//        openToday = user['openToday'];
//        openTotal = user['openTotal'];
//        boostEndTime = user['boostEndTime'];
//        superBoostEndTime = user['superBoostEndTime'];
//        registerDate = user['registerDate'].toDate();
//        ageVerification = user['ageVerification'];
//      });
//    } catch (error) {
//      print('error: $error');
//    }

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);
    _firebaseMessaging.getToken().then((String token) async {
      assert(token != null);
      _fireStore.collection('users').doc(currentUser.uid).update({
        'token': token,
      });
    });
    try {
      Location locationService = Location();
      bool isLocationServiceEnabled = await locationService.serviceEnabled();
      if (isLocationServiceEnabled == false) {
//        await locationService.requestService();
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await Geolocator.requestPermission();
      }
      Position position;
      if (android || ios) {
        position = await Geolocator.getLastKnownPosition();
      } else if (web) {
        position = await Geolocator.getCurrentPosition();
      }
      location = GeoPoint(position.latitude, position.longitude);
      if (currentUser.city != 'hide') {
//        final coordinates = Coordinates(position.latitude, position.longitude);
//        var addresses =
//            await Geocoder.local.findAddressesFromCoordinates(coordinates);
//        var addresses = await GeoCode().reverseGeocoding(
//          latitude: position.latitude,
//          longitude: position.longitude,
//        );
        var googleGeocoding =
            geocoder.GoogleGeocoding("AIzaSyDGHRocEMdaLLWx3Jip2GpQQSgQGnkzwQI");
        var addresses = await googleGeocoding.geocoding
            .getReverse(geocoder.LatLon(position.latitude, position.longitude));

        List addressList = [];
        for (var i = addresses.results.first.addressComponents.length - 1;
            i > -1;
            i--) {
          addressList
              .add(addresses.results.first.addressComponents[i].longName);
        }
        print('city: ${addressList[3]}');
        city = addressList[3];
      }
    } catch (error) {
      location = null;
      city = null;
      print('error: $error');
    }

//    if (currentUser.boostEndTime != null) {
//      if (DateTime.now().isBefore(currentUser.boostEndTime.toDate())) {
//        boost = 20;
//      } else {
//        currentUser.boostEndTime = null;
//      }
//    }
//    if (currentUser.superBoostEndTime != null) {
//      if (DateTime.now().isBefore(currentUser.superBoostEndTime.toDate())) {
//        superBoost = 30; //ブースト実装
//      } else {
//        currentUser.superBoostEndTime = null;
//      }
//    }

//    threeDaysAfterRegister =
//        currentUser.registerDate.toDate().add(Duration(days: 3));
//    twoWeeksAfterRegister =
//        currentUser.registerDate.toDate().add(Duration(days: 14));
//
//    if (DateTime.now().isBefore(threeDaysAfterRegister)) {
//      bonus3days = 30;
//    } else if (DateTime.now().isBefore(twoWeeksAfterRegister)) {
//      bonus2weeks = 15;
//    }

//    if (currentUser.ageVerification != true) {
//      try {
//        await _fireStore
//            .collection('ageVerification')
//            .doc(currentUser.uid)
//            .get()
//            .then((verification) {
//          ageVerificationNew = verification['ageVerification'];
//        });
//        if (ageVerificationNew == true) {
//          await _fireStore
//              .collection('ageVerification')
//              .doc(currentUser.uid)
//              .delete();
//        }
//      } catch (error) {
//        print('error: $error, errorでok');
//      }
//    }

    openTodayForScore = 1;
    if (currentUser.openToday + 1 > 10) {
      openTodayForScore = 0;
    }

//    if (currentUser.openTotal > 100) {
//      openTotalForScore = 100;
//    } else {
//      openTotalForScore = currentUser.openTotal;
//    }

    try {
      _fireStore.collection('users').doc(currentUser.uid).update({
        'location': (location == null) ? currentUser.location : location,
        'city': (city == null) ? currentUser.city : city,
//        'preciseAddress': first.addressLine,
        'openToday': currentUser.openToday + 1,
        'open2Weeks': currentUser.open2Weeks + 1,
        'openTotal': currentUser.openTotal + 1,
        'score': currentUser.score +
            openTodayForScore +
            math.Random().nextInt(5) -
            math.Random().nextInt(5),
        'boostEndTime': currentUser.boostEndTime,
        'superBoostEndTime': currentUser.superBoostEndTime,
//        'ageVerification':
//            (currentUser.ageVerification == true) ? true : ageVerificationNew,
      });
      //100点満点：15ライク率*20+15スーパーライク率*40+10accept率-マッチ解除される率*10*2+10上限過去2週間ログイン回数*0.01+10上限今日のログイン回数*0.1+20ランダム+20ブースト等ボーナス（3日30・14日15・ブースト30）
      //0-6-15, 0-3-15, 8, -6--14, 5, 5, 10, 0
      //デフォのボーナス抜き40.2
//      print(
//          'score: ${openTotalForScore * 0.01 + openTodayForScore * 0.1 + math.Random().nextInt(50) + bonus3days + bonus2weeks}');
    } catch (error) {
      print('error: $error');
    }
  }

  Future getCurrentUser(userId) async {
    UserData currentUser = UserData();
    await _fireStore.collection('users').doc(userId).get().then((user) {
      currentUser.uid = user['uid'];
      currentUser.email = user['email'];
      currentUser.name = user['name'];
      currentUser.birthday = user['birthday'];
      currentUser.gender = user['gender'];
      currentUser.interestedGender = user['interestedGender'];
      currentUser.profile = user['profile'];
      currentUser.school = user['school'];
      currentUser.company = user['company'];
//      currentUser.address = user['address'];
      currentUser.location = user['location'];
      currentUser.city = user['city'];
      currentUser.visible = user['visible'];
//      currentUser.preciseAddress = user['preciseAddress'];
      currentUser.photo1 = user['photo1'];
      currentUser.photo2 = user['photo2'];
      currentUser.photo3 = user['photo3'];
      currentUser.photo4 = user['photo4'];
      currentUser.photo5 = user['photo5'];
      currentUser.photo6 = user['photo6'];
      currentUser.openToday = user['openToday'];
      currentUser.open2Weeks = user['open2Weeks'];
      currentUser.openTotal = user['openTotal'];
      currentUser.score = user['score'];
      currentUser.cardCountToday = user['cardCountToday'];
      currentUser.lastCardTime = user['lastCardTime'];
      currentUser.likeCountToday = user['likeCountToday'];
      currentUser.lastLikeTime = user['lastLikeTime'];
      currentUser.superLikeCountToday = user['superLikeCountToday'];
      currentUser.lastSuperLikeTime = user['lastSuperLikeTime'];
      currentUser.boostEndTime = user['boostEndTime'];
      currentUser.superBoostEndTime = user['superBoostEndTime'];
      currentUser.registerDate = user['registerDate'];
      currentUser.lastCheckedNotificationTime =
          user['lastCheckedNotificationTime'];
      currentUser.ageVerification = user['ageVerification'];
      currentUser.review = user['review'];
//      currentUser.photo7 = user['photo7'];
//      currentUser.photo8 = user['photo8'];
//      currentUser.photo9 = user['photo9'];
    });
    return currentUser;
  }

  Future<List> getSettingTabText() async {
    String title1;
    String firstLine1;
    String secondLine1;

    String title2;
    String firstLine2;
    String secondLine2;

    String title3;
    String firstLine3;
    String secondLine3;

    String title4;
    String firstLine4;
    String secondLine4;

    await _fireStore
        .collection('state')
        .doc('settingTabText')
        .get()
        .then((doc) {
      title1 = doc['title1'];
      firstLine1 = doc['firstLine1'];
      secondLine1 = doc['secondLine1'];

      title2 = doc['title2'];
      firstLine2 = doc['firstLine2'];
      secondLine2 = doc['secondLine2'];

      title3 = doc['title3'];
      firstLine3 = doc['firstLine3'];
      secondLine3 = doc['secondLine3'];

      title4 = doc['title4'];
      firstLine4 = doc['firstLine4'];
      secondLine4 = doc['secondLine4'];
    });
    return [
      NotifyString(
        title: title1,
        firstLine: firstLine1,
        secondLine: secondLine1,
      ),
      NotifyString(
        title: title2,
        firstLine: firstLine2,
        secondLine: secondLine2,
      ),
      NotifyString(
        title: title3,
        firstLine: firstLine3,
        secondLine: secondLine3,
      ),
      NotifyString(
        title: title4,
        firstLine: firstLine4,
        secondLine: secondLine4,
      ),
    ];
  }

  Future<List> checkMaintenance() async {
    bool maintenance;
    String maintenanceText;
    await _fireStore.collection('state').doc('maintenance').get().then((doc) {
      maintenance = doc['maintenance'];
      maintenanceText = doc['maintenanceText'];
    });
    return [maintenance, maintenanceText];
  }

  Future<int> checkMinimumBuildNumber() async {
    int minimumBuildNumber;
    await _fireStore
        .collection('state')
        .doc('minimumBuildNumber')
        .get()
        .then((doc) {
      minimumBuildNumber = doc['minimumBuildNumber'];
    });
    return minimumBuildNumber;
  }

  Future<bool> checkNewNotification({lastCheckedNotificationTime}) async {
    Timestamp latestNotificationTime;
    bool newNotification;
    var notification =
        await _fireStore.collection('state').doc('notification').get();
    latestNotificationTime = notification['timestamp'];
    if (latestNotificationTime
        .toDate()
        .isAfter(lastCheckedNotificationTime.toDate())) {
      newNotification = true;
    } else {
      newNotification = false;
    }
    return newNotification;
  }
}

class NotifyString {
  final String title;
  final String firstLine;
  final String secondLine;
  NotifyString({
    this.title,
    this.firstLine,
    this.secondLine,
  });
}

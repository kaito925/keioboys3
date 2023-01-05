//choosedとか名前変えれば著作ok

import 'package:cloud_functions/cloud_functions.dart';
import 'package:Keioboys/FB/MatchFB.dart';
import 'package:Keioboys/FB/MessageFB.dart';
import 'package:Keioboys/Widgets/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math' as math;

var lastSearchedUserScore;

class SearchFB {
  final FirebaseFirestore _fireStore;
  MessageFB _messageFB = MessageFB();
  MatchFB _matchFB = MatchFB();
  final functions = FirebaseFunctions.instanceFor(region: 'asia-northeast1');

  SearchFB({
    FirebaseFirestore fireStore,
  }) : _fireStore = fireStore ?? FirebaseFirestore.instance;

  void like({
    currentUserId,
    currentUserName,
    currentUserBirthday,
    currentUserPhotoURL,
    selectedUserId,
    selectedUserName,
    selectedUserToken,
    selectedUserEmail,
    cardCountToday,
    likeCountToday,
  }) async {
    int iLikeCount;
    int likedCount;
    final HttpsCallable sendNotification = functions.httpsCallable(
      'sendToDevice',
    );
    final HttpsCallable sendEmail = functions.httpsCallable(
      'sendEmail',
    );

    if (selectedUserToken != '' && selectedUserToken != 'web') {
      final HttpsCallableResult result = await sendNotification.call({
        'token': selectedUserToken,
        'sender': currentUserName,
        'message': 'あなたをLIKEしました！'
      });
    } else {
      var messageHtml = '''<div>
                          <p>${selectedUserName}さん</p>
                          <p>${currentUserName}さんに新しくLIKEされました。<br>LIKEを返してマッチしましょう！</p>
                          <br>
                          <br>
                          <body style="text-align: center">
                            <a href="https://keioboys.page.link/m" 
                            style="border-radius: 5px;
                            background-color: #fa196e;
                            padding: 15px;
                            text-decoration: none;
                            color: white;
                            ">今すぐマッチ</a>
                          </body>
                          </div>''';
      final HttpsCallableResult result = await sendEmail.call({
        'email': '$selectedUserEmail',
        'subject': '【Keioboys】 新しいLIKEのお知らせ',
        'html': messageHtml,
      });
    }

    _fireStore
        .collection('users')
        .doc(currentUserId)
        .collection('iLikeList')
        .doc(selectedUserId)
        .set({});

    _fireStore
        .collection('users')
        .doc(currentUserId)
        .collection('swipedList')
        .doc(selectedUserId)
        .set({});

    _fireStore
        .collection('users')
        .doc(selectedUserId)
        .collection('swipedList')
        .doc(currentUserId)
        .set({});

    _fireStore
        .collection('users')
        .doc(selectedUserId)
        .collection('likedList')
        .doc(currentUserId)
        .set({
      'name': currentUserName,
      'birthday': currentUserBirthday,
      'photo1': currentUserPhotoURL,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _fireStore.collection('users').doc(currentUserId).update({
      'cardCountToday': cardCountToday,
      'lastCardTime': FieldValue.serverTimestamp(),
      'likeCountToday': likeCountToday,
      'lastLikeTime': FieldValue.serverTimestamp(),
    });

    await _fireStore
        .collection('users')
        .doc(currentUserId)
        .collection('countList')
        .doc('counts')
        .get()
        .then((count) {
      iLikeCount = count['iLikeCount'];
    });

    _fireStore
        .collection('users')
        .doc(currentUserId)
        .collection('countList')
        .doc('counts')
        .update({
      'iLikeCount': iLikeCount + 1,
    });
    await _fireStore
        .collection('users')
        .doc(selectedUserId)
        .collection('countList')
        .doc('counts')
        .get()
        .then((count) {
      likedCount = count['likedCount'];
    });
    _fireStore
        .collection('users')
        .doc(selectedUserId)
        .collection('countList')
        .doc('counts')
        .update({
      'likedCount': likedCount + 1,
    });
  }

  void superLike({
    currentUserId,
    currentUserName,
    currentUserBirthday,
    currentUserPhotoURL,
    selectedUserId,
    selectedUserName,
    selectedUserToken,
    selectedUserEmail,
    cardCountToday,
    superLikeCountToday,
  }) async {
    int iSuperLikeCount;
    int superLikedCount;

    final HttpsCallable sendNotification = functions.httpsCallable(
      'sendToDevice',
    );
    final HttpsCallable sendEmail = functions.httpsCallable(
      'sendEmail',
    );

    if (selectedUserToken != '' && selectedUserToken != 'web') {
      final HttpsCallableResult result = await sendNotification.call({
        'token': selectedUserToken,
        'sender': currentUserName,
        'message': 'あなたをSUPER LIKEしました！！'
      });
    } else {
      var messageHtml = '''<div>
                          <p>${selectedUserName}さん</p>
                          <p>${currentUserName}さんに新しくSUPER LIKEされました。<br>LIKEを返してマッチしましょう！</p>
                          <br>
                          <br>
                          <body style="text-align: center">
                            <a href="https://keioboys.page.link/m" 
                            style="border-radius: 5px;
                            background-color: #fa196e;
                            padding: 15px;
                            text-decoration: none;
                            color: white;
                            ">今すぐマッチ</a>
                          </body>
                          </div>''';
      final HttpsCallableResult result = await sendEmail.call({
        'email': '$selectedUserEmail',
        'subject': '【Keioboys】 新しいSUPER LIKEのお知らせ',
        'html': messageHtml,
      });
    }

    _fireStore
        .collection('users')
        .doc(currentUserId)
        .collection('iSuperLikeList')
        .doc(selectedUserId)
        .set({});

    _fireStore
        .collection('users')
        .doc(currentUserId)
        .collection('swipedList')
        .doc(selectedUserId)
        .set({});

    _fireStore
        .collection('users')
        .doc(selectedUserId)
        .collection('swipedList')
        .doc(currentUserId)
        .set({});

    _fireStore
        .collection('users')
        .doc(selectedUserId)
        .collection('superLikedList')
        .doc(currentUserId)
        .set({
      'name': currentUserName,
      'birthday': currentUserBirthday,
      'photo1': currentUserPhotoURL,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _fireStore.collection('users').doc(currentUserId).update({
      'cardCountToday': cardCountToday,
      'lastCardTime': FieldValue.serverTimestamp(),
      'superLikeCountToday': superLikeCountToday,
      'lastLikeTime': FieldValue.serverTimestamp(),
    });
    await _fireStore
        .collection('users')
        .doc(currentUserId)
        .collection('countList')
        .doc('counts')
        .get()
        .then((count) {
      iSuperLikeCount = count['iSuperLikeCount'];
    });

    _fireStore
        .collection('users')
        .doc(currentUserId)
        .collection('countList')
        .doc('counts')
        .update({
      'iSuperLikeCount': iSuperLikeCount + 1,
    });

    await _fireStore
        .collection('users')
        .doc(selectedUserId)
        .collection('countList')
        .doc('counts')
        .get()
        .then((count) {
      superLikedCount = count['superLikedCount'];
    });

    _fireStore
        .collection('users')
        .doc(selectedUserId)
        .collection('countList')
        .doc('counts')
        .update({
      'superLikedCount': superLikedCount + 1,
    });
  }

  void skip({
    currentUserId,
    selectedUserId,
    cardCountToday,
    selectedUserDecision,
  }) async {
    int iSkipCountLiked;
    int iSkipCountSuperLiked;
    int iSkipCountNotYet;
    int skippedCountILike;
    int skippedCountISuperLike;
    int skippedCountNotYet;
    _fireStore
        .collection('users')
        .doc(currentUserId)
        .collection('swipedList')
        .doc(selectedUserId)
        .set({});

    _fireStore.collection('users').doc(currentUserId).update({
      'cardCountToday': cardCountToday,
      'lastCardTime': FieldValue.serverTimestamp(),
    });

    if (selectedUserDecision == 'like') {
      _matchFB.deleteLikedUser(
        currentUserId,
        selectedUserId,
      );

      await _fireStore
          .collection('users')
          .doc(currentUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        iSkipCountLiked = count['iSkipCountLiked'];
      });

      _fireStore
          .collection('users')
          .doc(currentUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'iSkipCountLiked': iSkipCountLiked + 1,
      });
      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        skippedCountILike = count['skippedCountILike'];
      });
      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'skippedCountILike': skippedCountILike + 1,
      });
    } else if (selectedUserDecision == 'superLike') {
      _matchFB.deleteSuperLikedUser(
        currentUserId,
        selectedUserId,
      );
      await _fireStore
          .collection('users')
          .doc(currentUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        iSkipCountSuperLiked = count['iSkipCountSuperLiked'];
      });

      _fireStore
          .collection('users')
          .doc(currentUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'iSkipCountSuperLiked': iSkipCountSuperLiked + 1,
      });
      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        skippedCountISuperLike = count['skippedCountISuperLike'];
      });
      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'skippedCountISuperLike': skippedCountISuperLike + 1,
      });
    } else {
      await _fireStore
          .collection('users')
          .doc(currentUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        iSkipCountNotYet = count['iSkipCountNotYet'];
      });

      _fireStore
          .collection('users')
          .doc(currentUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'iSkipCountNotYet': iSkipCountNotYet + 1,
      });
      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        skippedCountNotYet = count['skippedCountNotYet'];
      });
      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'skippedCountNotYet': skippedCountNotYet + 1,
      });
    }

    //    await _fireStore
//        .collection('users')
//        .doc(searchUserId)
//        .collection(
//            'choosedlist') //相手のchoosedにも入れることでその相手には表示しないやつ、ユーザー少ないうちは表示する
//        .doc(currentUserId)
//        .set({});

//    return getUser(currentUserId);
  }

  Future getSearchUserList(currentUser) async {
    UserData _user = UserData();
    List _userList = [];
    var users;
    Future<QuerySnapshot> likedUserIds;
    Future<QuerySnapshot> superLikedUserIds;
    List<String> swipedList = [];
    Future getSwipedList;
//    List<String> selectedList = await getSelectedList(currentUser.uid);
//    likeされてる人の1/3 or max100人取得（10人にlikeされてるなら50人で3人）

    //selectedlist全部保存するかわり三人までにするとか？

    //superlikeはガチランダムでもいい？うーん

    getSwipedList = _fireStore
        .collection('users')
        .doc(currentUser.uid)
        .collection('swipedList')
        .get()
        .then((docs) {
      for (var doc in docs.docs) {
        if (docs.docs != null) {
          swipedList.add(doc.id);
        }
      }
    });

    likedUserIds = _fireStore
        .collection('users')
        .doc(currentUser.uid)
        .collection('likedList')
        .get();

    superLikedUserIds = _fireStore
        .collection('users')
        .doc(currentUser.uid)
        .collection('superLikedList')
        .get();

    List result =
        await Future.wait([getSwipedList, likedUserIds, superLikedUserIds]);
    List randomIndexListSelected = [];
    for (int i = 0;
        result[1].docs.length != 0 &&
            i <= ((result[1].docs.length * 1 / 3)).round() &&
//            i <= ((likedUserIds.docs.length * 1 / 3)).round() &&
            i < 100;
        i++) {
      try {
        int randomIndexSelected = math.Random().nextInt(result[1].docs.length);
        if (!randomIndexListSelected.contains(randomIndexSelected)) {
          randomIndexListSelected.add(randomIndexSelected);
          var selectedUserId = result[1].docs[randomIndexSelected].id;
          print('selectedUserId: ${selectedUserId}');
          var selectedUser =
              await _fireStore.collection('users').doc(selectedUserId).get();
          print('表示対象kamo: ${selectedUser.id}');
          _user.uid = selectedUser.id;
          _user.token = selectedUser['token'];
          _user.email = selectedUser['email'];
          _user.name = selectedUser['name'];
          _user.birthday = selectedUser['birthday'];
          _user.gender = selectedUser['gender'];
          _user.interestedGender = selectedUser['interestedGender'];
          _user.profile = selectedUser['profile'];
          _user.school = selectedUser['school'];
          _user.company = selectedUser['company'];
          _user.location = selectedUser['location'];
          _user.city = selectedUser['city'];
          _user.photo1 = selectedUser['photo1'];
          _user.photo2 = selectedUser['photo2'];
          _user.photo3 = selectedUser['photo3'];
          _user.photo4 = selectedUser['photo4'];
          _user.photo5 = selectedUser['photo5'];
          _user.photo6 = selectedUser['photo6'];
          _user.decision = 'like';
          _userList.add(_user);
          print('表示対象ですリストselected: ${selectedUser.id}');
          _user = UserData();
        }
      } catch (error) {
        print('error: $error');
      }
    }
    List randomIndexListSuperLike = [];

    for (int i = 0;
        result[2].docs.length != 0 &&
//        superLikedUserIds.docs.length != 0 &&
            i <= ((result[2].docs.length * 1 / 2)).round() &&
            i < 50;
        i++) {
      int randomIndexSuperLike = math.Random().nextInt(result[2].docs.length);
      if (!randomIndexListSuperLike.contains(randomIndexSuperLike)) {
        randomIndexListSuperLike.add(randomIndexSuperLike);
        var superLikedUserId = result[2].docs[randomIndexSuperLike].id;
        var superLikedUser =
            await _fireStore.collection('users').doc(superLikedUserId).get();
        _user.uid = superLikedUser.id;
        _user.token = superLikedUser['token'];
        _user.email = superLikedUser['email'];
        _user.name = superLikedUser['name'];
        _user.birthday = superLikedUser['birthday'];
        _user.gender = superLikedUser['gender'];
        _user.interestedGender = superLikedUser['interestedGender'];
        _user.profile = superLikedUser['profile'];
        _user.school = superLikedUser['school'];
        _user.company = superLikedUser['company'];
//        _user.address = superLikedUser['address'];
        _user.location = superLikedUser['location'];
        _user.city = superLikedUser['city'];
        _user.photo1 = superLikedUser['photo1'];
        _user.photo2 = superLikedUser['photo2'];
        _user.photo3 = superLikedUser['photo3'];
        _user.photo4 = superLikedUser['photo4'];
        _user.photo5 = superLikedUser['photo5'];
        _user.photo6 = superLikedUser['photo6'];
        _user.decision = 'superLike';
        _userList.add(_user);
        print('表示対象ですリストsuperLiked: ${superLikedUser.id}');
        _user = UserData();
      }
    }

    String oppositeGender;
    if (currentUser.gender == '男性') {
      oppositeGender = '女性';
    } else {
      oppositeGender = '男性';
    }

//    User _currentUsFerBasic = await getCurrentUserBasic(currentUser);
    if (lastSearchedUserScore == null) {
      if (currentUser.interestedGender == 'みんな') {
        users = await _fireStore
            .collection('users')
            .where(
              'visible',
              isEqualTo: true,
            )
            .where('interestedGender', whereIn: [currentUser.gender, 'みんな'])
//            .where('interestedGender', isNotEqualTo: oppositeGender)
            //TODO 動かすときどっちがはやいか試す
            .orderBy('score', descending: true)
            .startAt([math.Random().nextInt(60) + 40])
            .limit(
                50) //limit 多くてもあんま変わらん。//3:2.3 10:2.1 20:2.2 30(2):3.1 40(4): 2.5 50(4): 3.0 85(5):2.5 85(10)2.7:  85(13): 2.9
            .get();
      } else {
        users = await _fireStore
            .collection('users')
            .where(
              'visible',
              isEqualTo: true,
            )
            .where(
              'gender',
              isEqualTo: currentUser.interestedGender,
            )
            .where('interestedGender', whereIn: [currentUser.gender, 'みんな'])
            .orderBy('score', descending: true)
            .startAt([math.Random().nextInt(60) + 40])
            .limit(
                50) //limit 多くてもあんま変わらん。//3:2.3 10:2.1 20:2.2 30(2):3.1 40(4): 2.5 50(4): 3.0 85(5):2.5 85(10)2.7:  85(13): 2.9
            .get();
      }
    } else {
      if (currentUser.interestedGender == 'みんな') {
        users = await _fireStore
            .collection('users')
            .where(
              'visible',
              isEqualTo: true,
            )
            .where('interestedGender', whereIn: [currentUser.gender, 'みんな'])
            .orderBy('score', descending: true)
            .startAt([lastSearchedUserScore])
            .limit(50)
            .get();
      } else {
        users = await _fireStore
            .collection('users')
            .where(
              'visible',
              isEqualTo: true,
            )
            .where(
              'gender',
              isEqualTo: currentUser.interestedGender,
            )
            .where('interestedGender', whereIn: [currentUser.gender, 'みんな'])
            .orderBy('score', descending: true)
            .startAt([lastSearchedUserScore])
            .limit(50)
            .get();
      }
    }

    if (users.docs.length > 0) {
      lastSearchedUserScore = users.docs[users.docs.length - 1]['score'];
      if (lastSearchedUserScore < 40) {
        lastSearchedUserScore = math.Random().nextInt(40) + 60;
//        lastSearchedUserScore = null;
      }
    }

    for (var user in users.docs) {
      if ((!swipedList.contains(user.id)) &&
          (math.Random().nextInt(5) != 0) && //20%ドロップ.　whereに替える？いつか
          (user.id != currentUser.uid) &&
          ((currentUser.interestedGender == 'みんな')
              ? true
              : (currentUser.interestedGender == user['gender'])) &&
          ((user['interestedGender'] == 'みんな') // 年齢・距離で検索(あとまわし,whereでやる)
              ? true // とりあえず全員取っておいて、このスクリーニング分散してasyncでやるのは？（あとまわし）
              : (user['interestedGender'] == currentUser.gender))) {
        _user.uid = user.id;
        _user.token = user['token'];
        _user.token = user['email'];
        _user.name = user['name'];
        _user.birthday = user['birthday'];
        _user.gender = user['gender'];
        _user.interestedGender = user['interestedGender'];
        _user.profile = user['profile'];
        _user.school = user['school'];
        _user.company = user['company'];
//        _user.address = user['address'];
        _user.location = user['location'];
        _user.city = user['city'];
        _user.photo1 = user['photo1'];
        _user.photo2 = user['photo2'];
        _user.photo3 = user['photo3'];
        _user.photo4 = user['photo4'];
        _user.photo5 = user['photo5'];
        _user.photo6 = user['photo6'];
        _user.decision = 'notYet';
        _userList.add(_user);
        print('表示対象ですリスト: ${user.id}');
        _user = UserData();

//          } else {}
      } else {}
    }
//    await _fireStore
//        .collection('users')
//        //.orderBy('score')
//        .startAfter(lastsearchedUser)
//        .limit(
//            60) //limit 多くてもあんま変わらん。//3:2.3 10:2.1 20:2.2 30(2):3.1 40(4): 2.5 50(4): 3.0 85(5):2.5 85(10)2.7:  85(13): 2.9
//        .getdocs()
//        .then((users) {
//      lastsearchedUser = users.docs[users.docs.length - 1];
//      for (var user in users.docs) {
//        if ((!choosedList.contains(user.docID)) &&
//            (math.Random().nextInt(5) != 0) && //20%ドロップ
//            (user.docID != currentUser.uid) &&
//            ((currentUser.interestedGender == 'みんな')
//                ? true
//                : (currentUser.interestedGender ==
//                    user['gender'])) &&
//            ((user['interestedGender'] ==
//                    'みんな')
//                ? true
//                : (user['interestedGender'] == currentUser.gender))) {
//          _user.uid = user.docID;
//          _user.name = user['name'];
//          _user.age = user['age'];
//          _user.gender = user['gender'];
//          _user.interestedGender = user['interestedGender'];
//          _user.profile = user['profile'];
//          _user.school = user['school'];
//          _user.company = user['company'];
//          _user.address = user['address'];
//          _user.location = user['location'];
//          _user.city = user['city'];
//          _user.photo = user['photo'];
//          _userList.add(_user);
//          print('表示対象ですリスト: ${user.docID}');
//          _user = new User();
////          } else {}
//        } else {}
//      }
//    });

    _userList.shuffle();
    return _userList;
  }

//  Future getUserAndCurrentUserBasic(currentUserId) async {
//    print('表示するユーザーを検索しています');
//    User _user = new User();
//    List<String> choosedList = await getChoosedList(currentUserId);
//    print('choosedList: $choosedList');
//    User _currentUserBasic = await getCurrentUserBasic(currentUserId);
//    await _fireStore.collection('users').getdocs().then((users) {
//      for (var user in users.docs) {
//        print('表示対象か確認しています: ${user.docID}');
//        if ((!choosedList.contains(user.docID)) &&
//            (user.docID != currentUserId) &&
//            ((_currentUserBasic.interestedGender == 'みんな')
//                ? true
//                : (_currentUserBasic.interestedGender ==
//                    user['gender'])) &&
//            ((user['interestedGender'] == 'みんな')
//                ? true
//                : (user['interestedGender'] == _currentUserBasic.gender))) {
//          print('表示対象です: ${user.docID}');
//          _user.uid = user.docID;
//          _user.name = user['name'];
//          _user.age = user['age'];
//          _user.gender = user['gender'];
//          _user.interestedGender = user['interestedGender'];
//          _user.profile = user['profile'];
//          _user.school = user['school'];
//          _user.company = user['company'];
//          _user.address = user['address'];
//          _user.location = user['location'];
//          _user.city = user['city'];
//          _user.photo = user['photo'];
//          print('ユーザ情報が取得できました。');
//          break;
//        }
//      }
//    });
//    return [_user, _currentUserBasic];
//  }

  Future getSwipedList(userId) async {
    List<String> swipedList = [];
    await _fireStore
        .collection('users')
        .doc(userId)
        .collection('swipedList')
        .get()
        .then((docs) {
      for (var doc in docs.docs) {
        if (docs.docs != null) {
          swipedList.add(doc.id);
        }
      }
    });
    return swipedList;
  }

  Future getLikedList(userId) async {
    List<String> likedList = [];
    await _fireStore
        .collection('users')
        .doc(userId)
        .collection('likedList')
        .get()
        .then((docs) {
      for (var doc in docs.docs) {
        if (docs.docs != null) {
          likedList.add(doc.id);
        }
      }
    });
    return likedList;
  }

  Future getCurrentUserBasic(userId) async {
    UserData currentUser = UserData();
    await _fireStore.collection('users').doc(userId).get().then((user) {
      currentUser.uid = user['uid'];
      currentUser.name = user['name'];
      currentUser.birthday = user['birthday'];
      currentUser.gender = user['gender'];
      currentUser.interestedGender = user['interestedGender'];
      currentUser.photo1 = user['photo1'];
    });
    return currentUser;
  }

//  Future<List> getLikeCountList(userId) async {
//    int cardCount;
//    int likeCount;
//    int superLikeCount;
//    DateTime lastCardTime;
//    DateTime lastLikeTime;
//    DateTime lastSuperLikeTime;
//    await _fireStore.collection('users').doc(userId).get().then((user) {
//      cardCount = user['cardCount'];
//      lastCardTime = user['lastCardTime'].toDate();
//      likeCount = user['likeCount'];
//      lastLikeTime = user['lastLikeTime'].toDate();
//      superLikeCount = user['superLikeCount'];
//      lastSuperLikeTime = user['lastSuperLikeTime'].toDate();
//    });
//    print('lastCardTime: $lastCardTime');
//    return [
//      cardCount,
//      lastCardTime,
//      likeCount,
//      lastLikeTime,
//      superLikeCount,
//      lastSuperLikeTime,
//    ];
//  }
}

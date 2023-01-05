import 'package:Keioboys/MessageTab/Message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Keioboys/Widgets/UserData.dart';

class MessageFB {
  final FirebaseFirestore _fireStore;

  MessageFB({
    FirebaseFirestore fireStore,
  }) : _fireStore = fireStore ?? FirebaseFirestore.instance;

  Future sendMessage({
    Message message,
    bool isFirstMessage,
    String selectedUserName,
    String selectedUserPhoto1,
    String currentUserName,
    String currentUserPhoto1,
  }) async {
    int messagingCountLikedIAcceptLikeISend;
    int messagingCountILikeAcceptLikedISend;
    int messagingCountSuperLikedIAcceptSuperLikeISend;
    int messagingCountISuperLikeAcceptSuperLikedISend;

    int messagingCountLikedIAcceptSuperLikeISend;
    int messagingCountLikedIAcceptISend;

    int messagingCountSuperLikedIAcceptLikeISend;
    int messagingCountSuperLikedIAcceptISend;

    int messagingCountILikeAcceptSuperLikedISend;
    int messagingCountILikeAcceptedISend;

    int messagingCountISuperLikeAcceptLikedISend;
    int messagingCountISuperLikeAcceptedISend;

    int messagingCountLikedIAcceptLikeSent;
    int messagingCountILikeAcceptLikedSent;
    int messagingCountSuperLikedIAcceptSuperLikeSent;
    int messagingCountISuperLikeAcceptSuperLikedSent;

    int messagingCountLikedIAcceptSuperLikeSent;
    int messagingCountLikedIAcceptSent;

    int messagingCountSuperLikedIAcceptLikeSent;
    int messagingCountSuperLikedIAcceptSent;

    int messagingCountILikeAcceptSuperLikedSent;
    int messagingCountILikeAcceptedSent;

    int messagingCountISuperLikeAcceptLikedSent;
    int messagingCountISuperLikeAcceptedSent;

    try {
      _fireStore
          .collection('users')
          .doc(message.currentUserId)
          .collection('messagingList')
          .doc(message.selectedUserId)
          .collection('messages')
          .doc()
          .set({
        'text': message.text,
        'timestamp': FieldValue.serverTimestamp(),
        'fromMe': true
      });
      _fireStore
          .collection('users')
          .doc(message.selectedUserId)
          .collection('messagingList')
          .doc(message.currentUserId)
          .collection('messages')
          .doc()
          .set({
        'text': message.text,
        'timestamp': FieldValue.serverTimestamp(),
        'fromMe': false
      });

      if (isFirstMessage == true) {
        _fireStore
            .collection('users')
            .doc(message.currentUserId)
            .collection('messagingList')
            .doc(message.selectedUserId)
            .set({
          'lastMessageTime': FieldValue.serverTimestamp(),
          'lastOpenedTime': FieldValue.serverTimestamp(),
          'lastSelectedUserSentMessageTime': DateTime.now(),
          'currentUserDecision': message.currentUserDecision,
          'selectedUserDecision': message.selectedUserDecision,
          'firstMessageFromMe': true,
          'selectedUserName': selectedUserName,
          'selectedUserPhoto1': selectedUserPhoto1,
          'lastMessage': message.text,
        });
        _fireStore
            .collection('users')
            .doc(message.selectedUserId)
            .collection('messagingList')
            .doc(message.currentUserId)
            .set({
          'lastMessageTime': FieldValue.serverTimestamp(),
          'lastOpenedTime': DateTime.now(),
          'lastSelectedUserSentMessageTime': FieldValue.serverTimestamp(),
          'currentUserDecision': message.selectedUserDecision,
          'selectedUserDecision': message.currentUserDecision,
          'firstMessageFromMe': false,
          'selectedUserName': currentUserName,
          'selectedUserPhoto1': currentUserPhoto1,
          'lastMessage': message.text,
        });
        _fireStore
            .collection('users')
            .doc(message.currentUserId)
            .collection('matchList')
            .doc(message.selectedUserId)
            .delete();

        _fireStore
            .collection('users')
            .doc(message.selectedUserId)
            .collection('matchList')
            .doc(message.currentUserId)
            .delete();

        if (message.selectedUserDecision == 'like' &&
            message.currentUserDecision == 'acceptLike') {
          await _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountLikedIAcceptLikeISend =
                count['messagingCountLikedIAcceptLikeISend'];
          });

          _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountLikedIAcceptLikeISend':
                messagingCountLikedIAcceptLikeISend + 1,
          });

          await _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountLikedIAcceptLikeSent =
                count['messagingCountLikedIAcceptLikeSent'];
          });

          _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountLikedIAcceptLikeSent':
                messagingCountLikedIAcceptLikeSent + 1,
          });
        } else if (message.selectedUserDecision == 'acceptLike' &&
            message.currentUserDecision == 'like') {
          await _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountILikeAcceptLikedISend =
                count['messagingCountILikeAcceptLikedISend'];
          });

          _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountILikeAcceptLikedISend':
                messagingCountILikeAcceptLikedISend + 1,
          });

          await _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountILikeAcceptLikedSent =
                count['messagingCountILikeAcceptLikedSent'];
          });

          _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountILikeAcceptLikedSent':
                messagingCountILikeAcceptLikedSent + 1,
          });
        } else if (message.selectedUserDecision == 'superLike' &&
            message.currentUserDecision == 'acceptSuperLike') {
          await _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountSuperLikedIAcceptSuperLikeISend =
                count['messagingCountSuperLikedIAcceptSuperLikeISend'];
          });

          _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountSuperLikedIAcceptSuperLikeISend':
                messagingCountSuperLikedIAcceptSuperLikeISend + 1,
          });

          await _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountSuperLikedIAcceptSuperLikeSent =
                count['messagingCountSuperLikedIAcceptSuperLikeSent'];
          });

          _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountSuperLikedIAcceptSuperLikeSent':
                messagingCountSuperLikedIAcceptSuperLikeSent + 1,
          });
        } else if (message.selectedUserDecision == 'acceptSuperLike' &&
            message.currentUserDecision == 'superLike') {
          await _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountISuperLikeAcceptSuperLikedISend =
                count['messagingCountISuperLikeAcceptSuperLikedISend'];
          });

          _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountISuperLikeAcceptSuperLikedISend':
                messagingCountISuperLikeAcceptSuperLikedISend + 1,
          });

          await _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountISuperLikeAcceptSuperLikedSent =
                count['messagingCountISuperLikeAcceptSuperLikedSent'];
          });

          _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountISuperLikeAcceptSuperLikedSent':
                messagingCountISuperLikeAcceptSuperLikedSent + 1,
          });
        } else if (message.selectedUserDecision == 'like' &&
            message.currentUserDecision == 'acceptSuperLike') {
          await _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountLikedIAcceptSuperLikeISend =
                count['messagingCountLikedIAcceptSuperLikeISend'];
          });

          _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountLikedIAcceptSuperLikeISend':
                messagingCountLikedIAcceptSuperLikeISend + 1,
          });

          await _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountLikedIAcceptSuperLikeSent =
                count['messagingCountLikedIAcceptSuperLikeSent'];
          });

          _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountLikedIAcceptSuperLikeSent':
                messagingCountLikedIAcceptSuperLikeSent + 1,
          });
        } else if (message.selectedUserDecision == 'like' &&
            message.currentUserDecision == 'accept') {
          await _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountLikedIAcceptISend =
                count['messagingCountLikedIAcceptISend'];
          });

          _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountLikedIAcceptISend':
                messagingCountLikedIAcceptISend + 1,
          });

          await _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountLikedIAcceptSent =
                count['messagingCountLikedIAcceptSent'];
          });

          _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountLikedIAcceptSent':
                messagingCountLikedIAcceptSent + 1,
          });
        } else if (message.selectedUserDecision == 'superLike' &&
            message.currentUserDecision == 'acceptLike') {
          await _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountSuperLikedIAcceptLikeISend =
                count['messagingCountSuperLikedIAcceptLikeISend'];
          });

          _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountSuperLikedIAcceptLikeISend':
                messagingCountSuperLikedIAcceptLikeISend + 1,
          });

          await _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountSuperLikedIAcceptLikeSent =
                count['messagingCountSuperLikedIAcceptLikeSent'];
          });

          _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountSuperLikedIAcceptLikeSent':
                messagingCountSuperLikedIAcceptLikeSent + 1,
          });
        } else if (message.selectedUserDecision == 'superLike' &&
            message.currentUserDecision == 'accept') {
          await _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountSuperLikedIAcceptISend =
                count['messagingCountSuperLikedIAcceptISend'];
          });

          _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountSuperLikedIAcceptISend':
                messagingCountSuperLikedIAcceptISend + 1,
          });

          await _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountSuperLikedIAcceptSent =
                count['messagingCountSuperLikedIAcceptSent'];
          });

          _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountSuperLikedIAcceptSent':
                messagingCountSuperLikedIAcceptSent + 1,
          });
        } else if (message.selectedUserDecision == 'acceptSuperLike' &&
            message.currentUserDecision == 'like') {
          await _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountILikeAcceptSuperLikedISend =
                count['messagingCountILikeAcceptSuperLikedISend'];
          });

          _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountILikeAcceptSuperLikedISend':
                messagingCountILikeAcceptSuperLikedISend + 1,
          });

          await _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountILikeAcceptSuperLikedSent =
                count['messagingCountILikeAcceptSuperLikedSent'];
          });

          _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountILikeAcceptSuperLikedSent':
                messagingCountILikeAcceptSuperLikedSent + 1,
          });
        } else if (message.selectedUserDecision == 'accept' &&
            message.currentUserDecision == 'like') {
          await _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountILikeAcceptedISend =
                count['messagingCountILikeAcceptedISend'];
          });

          _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountILikeAcceptedISend':
                messagingCountILikeAcceptedISend + 1,
          });

          await _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountILikeAcceptedSent =
                count['messagingCountILikeAcceptedSent'];
          });

          _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountILikeAcceptedSent':
                messagingCountILikeAcceptedSent + 1,
          });
        } else if (message.selectedUserDecision == 'acceptLike' &&
            message.currentUserDecision == 'superLike') {
          await _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountISuperLikeAcceptLikedISend =
                count['messagingCountISuperLikeAcceptLikedISend'];
          });

          _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountISuperLikeAcceptLikedISend':
                messagingCountISuperLikeAcceptLikedISend + 1,
          });

          await _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountISuperLikeAcceptLikedSent =
                count['messagingCountISuperLikeAcceptLikedSent'];
          });

          _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountISuperLikeAcceptLikedSent':
                messagingCountISuperLikeAcceptLikedSent + 1,
          });
        } else if (message.selectedUserDecision == 'accept' &&
            message.currentUserDecision == 'superLike') {
          await _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountISuperLikeAcceptedISend =
                count['messagingCountISuperLikeAcceptedISend'];
          });

          _fireStore
              .collection('users')
              .doc(message.currentUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountISuperLikeAcceptedISend':
                messagingCountISuperLikeAcceptedISend + 1,
          });

          await _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .get()
              .then((count) {
            messagingCountISuperLikeAcceptedSent =
                count['messagingCountISuperLikeAcceptedSent'];
          });

          _fireStore
              .collection('users')
              .doc(message.selectedUserId)
              .collection('countList')
              .doc('counts')
              .update({
            'messagingCountISuperLikeAcceptedSent':
                messagingCountISuperLikeAcceptedSent + 1,
          });
        }
      } else {
        _fireStore
            .collection('users')
            .doc(message.currentUserId)
            .collection('messagingList')
            .doc(message.selectedUserId)
            .update({
          'lastMessageTime': FieldValue.serverTimestamp(),
          'lastMessage': message.text,
          'lastOpenedTime': FieldValue.serverTimestamp(),
        });
        _fireStore
            .collection('users')
            .doc(message.selectedUserId)
            .collection('messagingList')
            .doc(message.currentUserId)
            .update({
          'lastMessageTime': FieldValue.serverTimestamp(),
          'lastMessage': message.text,
          'lastSelectedUserSentMessageTime': FieldValue.serverTimestamp(),
        });
      }
    } catch (error) {
      print('error: $error');
    }
  }

  Future updateLastOpenedTime({currentUserId, selectedUserId}) async {
    _fireStore
        .collection('users')
        .doc(currentUserId)
        .collection('messagingList')
        .doc(selectedUserId)
        .update({
      'lastOpenedTime': DateTime.now(),
    });
  }

  Future sendReport({
    Message report,
    String reason,
  }) async {
    _fireStore.collection('reports_$reason').doc().set({
      'text': report.text,
      'senderId': report.currentUserId,
      'reportedId': report.selectedUserId,
      'timestamp': FieldValue.serverTimestamp(),
    });

//    int reported;
//    _fireStore
//        .collection('users')
//        .doc(report.selectedUserId)
//        .get()
//        .then((user) {
//      reported = user['reported'];
//    });
//    _fireStore.collection('users').doc(report.selectedUserId).update({
//      'reported': (reported != null) ? reported + 1 : 1,
//    });// これupdateinfoで

    _fireStore
        .collection('users')
        .doc(report.selectedUserId)
        .collection('reports_$reason')
        .doc()
        .set({
      'text': report.text,
      'senderId': report.currentUserId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future sendOpinion({
    String opinion,
    String currentUserId,
  }) async {
    _fireStore.collection('opinions').doc().set({
      'text': opinion,
      'senderId': currentUserId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future deleteMessage({
    String currentUserId,
    String selectedUserId,
  }) async {
    _fireStore
        .collection('users')
        .doc(currentUserId)
        .collection('messagingList')
        .doc(selectedUserId)
        .delete();
    _fireStore
        .collection('users')
        .doc(selectedUserId)
        .collection('messagingList')
        .doc(currentUserId)
        .delete();
  }

  Future sendStars({
    String numberOfStarsString,
    String currentUserId,
  }) async {
    int count;
    if (numberOfStarsString == 'oneStar') {
      await _fireStore
          .collection('usersCountList')
          .doc('reviewCounts')
          .get()
          .then((reviewCounts) {
        count = reviewCounts[numberOfStarsString];
      });
      _fireStore.collection('usersCountList').doc('reviewCounts').update({
        numberOfStarsString: count + 1,
      });
      _fireStore.collection('users').doc(currentUserId).update({
        'review': 1,
      });
    } else if (numberOfStarsString == 'twoStars') {
      await _fireStore
          .collection('usersCountList')
          .doc('reviewCounts')
          .get()
          .then((reviewCounts) {
        count = reviewCounts[numberOfStarsString];
      });
      _fireStore.collection('usersCountList').doc('reviewCounts').update({
        numberOfStarsString: count + 1,
      });
      _fireStore.collection('users').doc(currentUserId).update({
        'review': 2,
      });
    } else if (numberOfStarsString == 'threeStars') {
      await _fireStore
          .collection('usersCountList')
          .doc('reviewCounts')
          .get()
          .then((reviewCounts) {
        count = reviewCounts[numberOfStarsString];
      });
      _fireStore.collection('usersCountList').doc('reviewCounts').update({
        numberOfStarsString: count + 1,
      });
      _fireStore.collection('users').doc(currentUserId).update({
        'review': 3,
      });
    } else if (numberOfStarsString == 'fourStars') {
      await _fireStore
          .collection('usersCountList')
          .doc('reviewCounts')
          .get()
          .then((reviewCounts) {
        count = reviewCounts[numberOfStarsString];
      });
      _fireStore.collection('usersCountList').doc('reviewCounts').update({
        numberOfStarsString: count + 1,
      });
      _fireStore.collection('users').doc(currentUserId).update({
        'review': 4,
      });
    } else if (numberOfStarsString == 'fiveStars') {
      await _fireStore
          .collection('usersCountList')
          .doc('reviewCounts')
          .get()
          .then((reviewCounts) {
        count = reviewCounts[numberOfStarsString];
      });
      _fireStore.collection('usersCountList').doc('reviewCounts').update({
        numberOfStarsString: count + 1,
      });
      _fireStore.collection('users').doc(currentUserId).update({
        'review': 5,
      });
    }
  }

  Future unMatch({
    UserData currentUser,
    String selectedUserId,
    String selectedUserDecision,
    bool firstMessageFromMe,
  }) async {
    int unMatchCountLikedIAcceptLikeIFirstSend;
    int unMatchCountLikedIAcceptSuperLikeIFirstSend;
    int unMatchCountLikedIAcceptIFirstSend;

    int unMatchCountSuperLikedIAcceptLikeIFirstSend;
    int unMatchCountSuperLikedIAcceptSuperLikeIFirstSend;
    int unMatchCountSuperLikedIAcceptIFirstSend;

    int unMatchCountILikeAcceptLikedIFirstSend;
    int unMatchCountILikeAcceptSuperLikedIFirstSend;
    int unMatchCountILikeAcceptedIFirstSend;

    int unMatchCountISuperLikeAcceptLikedIFirstSend;
    int unMatchCountISuperLikeAcceptSuperLikedIFirstSend;
    int unMatchCountISuperLikeAcceptedIFirstSend;

    int unMatchCountLikedIAcceptLikeFirstSent;
    int unMatchCountLikedIAcceptSuperLikeFirstSent;
    int unMatchCountLikedIAcceptFirstSent;

    int unMatchCountSuperLikedIAcceptLikeFirstSent;
    int unMatchCountSuperLikedIAcceptSuperLikeFirstSent;
    int unMatchCountSuperLikedIAcceptFirstSent;

    int unMatchCountILikeAcceptLikedFirstSent;
    int unMatchCountILikeAcceptSuperLikedFirstSent;
    int unMatchCountILikeAcceptedFirstSent;

    int unMatchCountISuperLikeAcceptLikedFirstSent;
    int unMatchCountISuperLikeAcceptSuperLikedFirstSent;
    int unMatchCountISuperLikeAcceptedFirstSent;

    int unMatchedCountLikedIAcceptLikeIFirstSend;
    int unMatchedCountLikedIAcceptSuperLikeIFirstSend;
    int unMatchedCountLikedIAcceptIFirstSend;

    int unMatchedCountSuperLikedIAcceptLikeIFirstSend;
    int unMatchedCountSuperLikedIAcceptSuperLikeIFirstSend;
    int unMatchedCountSuperLikedIAcceptIFirstSend;

    int unMatchedCountILikeAcceptLikedIFirstSend;
    int unMatchedCountILikeAcceptSuperLikedIFirstSend;
    int unMatchedCountILikeAcceptedIFirstSend;

    int unMatchedCountISuperLikeAcceptLikedIFirstSend;
    int unMatchedCountISuperLikeAcceptSuperLikedIFirstSend;
    int unMatchedCountISuperLikeAcceptedIFirstSend;

    int unMatchedCountLikedIAcceptLikeFirstSent;
    int unMatchedCountLikedIAcceptSuperLikeFirstSent;
    int unMatchedCountLikedIAcceptFirstSent;

    int unMatchedCountSuperLikedIAcceptLikeFirstSent;
    int unMatchedCountSuperLikedIAcceptSuperLikeFirstSent;
    int unMatchedCountSuperLikedIAcceptFirstSent;

    int unMatchedCountILikeAcceptLikedFirstSent;
    int unMatchedCountILikeAcceptSuperLikedFirstSent;
    int unMatchedCountILikeAcceptedFirstSent;

    int unMatchedCountISuperLikeAcceptLikedFirstSent;
    int unMatchedCountISuperLikeAcceptSuperLikedFirstSent;
    int unMatchedCountISuperLikeAcceptedFirstSent;

    if (selectedUserDecision == 'like' &&
        currentUser.decision == 'acceptLike' &&
        firstMessageFromMe == true) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountLikedIAcceptLikeIFirstSend =
            count['unMatchCountLikedIAcceptLikeIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountLikedIAcceptLikeIFirstSend':
            unMatchCountLikedIAcceptLikeIFirstSend + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountILikeAcceptLikedFirstSent =
            count['unMatchedCountILikeAcceptLikedFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountILikeAcceptLikedFirstSent':
            unMatchedCountILikeAcceptLikedFirstSent + 1,
      });
    } else if (selectedUserDecision == 'like' &&
        currentUser.decision == 'acceptSuperLike' &&
        firstMessageFromMe == true) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountLikedIAcceptSuperLikeIFirstSend =
            count['unMatchCountLikedIAcceptSuperLikeIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountLikedIAcceptSuperLikeIFirstSend':
            unMatchCountLikedIAcceptSuperLikeIFirstSend + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountILikeAcceptSuperLikedFirstSent =
            count['unMatchedCountILikeAcceptSuperLikedFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountILikeAcceptSuperLikedFirstSent':
            unMatchedCountILikeAcceptSuperLikedFirstSent + 1,
      });
    } else if (selectedUserDecision == 'like' &&
        currentUser.decision == 'accept' &&
        firstMessageFromMe == true) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountLikedIAcceptIFirstSend =
            count['unMatchCountLikedIAcceptIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountLikedIAcceptIFirstSend':
            unMatchCountLikedIAcceptIFirstSend + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountILikeAcceptedFirstSent =
            count['unMatchedCountILikeAcceptedFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountILikeAcceptedFirstSent':
            unMatchedCountILikeAcceptedFirstSent + 1,
      });
    } else if (selectedUserDecision == 'superLike' &&
        currentUser.decision == 'like' &&
        firstMessageFromMe == true) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountSuperLikedIAcceptLikeIFirstSend =
            count['unMatchCountSuperLikedIAcceptLikeIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountSuperLikedIAcceptLikeIFirstSend':
            unMatchCountSuperLikedIAcceptLikeIFirstSend + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountISuperLikeAcceptLikedFirstSent =
            count['unMatchedCountISuperLikeAcceptLikedFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountISuperLikeAcceptLikedFirstSent':
            unMatchedCountISuperLikeAcceptLikedFirstSent + 1,
      });
    } else if (selectedUserDecision == 'superLike' &&
        currentUser.decision == 'superLike' &&
        firstMessageFromMe == true) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountSuperLikedIAcceptSuperLikeIFirstSend =
            count['unMatchCountSuperLikedIAcceptSuperLikeIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountSuperLikedIAcceptSuperLikeIFirstSend':
            unMatchCountSuperLikedIAcceptSuperLikeIFirstSend + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountISuperLikeAcceptSuperLikedFirstSent =
            count['unMatchedCountISuperLikeAcceptSuperLikedFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountISuperLikeAcceptSuperLikedFirstSent':
            unMatchedCountISuperLikeAcceptSuperLikedFirstSent + 1,
      });
    } else if (selectedUserDecision == 'superLike' &&
        currentUser.decision == 'accept' &&
        firstMessageFromMe == true) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountSuperLikedIAcceptIFirstSend =
            count['unMatchCountSuperLikedIAcceptIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountSuperLikedIAcceptIFirstSend':
            unMatchCountSuperLikedIAcceptIFirstSend + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountISuperLikeAcceptedFirstSent =
            count['unMatchedCountISuperLikeAcceptedFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountISuperLikeAcceptedFirstSent':
            unMatchedCountISuperLikeAcceptedFirstSent + 1,
      });
    } else if (selectedUserDecision == 'acceptLike' &&
        currentUser.decision == 'like' &&
        firstMessageFromMe == true) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountILikeAcceptLikedIFirstSend =
            count['unMatchCountILikeAcceptLikedIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountILikeAcceptLikedIFirstSend':
            unMatchCountILikeAcceptLikedIFirstSend + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountLikedIAcceptLikeFirstSent =
            count['unMatchedCountLikedIAcceptLikeFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountLikedIAcceptLikeFirstSent':
            unMatchedCountLikedIAcceptLikeFirstSent + 1,
      });
    } else if (selectedUserDecision == 'acceptSuperLike' &&
        currentUser.decision == 'like' &&
        firstMessageFromMe == true) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountILikeAcceptSuperLikedIFirstSend =
            count['unMatchCountILikeAcceptSuperLikedIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountILikeAcceptSuperLikedIFirstSend':
            unMatchCountILikeAcceptSuperLikedIFirstSend + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountLikedIAcceptSuperLikeFirstSent =
            count['unMatchedCountLikedIAcceptSuperLikeFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountLikedIAcceptSuperLikeFirstSent':
            unMatchedCountLikedIAcceptSuperLikeFirstSent + 1,
      });
    } else if (selectedUserDecision == 'accept' &&
        currentUser.decision == 'like' &&
        firstMessageFromMe == true) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountILikeAcceptedIFirstSend =
            count['unMatchCountILikeAcceptedIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountILikeAcceptedIFirstSend':
            unMatchCountILikeAcceptedIFirstSend + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountLikedIAcceptFirstSent =
            count['unMatchedCountLikedIAcceptFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountLikedIAcceptFirstSent':
            unMatchedCountLikedIAcceptFirstSent + 1,
      });
    } else if (selectedUserDecision == 'like' &&
        currentUser.decision == 'superLike' &&
        firstMessageFromMe == true) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountISuperLikeAcceptLikedIFirstSend =
            count['unMatchCountISuperLikeAcceptLikedIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountISuperLikeAcceptLikedIFirstSend':
            unMatchCountISuperLikeAcceptLikedIFirstSend + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountSuperLikedIAcceptLikeFirstSent =
            count['unMatchedCountSuperLikedIAcceptLikeFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountSuperLikedIAcceptLikeFirstSent':
            unMatchedCountSuperLikedIAcceptLikeFirstSent + 1,
      });
    } else if (selectedUserDecision == 'acceptSuperLike' &&
        currentUser.decision == 'superLike' &&
        firstMessageFromMe == true) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountISuperLikeAcceptSuperLikedIFirstSend =
            count['unMatchCountISuperLikeAcceptSuperLikedIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountISuperLikeAcceptSuperLikedIFirstSend':
            unMatchCountISuperLikeAcceptSuperLikedIFirstSend + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountSuperLikedIAcceptSuperLikeFirstSent =
            count['unMatchedCountSuperLikedIAcceptSuperLikeFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountSuperLikedIAcceptSuperLikeFirstSent':
            unMatchedCountSuperLikedIAcceptSuperLikeFirstSent + 1,
      });
    } else if (selectedUserDecision == 'accept' &&
        currentUser.decision == 'superLike' &&
        firstMessageFromMe == true) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountISuperLikeAcceptedIFirstSend =
            count['unMatchCountISuperLikeAcceptedIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountISuperLikeAcceptedIFirstSend':
            unMatchCountISuperLikeAcceptedIFirstSend + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountSuperLikedIAcceptFirstSent =
            count['unMatchedCountSuperLikedIAcceptFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountSuperLikedIAcceptFirstSent':
            unMatchedCountSuperLikedIAcceptFirstSent + 1,
      });
    } else if (selectedUserDecision == 'like' &&
        currentUser.decision == 'acceptLike' &&
        firstMessageFromMe == false) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountLikedIAcceptLikeFirstSent =
            count['unMatchCountLikedIAcceptLikeFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountLikedIAcceptLikeFirstSent':
            unMatchCountLikedIAcceptLikeFirstSent + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountILikeAcceptLikedIFirstSend =
            count['unMatchedCountILikeAcceptLikedIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountILikeAcceptLikedIFirstSend':
            unMatchedCountILikeAcceptLikedIFirstSend + 1,
      });
    } else if (selectedUserDecision == 'like' &&
        currentUser.decision == 'acceptSuperLike' &&
        firstMessageFromMe == false) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountLikedIAcceptSuperLikeFirstSent =
            count['unMatchCountLikedIAcceptSuperLikeFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountLikedIAcceptSuperLikeFirstSent':
            unMatchCountLikedIAcceptSuperLikeFirstSent + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountILikeAcceptSuperLikedIFirstSend =
            count['unMatchedCountILikeAcceptSuperLikedIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountILikeAcceptSuperLikedIFirstSend':
            unMatchedCountILikeAcceptSuperLikedIFirstSend + 1,
      });
    } else if (selectedUserDecision == 'like' &&
        currentUser.decision == 'accept' &&
        firstMessageFromMe == false) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountLikedIAcceptFirstSent =
            count['unMatchCountLikedIAcceptFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountLikedIAcceptFirstSent':
            unMatchCountLikedIAcceptFirstSent + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountILikeAcceptedIFirstSend =
            count['unMatchedCountILikeAcceptedIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountILikeAcceptedIFirstSend':
            unMatchedCountILikeAcceptedIFirstSend + 1,
      });
    } else if (selectedUserDecision == 'superLike' &&
        currentUser.decision == 'like' &&
        firstMessageFromMe == false) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountSuperLikedIAcceptLikeFirstSent =
            count['unMatchCountSuperLikedIAcceptLikeFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountSuperLikedIAcceptLikeFirstSent':
            unMatchCountSuperLikedIAcceptLikeFirstSent + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountISuperLikeAcceptLikedIFirstSend =
            count['unMatchedCountISuperLikeAcceptLikedIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountISuperLikeAcceptLikedIFirstSend':
            unMatchedCountISuperLikeAcceptLikedIFirstSend + 1,
      });
    } else if (selectedUserDecision == 'superLike' &&
        currentUser.decision == 'superLike' &&
        firstMessageFromMe == false) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountSuperLikedIAcceptSuperLikeFirstSent =
            count['unMatchCountSuperLikedIAcceptSuperLikeFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountSuperLikedIAcceptSuperLikeFirstSent':
            unMatchCountSuperLikedIAcceptSuperLikeFirstSent + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountISuperLikeAcceptSuperLikedIFirstSend =
            count['unMatchedCountISuperLikeAcceptSuperLikedIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountISuperLikeAcceptSuperLikedIFirstSend':
            unMatchedCountISuperLikeAcceptSuperLikedIFirstSend + 1,
      });
    } else if (selectedUserDecision == 'superLike' &&
        currentUser.decision == 'accept' &&
        firstMessageFromMe == false) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountSuperLikedIAcceptFirstSent =
            count['unMatchCountSuperLikedIAcceptFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountSuperLikedIAcceptFirstSent':
            unMatchCountSuperLikedIAcceptFirstSent + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountISuperLikeAcceptedIFirstSend =
            count['unMatchedCountISuperLikeAcceptedIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountISuperLikeAcceptedIFirstSend':
            unMatchedCountISuperLikeAcceptedIFirstSend + 1,
      });
    } else if (selectedUserDecision == 'acceptLike' &&
        currentUser.decision == 'like' &&
        firstMessageFromMe == false) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountILikeAcceptLikedFirstSent =
            count['unMatchCountILikeAcceptLikedFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountILikeAcceptLikedFirstSent':
            unMatchCountILikeAcceptLikedFirstSent + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountLikedIAcceptLikeIFirstSend =
            count['unMatchedCountLikedIAcceptLikeIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountLikedIAcceptLikeIFirstSend':
            unMatchedCountLikedIAcceptLikeIFirstSend + 1,
      });
    } else if (selectedUserDecision == 'acceptSuperLike' &&
        currentUser.decision == 'like' &&
        firstMessageFromMe == false) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountILikeAcceptSuperLikedFirstSent =
            count['unMatchCountILikeAcceptSuperLikedFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountILikeAcceptSuperLikedFirstSent':
            unMatchCountILikeAcceptSuperLikedFirstSent + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountLikedIAcceptSuperLikeIFirstSend =
            count['unMatchedCountLikedIAcceptSuperLikeIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountLikedIAcceptSuperLikeIFirstSend':
            unMatchedCountLikedIAcceptSuperLikeIFirstSend + 1,
      });
    } else if (selectedUserDecision == 'accept' &&
        currentUser.decision == 'like' &&
        firstMessageFromMe == false) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountILikeAcceptedFirstSent =
            count['unMatchCountILikeAcceptedFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountILikeAcceptedFirstSent':
            unMatchCountILikeAcceptedFirstSent + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountLikedIAcceptIFirstSend =
            count['unMatchedCountLikedIAcceptIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountLikedIAcceptIFirstSend':
            unMatchedCountLikedIAcceptIFirstSend + 1,
      });
    } else if (selectedUserDecision == 'like' &&
        currentUser.decision == 'superLike' &&
        firstMessageFromMe == false) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountISuperLikeAcceptLikedFirstSent =
            count['unMatchCountISuperLikeAcceptLikedFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountISuperLikeAcceptLikedFirstSent':
            unMatchCountISuperLikeAcceptLikedFirstSent + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountSuperLikedIAcceptLikeIFirstSend =
            count['unMatchedCountSuperLikedIAcceptLikeIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountSuperLikedIAcceptLikeIFirstSend':
            unMatchedCountSuperLikedIAcceptLikeIFirstSend + 1,
      });
    } else if (selectedUserDecision == 'acceptSuperLike' &&
        currentUser.decision == 'superLike' &&
        firstMessageFromMe == false) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountISuperLikeAcceptSuperLikedFirstSent =
            count['unMatchCountISuperLikeAcceptSuperLikedFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountISuperLikeAcceptSuperLikedFirstSent':
            unMatchCountISuperLikeAcceptSuperLikedFirstSent + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountSuperLikedIAcceptSuperLikeIFirstSend =
            count['unMatchedCountSuperLikedIAcceptSuperLikeIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountSuperLikedIAcceptSuperLikeIFirstSend':
            unMatchedCountSuperLikedIAcceptSuperLikeIFirstSend + 1,
      });
    } else if (selectedUserDecision == 'accept' &&
        currentUser.decision == 'superLike' &&
        firstMessageFromMe == false) {
      await _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchCountISuperLikeAcceptedFirstSent =
            count['unMatchCountISuperLikeAcceptedFirstSent'];
      });

      _fireStore
          .collection('users')
          .doc(currentUser.uid)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchCountISuperLikeAcceptedFirstSent':
            unMatchCountISuperLikeAcceptedFirstSent + 1,
      });

      await _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .get()
          .then((count) {
        unMatchedCountSuperLikedIAcceptIFirstSend =
            count['unMatchedCountSuperLikedIAcceptIFirstSend'];
      });

      _fireStore
          .collection('users')
          .doc(selectedUserId)
          .collection('countList')
          .doc('counts')
          .update({
        'unMatchedCountSuperLikedIAcceptIFirstSend':
            unMatchedCountSuperLikedIAcceptIFirstSend + 1,
      });
    }

    _fireStore
        .collection('users')
        .doc(currentUser.uid)
        .collection('messagingList')
        .doc(selectedUserId)
        .delete();

//    _fireStore
//        .collection('users')
//        .doc(currentUserId)
//        .collection('messagingList')
//        .doc(matchUserId)
//        .collection('messages')
//        .getdocs()
//        .then((docs) {
//      for (var doc in docs.docs) {
//        if (docs.docs != null) {
//          doc.reference.delete();
//        }
//      }
//    });//メッセージのこってる

    _fireStore
        .collection('users')
        .doc(selectedUserId)
        .collection('messagingList')
        .doc(currentUser.uid)
        .delete();

//    _fireStore
//        .collection('users')
//        .doc(matchUserId)
//        .collection('messagingList')
//        .doc(currentUserId)
//        .collection('messages')
//        .getdocs()
//        .then((docs) {
//      for (var doc in docs.docs) {
//        if (docs.docs != null) {
//          doc.reference.delete();
//        }
//      }
//    });//メッセージのこってる
  }

  Future getToken({userId}) async {
    String token;
    await _fireStore.collection('users').doc(userId).get().then((user) {
      token = user['token'];
    });
    return token;
  }

  Future getEmail({userId}) async {
    String email;
    await _fireStore.collection('users').doc(userId).get().then((user) {
      email = user['email'];
    });
    return email;
  }

  Stream<QuerySnapshot> getMessage({currentUserId, selectedUserId}) {
    return _fireStore
        .collection('users')
        .doc(currentUserId)
        .collection('messagingList')
        .doc(selectedUserId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(10000)
        .snapshots(includeMetadataChanges: true);
  }

  Stream<QuerySnapshot> getNotification() {
    return _fireStore
        .collection('state')
        .doc('notification')
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(10000)
        .snapshots();
  }
}

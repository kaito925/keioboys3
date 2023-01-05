//著作ok

import 'package:Keioboys/MessageTab/Message.dart';
import 'package:Keioboys/Widgets/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageListFB {
  final FirebaseFirestore _fireStore;

  MessageListFB({
    FirebaseFirestore fireStore,
  }) : _fireStore = fireStore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessageList({currentUserId}) {
    return _fireStore
        .collection('users')
        .doc(currentUserId)
        .collection('messagingList')
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

//  Future deleteShowMessage({currentUserId, selectedUserId}) async {
//    await _fireStore
//        .collection('users')
//        .document(currentUserId)
//        .collection('chats')
//        .document(selectedUserId)
//        .delete();
//  }

//  Future<User> getUserDetail({userId}) async {
//    User _user = User();
//
//    await _fireStore.collection('users').document(userId).get().then((user) {
//      _user.uid = user.documentID;
//      _user.token = user['token'];
//      _user.name = user['name'];
//      _user.birthday = user['birthday'];
//      _user.gender = user['gender'];
//      _user.interestedGender = user['interestedGender'];
//      _user.profile = user['profile'];
//      _user.school = user['school'];
//      _user.company = user['company'];
//      _user.location = user['location'];
//      _user.city = user['city'];
//      _user.photo1 = user['photo1'];
//      _user.photo2 = user['photo2'];
//      _user.photo3 = user['photo3'];
//      _user.photo4 = user['photo4'];
//      _user.photo5 = user['photo5'];
//      _user.photo6 = user['photo6'];
//    });
//
//    return _user;
//  }

  Future<Message> getLastMessage({currentUserId, selectedUserId}) async {
    Message _message = Message();

    await _fireStore
        .collection('users')
        .doc(currentUserId)
        .collection('messagingList')
        .doc(selectedUserId)
        .collection('messages')
        .limit(1)
        .orderBy('timestamp', descending: true)
        .get()
//    snapshots()
//        .first
        .then((message) async {
//      await _fireStore
//          .collection('messages')
//          .document(doc.documents.first.documentID)
//          .get()
//          .then((message) {
//        _message.text = message['text'];
////        _message.photo = message['photo'];
//        _message.timeStamp = message['timestamp'];
//      });
//    });

      _message.text = message.docs[0]['text'];
      _message.timeStamp = message.docs[0]['timestamp'];
    });
    return _message;
  }
}

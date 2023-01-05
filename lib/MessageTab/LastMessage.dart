import 'package:cloud_firestore/cloud_firestore.dart';

class LastMessage {
//  String name;
//  String photo;
//  String lastMessagePhoto;
  Timestamp timestamp;
  String lastMessage;

  LastMessage({
//    this.lastMessagePhoto,
//    this.photo,
//    this.name,
    this.timestamp,
    this.lastMessage,
  });
}

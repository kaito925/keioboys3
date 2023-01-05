import 'dart:io';
//import 'package:universal_io/io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String senderName;
  String currentUserId;
  String selectedUserId;
  String text;
  String photoUrl;
  File photo;
  Timestamp timeStamp;
  String currentUserDecision;
  String selectedUserDecision;

  Message({
    this.text,
    this.senderName,
    this.currentUserId,
    this.photo,
    this.photoUrl,
    this.selectedUserId,
    this.timeStamp,
    this.currentUserDecision,
    this.selectedUserDecision,
  });
}

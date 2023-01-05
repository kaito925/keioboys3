//著作ok 移動したい

import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String uid;
  String token;
  String email;
  String name;
  Timestamp birthday;
  String gender;
  String interestedGender;
  String profile;
  String school;
  String company;
//  String address;
  GeoPoint location;
  String city;
  bool visible;
//  String preciseAddress;
  String photo1;
  String photo2;
  String photo3;
  String photo4;
  String photo5;
  String photo6;
//  String photo7;
//  String photo8;
//  String photo9;
  String decision;
  int openToday;
  int open2Weeks;
  int openTotal;
  var score;
  int cardCountToday;
  Timestamp lastCardTime;
  int likeCountToday;
  Timestamp lastLikeTime;
  int superLikeCountToday;
  Timestamp lastSuperLikeTime;
  Timestamp boostEndTime;
  Timestamp superBoostEndTime;
  Timestamp registerDate;
  Timestamp lastCheckedNotificationTime;
  bool ageVerification;
  int review;

  UserData({
    this.uid,
    this.name,
    this.birthday,
    this.gender,
    this.interestedGender,
    this.profile,
    this.school,
    this.company,
//    this.address,
    this.location,
    this.city,
//    this.preciseAddress,
    this.photo1,
    this.photo2,
    this.photo3,
    this.photo4,
    this.photo5,
    this.photo6,
//    this.photo7,
//    this.photo8,
//    this.photo9,
    this.decision,
    this.openToday,
    this.open2Weeks,
    this.openTotal,
    this.score,
    this.cardCountToday,
    this.lastCardTime,
    this.likeCountToday,
    this.lastLikeTime,
    this.superLikeCountToday,
    this.lastSuperLikeTime,
    this.boostEndTime,
    this.superBoostEndTime,
    this.registerDate,
    this.lastCheckedNotificationTime,
    this.ageVerification,
    this.review,
  });
}

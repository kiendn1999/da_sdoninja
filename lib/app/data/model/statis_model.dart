import 'package:cloud_firestore/cloud_firestore.dart';

class StatisModel {
  String? id;
  int? all;
  int? five;
  int? four;
  int? one;
  num? rating;
  String? storeID;
  int? three;
  int? two;
  int? ratingTotal;

  StatisModel({
    this.id,
    this.all = 0,
    this.five = 0,
    this.four = 0,
    this.one = 0,
    this.rating = 0,
    this.storeID,
    this.three = 0,
    this.two = 0,
    this.ratingTotal=0
  });

  Map<String, dynamic> toMap() {
    return {
      'all': all,
      'five': five,
      'four': four,
      'one': one,
      'rating': rating,
      'store_id': storeID,
      'three': three,
      'two': two,
      'rating_total':ratingTotal
    };
  }

  factory StatisModel.fromMap(DocumentSnapshot data) {
    return StatisModel(
      id: data.id,
      all: data['all'],
      five: data['five'],
      four: data['four'],
      one: data['one'],
      rating: data['rating'],
      storeID: data['store_id'],
      three: data['three'],
      two: data['two'],
      ratingTotal: data['rating_total']
    );
  }
}

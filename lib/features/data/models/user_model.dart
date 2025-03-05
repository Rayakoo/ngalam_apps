import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tes_gradle/features/domain/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.nomer_induk_kependudukan,
    required super.name,
    required super.email,
    required super.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nomer_induk_kependudukan: json['nomer_induk_kependudukan'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomer_induk_kependudukan': nomer_induk_kependudukan,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
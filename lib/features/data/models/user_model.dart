import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tes_gradle/features/domain/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.nomer_induk_kependudukan,
    required super.name,
    required super.email,
    required super.password,
    this.photoProfile =
        'https://th.bing.com/th/id/OIP.hGSCbXlcOjL_9mmzerqAbQHaHa?w=182&h=182&c=7&r=0&o=5&dpr=1.3&pid=1.7', 
    this.address = '-', 
    this.role = 'user',
  });

  final String photoProfile;
  final String address;
  final String role;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nomer_induk_kependudukan: json['nomer_induk_kependudukan'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      photoProfile:
          json['photoProfile'] ??
          'https://th.bing.com/th/id/OIP.hGSCbXlcOjL_9mmzerqAbQHaHa?w=182&h=182&c=7&r=0&o=5&dpr=1.3&pid=1.7',
      address: json['address'] ?? '-',
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nomer_induk_kependudukan': nomer_induk_kependudukan,
      'name': name,
      'email': email,
      'password': password,
      'photoProfile': photoProfile,
      'address': address,
      'role': role,
    };
  }
}

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.role,
    required super.image,
    required super.age,
    required super.phone,
    required super.gender,
    required super.birthDate,
    required super.hair,
    required super.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      role: json['role'],
      image: json['image'],
      age: json['age'],
      phone: json['phone'],
      gender: json['gender'],
      birthDate: json['birthDate'],
      hair: json['hair'] ?? {},
      address: json['address'] ?? {},
    );
  }
}

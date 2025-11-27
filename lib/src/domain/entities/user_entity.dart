import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String image;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.image,
  });

  @override
  List<Object> get props => [
    id,
    username,
    email,
    firstName,
    lastName,
    role,
    image,
  ];
}

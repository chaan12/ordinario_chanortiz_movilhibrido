class UserEntity {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String image;

  final int age;
  final String phone;
  final String gender;
  final String birthDate;

  final Map<String, dynamic> hair;
  final Map<String, dynamic> address;

  UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.image,
    required this.age,
    required this.phone,
    required this.gender,
    required this.birthDate,
    required this.hair,
    required this.address,
  });
}

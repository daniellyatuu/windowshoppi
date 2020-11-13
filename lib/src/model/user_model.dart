import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final List<UserBusiness> userBusiness;
  final List<PhoneNumber> phoneNumber;

  const User({
    this.id,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.userBusiness,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      userBusiness: (json['user_business'] as List)
          .map((i) => UserBusiness.fromJson(i))
          .toList(),
      phoneNumber: (json['phone_numbers'] as List)
          .map((i) => PhoneNumber.fromJson(i))
          .toList(),
    );
  }

  @override
  List<Object> get props => [
        id,
        username,
        firstName,
        lastName,
        email,
        userBusiness,
        phoneNumber,
      ];
}

class UserBusiness {
  final String name;
  final String bio;
  final String location;

  UserBusiness({this.name, this.bio, this.location});

  factory UserBusiness.fromJson(Map<String, dynamic> json) {
    return UserBusiness(
      name: json['name'],
      bio: json['bio'],
      location: json['user_business'],
    );
  }
}

class PhoneNumber {
  final String callNumber;
  final String whatsappNumber;

  PhoneNumber({this.callNumber, this.whatsappNumber});

  factory PhoneNumber.fromJson(Map<String, dynamic> json) {
    return PhoneNumber(
      callNumber: json['call'],
      whatsappNumber: json['whatsapp'],
    );
  }
}

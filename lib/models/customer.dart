class CustomerModel {
  String email;
  String firstName;
  String lastName;
  String password;

  CustomerModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    map.addAll({
      'email':email,
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
      'username': email,
    });

    return map;
  }
}

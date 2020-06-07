class User {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String password;

  User(this.id, this.fullName, this.phoneNumber, this.email, this.password);

  static List<User> usertListFromJson(List collection) {
    List<User> userlist =
        collection.map((json) => User.fromJson(json)).toList();
    return userlist;
  }

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        fullName = json['fullName'],
        phoneNumber = json['phoneNumber'],
        email = json['email'],
        password = '*************';
}
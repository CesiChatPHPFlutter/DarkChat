class User {
  int? user_id;
  String? name;
  String? mail;
  String? password;

  User({this.user_id, this.name, this.mail, this.password});

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'name': name,
      'mail': mail,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      user_id: map['user_id'],
      name: map['name'],
      mail: map['mail'],
      password: map['password'],
    );
  }
}

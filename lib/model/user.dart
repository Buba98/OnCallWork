class User {
  String name;
  String surname;
  String bio;

  User({
    required this.name,
    required this.surname,
    required this.bio,
  });

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        surname = json['surname'],
        bio = json['bio'];

  Map<String, dynamic> get json => {
        'name': name,
        'surname': surname,
        'bio': bio,
      };
}

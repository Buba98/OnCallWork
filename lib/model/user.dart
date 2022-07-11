class User {
  String uid;
  String name;
  String surname;
  String bio;

  User({
    required this.uid,
    required this.name,
    required this.surname,
    required this.bio,
  });

  User.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        surname = json['surname'],
        bio = json['bio'];

  Map<String, dynamic> get json => {
        'uid': uid,
        'name': name,
        'surname': surname,
        'bio': bio,
      };
}

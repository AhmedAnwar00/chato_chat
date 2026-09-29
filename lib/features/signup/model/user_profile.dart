class UserProfile {
  const UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    required this.createdAt,
  });

  final String uid;
  final String email;
  final String name;
  final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'createdAt': createdAt,
    };
  }
}

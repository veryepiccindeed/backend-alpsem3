class UserProfile {
  final int id;
  final String name;
  final String email;
  final String? profilePictureUrl; // Optional field

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.profilePictureUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profilePictureUrl: json['profile_picture_url'],
    );
  }
}
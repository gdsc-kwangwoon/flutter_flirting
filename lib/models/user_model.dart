class UserModel {
  final String? username;
  final String? bio;
  final String? image;
  final bool? following;

  const UserModel({
    this.username,
    this.bio,
    this.image,
    this.following,
  });

  UserModel copyWith({
    String? username,
    String? bio,
    String? image,
    bool? following,
  }) =>
      UserModel(
        username: username ?? this.username,
        bio: bio ?? this.bio,
        image: image ?? this.image,
        following: following ?? this.following,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      bio: json['bio'],
      image: json['image'],
      following: json['following'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'bio': bio,
      'image': image,
      'following': following,
    };
  }

  @override
  String toString() {
    return 'UserModel(username: $username, bio: $bio, image: $image, following: $following)';
  }
}

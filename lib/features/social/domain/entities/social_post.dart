import 'package:equatable/equatable.dart';

class SocialPost extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String? userImageUrl;
  final String content;
  final List<String> imageUrls;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;
  final bool isLikedByMe;

  const SocialPost({
    required this.id,
    required this.userId,
    required this.userName,
    this.userImageUrl,
    required this.content,
    required this.imageUrls,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
    this.isLikedByMe = false,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        userImageUrl,
        content,
        imageUrls,
        likesCount,
        commentsCount,
        createdAt,
        isLikedByMe
      ];
}

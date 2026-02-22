import '../../domain/entities/social_post.dart';
import '../../domain/repositories/social_repository.dart';

class MockSocialService implements SocialRepository {
  final List<SocialPost> _posts = [
    SocialPost(
      id: '1',
      userId: 'u1',
      userName: 'Ayesha Malik',
      userImageUrl: 'https://i.pravatar.cc/150?u=ayesha',
      content:
          'The Mehndi decor was absolutely stunning! ✨ Everything looked so magical.',
      imageUrls: const [
        'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=800'
      ],
      likesCount: 24,
      commentsCount: 5,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    SocialPost(
      id: '2',
      userId: 'u2',
      userName: 'Zaid Khan',
      userImageUrl: 'https://i.pravatar.cc/150?u=zaid',
      content:
          'Found the perfect Sherwani today. The countdown begins! 🤵‍♂️ #WeddingOS #DulhaLife',
      imageUrls: const [],
      likesCount: 42,
      commentsCount: 12,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

  @override
  Future<List<SocialPost>> getPosts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(
        _posts..sort((a, b) => b.createdAt.compareTo(a.createdAt)));
  }

  @override
  Future<void> createPost(SocialPost post) async {
    await Future.delayed(const Duration(seconds: 1));
    _posts.add(post);
  }

  @override
  Future<void> likePost(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index != -1) {
      final post = _posts[index];
      _posts[index] = SocialPost(
        id: post.id,
        userId: post.userId,
        userName: post.userName,
        userImageUrl: post.userImageUrl,
        content: post.content,
        imageUrls: post.imageUrls,
        likesCount:
            post.isLikedByMe ? post.likesCount - 1 : post.likesCount + 1,
        commentsCount: post.commentsCount,
        createdAt: post.createdAt,
        isLikedByMe: !post.isLikedByMe,
      );
    }
  }
}

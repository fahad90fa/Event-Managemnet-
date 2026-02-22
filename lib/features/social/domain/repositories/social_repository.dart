import '../entities/social_post.dart';

abstract class SocialRepository {
  Future<List<SocialPost>> getPosts();
  Future<void> createPost(SocialPost post);
  Future<void> likePost(String postId);
}

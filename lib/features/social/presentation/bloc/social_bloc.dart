import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/social_post.dart';
import '../../domain/repositories/social_repository.dart';

// Events
abstract class SocialEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadPosts extends SocialEvent {}

class CreatePost extends SocialEvent {
  final String content;
  final List<String> imageUrls;
  CreatePost(this.content, this.imageUrls);
  @override
  List<Object?> get props => [content, imageUrls];
}

class LikePost extends SocialEvent {
  final String postId;
  LikePost(this.postId);
  @override
  List<Object?> get props => [postId];
}

// States
abstract class SocialState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SocialInitial extends SocialState {}

class SocialLoading extends SocialState {}

class SocialLoaded extends SocialState {
  final List<SocialPost> posts;
  SocialLoaded(this.posts);
  @override
  List<Object?> get props => [posts];
}

class SocialError extends SocialState {
  final String message;
  SocialError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class SocialBloc extends Bloc<SocialEvent, SocialState> {
  final SocialRepository repository;

  SocialBloc({required this.repository}) : super(SocialInitial()) {
    on<LoadPosts>((event, emit) async {
      emit(SocialLoading());
      try {
        final posts = await repository.getPosts();
        emit(SocialLoaded(posts));
      } catch (e) {
        emit(SocialError(e.toString()));
      }
    });

    on<CreatePost>((event, emit) async {
      try {
        final newPost = SocialPost(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: 'current-user',
          userName: 'You',
          content: event.content,
          imageUrls: event.imageUrls,
          likesCount: 0,
          commentsCount: 0,
          createdAt: DateTime.now(),
        );
        await repository.createPost(newPost);
        add(LoadPosts());
      } catch (e) {
        emit(SocialError(e.toString()));
      }
    });

    on<LikePost>((event, emit) async {
      try {
        await repository.likePost(event.postId);
        add(LoadPosts());
      } catch (e) {
        emit(SocialError(e.toString()));
      }
    });
  }
}

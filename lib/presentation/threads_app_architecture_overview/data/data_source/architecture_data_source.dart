import '../enum/component_type_enum.dart';
import '../models/feature_component_model.dart';
import '../models/feature_module_model.dart';

// /home/ubuntu/app/eslam_s_application/lib/presentation/threads_app_architecture_overview/data/data_source/architecture_data_source.dart





abstract class ArchitectureDataSource {
  List<FeatureModuleModel> getFeatureModules();
  String getStateManagementExample();
  String getImplementationExample();
}

class ArchitectureDataSourceImpl implements ArchitectureDataSource {
  @override
  List<FeatureModuleModel> getFeatureModules() {
    return [
      FeatureModuleModel(
        id: 'profile',
        name: 'Profile Feature',
        description: 'Handles user profile display and management',
        components: _getProfileComponents(),
      ),
      FeatureModuleModel(
        id: 'auth',
        name: 'Authentication Feature',
        description: 'Manages user authentication flow',
        components: _getAuthComponents(),
      ),
      FeatureModuleModel(
        id: 'feed',
        name: 'Feed Feature',
        description: 'Displays user feed and posts',
        components: _getFeedComponents(),
      ),
    ];
  }

  List<FeatureComponentModel> _getProfileComponents() {
    return [
      FeatureComponentModel(
        id: 'profile_data_source',
        name: 'ProfileDataSource',
        type: ComponentType.dataSource,
        description: 'Fetches profile data from API',
        codeExample: '''
abstract class ProfileDataSource {
  Future<ProfileModel> getProfileData();
  Future<List<ThreadPostModel>> getThreadPosts();
}

class ProfileDataSourceImpl implements ProfileDataSource {
  @override
  Future<ProfileModel> getProfileData() async {
    // API call implementation
  }
}
''',
        dependencies: [],
      ),
      FeatureComponentModel(
        id: 'profile_enum',
        name: 'ThreadsTab',
        type: ComponentType.enum_,
        description: 'Defines tabs in profile screen',
        codeExample: '''
enum ThreadsTab {
  threads,
  replies
}
''',
        dependencies: [],
      ),
      FeatureComponentModel(
        id: 'profile_models',
        name: 'ProfileModel',
        type: ComponentType.models,
        description: 'User profile data structure',
        codeExample: '''
class ProfileModel {
  final String name;
  final String username;
  final String website;
  // Other profile fields
}
''',
        dependencies: [],
      ),
      FeatureComponentModel(
        id: 'profile_repository',
        name: 'ProfileRepository',
        type: ComponentType.repository,
        description: 'Manages profile data access',
        codeExample: '''
abstract class ProfileRepository {
  Future<ProfileModel> getProfileData();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource _dataSource;
  
  ProfileRepositoryImpl(this._dataSource);
  
  @override
  Future<ProfileModel> getProfileData() {
    return _dataSource.getProfileData();
  }
}
''',
        dependencies: ['profile_data_source', 'profile_models'],
      ),
      FeatureComponentModel(
        id: 'profile_cubit',
        name: 'ProfileCubit',
        type: ComponentType.bloc,
        description: 'Manages profile state',
        codeExample: '''
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;

  ProfileCubit(this._repository) : super(ProfileState());

  Future<void> loadProfileData() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    
    try {
      final profile = await _repository.getProfileData();
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
''',
        dependencies: ['profile_repository'],
      ),
      FeatureComponentModel(
        id: 'profile_page',
        name: 'ProfilePage',
        type: ComponentType.pages,
        description: 'Profile screen UI',
        codeExample: '''
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(
        context.read<ProfileRepository>(),
      )..loadProfileData(),
      child: Scaffold(
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.isLoading) {
              return CircularProgressIndicator();
            }
            // Render UI based on state
          },
        ),
      ),
    );
  }
}
''',
        dependencies: ['profile_cubit', 'profile_widgets'],
      ),
      FeatureComponentModel(
        id: 'profile_widgets',
        name: 'ProfileWidgets',
        type: ComponentType.widgets,
        description: 'Reusable profile UI components',
        codeExample: '''
class ProfileHeaderWidget extends StatelessWidget {
  final ProfileModel profile;
  
  const ProfileHeaderWidget({required this.profile});
  
  @override
  Widget build(BuildContext context) {
    // Profile header UI implementation
  }
}
''',
        dependencies: ['profile_models'],
      ),
    ];
  }

  List<FeatureComponentModel> _getAuthComponents() {
    return [
      FeatureComponentModel(
        id: 'auth_data_source',
        name: 'AuthDataSource',
        type: ComponentType.dataSource,
        description: 'Handles authentication API calls',
        dependencies: [],
      ),
      FeatureComponentModel(
        id: 'auth_models',
        name: 'AuthModels',
        type: ComponentType.models,
        description: 'Authentication data structures',
        dependencies: [],
      ),
      FeatureComponentModel(
        id: 'auth_repository',
        name: 'AuthRepository',
        type: ComponentType.repository,
        description: 'Manages authentication process',
        dependencies: ['auth_data_source', 'auth_models'],
      ),
      FeatureComponentModel(
        id: 'auth_cubit',
        name: 'AuthCubit',
        type: ComponentType.bloc,
        description: 'Manages authentication state',
        dependencies: ['auth_repository'],
      ),
      FeatureComponentModel(
        id: 'auth_pages',
        name: 'LoginPage, RegisterPage',
        type: ComponentType.pages,
        description: 'Authentication UI screens',
        dependencies: ['auth_cubit', 'auth_widgets'],
      ),
      FeatureComponentModel(
        id: 'auth_widgets',
        name: 'AuthWidgets',
        type: ComponentType.widgets,
        description: 'Reusable authentication UI components',
        dependencies: [],
      ),
    ];
  }

  List<FeatureComponentModel> _getFeedComponents() {
    return [
      FeatureComponentModel(
        id: 'feed_data_source',
        name: 'FeedDataSource',
        type: ComponentType.dataSource,
        description: 'Fetches feed data from API',
        dependencies: [],
      ),
      FeatureComponentModel(
        id: 'feed_models',
        name: 'PostModel, FeedModel',
        type: ComponentType.models,
        description: 'Feed and post data structures',
        dependencies: [],
      ),
      FeatureComponentModel(
        id: 'feed_repository',
        name: 'FeedRepository',
        type: ComponentType.repository,
        description: 'Manages feed data access',
        dependencies: ['feed_data_source', 'feed_models'],
      ),
      FeatureComponentModel(
        id: 'feed_cubit',
        name: 'FeedCubit',
        type: ComponentType.bloc,
        description: 'Manages feed state',
        dependencies: ['feed_repository'],
      ),
      FeatureComponentModel(
        id: 'feed_page',
        name: 'FeedPage',
        type: ComponentType.pages,
        description: 'Feed screen UI',
        dependencies: ['feed_cubit', 'feed_widgets'],
      ),
      FeatureComponentModel(
        id: 'feed_widgets',
        name: 'PostWidget, FeedItemWidget',
        type: ComponentType.widgets,
        description: 'Reusable feed UI components',
        dependencies: ['feed_models'],
      ),
    ];
  }

  @override
  String getStateManagementExample() {
    return '''
// State definition using enum for status
enum FeedStatus {
  initial,
  loading,
  error,
  loaded,
  loadingMore,
}

// Extension for easy status checking
extension FeedStateX on FeedState {
  bool get isInitial => status == FeedStatus.initial;
  bool get isLoading => status == FeedStatus.loading;
  bool get isError => status == FeedStatus.error;
  bool get isLoaded => status == FeedStatus.loaded;
  bool get isLoadingMore => status == FeedStatus.loadingMore;
}

// State class with all required data
@immutable
class FeedState {
  final FeedStatus status;
  final String? errorMsg;
  final List<PostModel>? posts;
  final bool hasNextPage;
  final int page;

  const FeedState({
    this.status = FeedStatus.initial,
    this.errorMsg,
    this.posts,
    this.hasNextPage = false,
    this.page = 1,
  });

  // CopyWith for immutability pattern
  FeedState copyWith({
    FeedStatus? status,
    String? errorMsg,
    List<PostModel>? posts,
    bool? hasNextPage,
    int? page,
  }) {
    return FeedState(
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg,
      posts: posts ?? this.posts,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      page: page ?? this.page,
    );
  }

  // Equality implementation
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          errorMsg == other.errorMsg &&
          posts == other.posts &&
          hasNextPage == other.hasNextPage &&
          page == other.page;

  @override
  int get hashCode =>
      status.hashCode ^
      errorMsg.hashCode ^
      posts.hashCode ^
      hasNextPage.hashCode ^
      page.hashCode;
}
''';
  }

  @override
  String getImplementationExample() {
    return '''
// 1. Define the repository interface
abstract class PostRepository {
  Future<List<PostModel>> getPosts(int page);
  Future<void> likePost(String postId);
}

// 2. Implement the repository
class PostRepositoryImpl implements PostRepository {
  final PostDataSource _dataSource;
  
  PostRepositoryImpl(this._dataSource);
  
  @override
  Future<List<PostModel>> getPosts(int page) {
    return _dataSource.getPosts(page);
  }
  
  @override
  Future<void> likePost(String postId) {
    return _dataSource.likePost(postId);
  }
}

// 3. Create the Cubit
class PostCubit extends Cubit<PostState> {
  final PostRepository _repository;
  
  PostCubit(this._repository) : super(PostState());
  
  Future<void> loadPosts() async {
    emit(state.copyWith(status: PostStatus.loading));
    
    try {
      final posts = await _repository.getPosts(state.page);
      emit(state.copyWith(
        status: PostStatus.loaded,
        posts: posts,
        hasNextPage: posts.length >= 10,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PostStatus.error,
        errorMsg: e.toString(),
      ));
    }
  }
  
  Future<void> loadMorePosts() async {
    if (!state.hasNextPage || state.isLoadingMore) return;
    
    emit(state.copyWith(status: PostStatus.loadingMore));
    
    try {
      final newPage = state.page + 1;
      final newPosts = await _repository.getPosts(newPage);
      
      emit(state.copyWith(
        status: PostStatus.loaded,
        posts: [...(state.posts ?? []), ...newPosts],
        page: newPage,
        hasNextPage: newPosts.length >= 10,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PostStatus.error,
        errorMsg: e.toString(),
      ));
    }
  }
  
  Future<void> likePost(String postId) async {
    try {
      await _repository.likePost(postId);
      final updatedPosts = state.posts?.map((post) {
        if (post.id == postId) {
          return post.copyWith(isLiked: true, likesCount: post.likesCount + 1);
        }
        return post;
      }).toList();
      
      emit(state.copyWith(posts: updatedPosts));
    } catch (e) {
      // Handle error but don't change state
    }
  }
}

// 4. Use in UI
class PostsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(
        context.read<PostRepository>(),
      )..loadPosts(),
      child: Scaffold(
        body: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            if (state.isInitial || state.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            
            if (state.isError) {
              return Center(child: Text(state.errorMsg ?? 'Error'));
            }
            
            final posts = state.posts ?? [];
            if (posts.isEmpty) {
              return Center(child: Text('No posts available'));
            }
            
            return ListView.builder(
              itemCount: posts.length + (state.hasNextPage ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == posts.length) {
                  context.read<PostCubit>().loadMorePosts();
                  return Center(child: CircularProgressIndicator());
                }
                
                final post = posts[index];
                return PostWidget(
                  post: post,
                  onLike: () => context.read<PostCubit>().likePost(post.id),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
''';
  }
}
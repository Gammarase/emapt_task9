
import 'package:empat_task9/models/state_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:empat_task9/logic/logical_fuctions.dart';
import 'event_post.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc():super(InitialPostState()){
    on<AddLike>(_onAddLike);
    on<RemoveLike>(_onRemoveLike);
    on<AddSelection>(_onAddSelection);
    on<RemoveSelection>(_onRemoveSelection);
    on<RefreshPosts>(_onRefreshPosts);
    on<ChangeTheme>(_onChangeTheme);
    on<UpdateNickname>(_onUpdateNickname);
  }

  _onAddLike(AddLike event, Emitter<PostState> emit) {
    state.likedId.add(event.likeId);
    emit(
      ResultPostState(
        postsContent: state.postsContent,
        likedId: state.likedId,
        selectedId: state.selectedId,
        userName: state.userName,
        whiteTheme: state.whiteTheme
      ),
    );
  }

  _onRemoveLike(RemoveLike event, Emitter<PostState> emit) {
    state.likedId.remove(event.likeId);
    emit(
      ResultPostState(
        postsContent: state.postsContent,
        likedId: state.likedId,
        selectedId: state.selectedId,
        userName: state.userName,
        whiteTheme: state.whiteTheme
      ),
    );
  }

  _onAddSelection(AddSelection event, Emitter<PostState> emit) {
    state.selectedId.add(event.selectionId);
    emit(
      ResultPostState(
        postsContent: state.postsContent,
        likedId: state.likedId,
        selectedId: state.selectedId,
        userName: state.userName,
        whiteTheme: state.whiteTheme
      ),
    );
  }

  _onRemoveSelection(RemoveSelection event, Emitter<PostState> emit) {
    state.selectedId.remove(event.selectionId);
    emit(
      ResultPostState(
        postsContent: state.postsContent,
        likedId: state.likedId,
        selectedId: state.selectedId,
        userName: state.userName,
        whiteTheme: state.whiteTheme
      ),
    );
  }

  _onRefreshPosts(RefreshPosts event, Emitter<PostState> emit) {
    emit(
      ResultPostState(
        postsContent: downloadAllPosts(),
        likedId: state.likedId,
        selectedId: state.selectedId,
        userName: state.userName,
        whiteTheme: state.whiteTheme
      ),
    );
  }

  _onChangeTheme(ChangeTheme event, Emitter<PostState> emit) {
    var tempState = ResultPostState(
      postsContent: state.postsContent,
      likedId: state.likedId,
      selectedId: state.selectedId,
      userName: state.userName,
      whiteTheme: state.whiteTheme ? false : true
    );
    emit(tempState);
  }

  _onUpdateNickname(UpdateNickname event, Emitter<PostState> emit) {
    emit(
      ResultPostState(
        postsContent: state.postsContent,
        likedId: state.likedId,
        selectedId: state.selectedId,
        userName: event.name,
        whiteTheme: state.whiteTheme
      ),
    );
  }
}

abstract class PostEvent {}

class AddLike extends PostEvent {
  final int likeId;

  AddLike(this.likeId);
}

class RemoveLike extends PostEvent {
  final int likeId;

  RemoveLike(this.likeId);
}

class AddSelection extends PostEvent {
  final int selectionId;

  AddSelection(this.selectionId);
}

class RemoveSelection extends PostEvent {
  final int selectionId;

  RemoveSelection(this.selectionId);
}

class RefreshPosts extends PostEvent {}

class ChangeTheme extends PostEvent {}

class UpdateNickname extends PostEvent {
  final String name;

  UpdateNickname(this.name);
}

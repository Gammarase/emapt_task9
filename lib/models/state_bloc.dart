import 'package:shared_preferences/shared_preferences.dart';

import 'package:empat_task9/logic/logical_classes.dart';
import 'package:empat_task9/logic/logical_fuctions.dart';

abstract class PostState {
  Future<List<PostInfo>> postsContent;
  String userName;
  final List<int> likedId;
  final List<int> selectedId;
  bool whiteTheme;

  PostState(
      {required this.postsContent,
      this.userName = 'Nickname',
      List<int>? likedId,
      List<int>? selectedId,
      this.whiteTheme = true})
      : likedId = likedId ?? [],
        selectedId = selectedId ?? [];
}

class InitialPostState extends PostState {
  InitialPostState() : super(postsContent: downloadAllPosts()) {
    SharedPreferences.getInstance().then((pref) {
      whiteTheme = pref.getBool('theme') ?? false;
    });
  }
}

class ResultPostState extends PostState {
  ResultPostState(
      {required super.postsContent,
      super.likedId,
      super.selectedId,
      super.userName,
      super.whiteTheme}) {
    SharedPreferences.getInstance().then((pref) {
      pref.setBool('theme', whiteTheme);
    });
  }
}

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'logical_classes.dart';

Future<String> uploadPost(Uint8List photo, int likesAmount) async {
  var response = await http
      .post(Uri.http('192.168.0.100', '/fluttergram/itemactions.php'), body: {
    'action': 'UPLOAD',
    'image': base64Encode(photo),
    'amount_likes': likesAmount.toString()
  });
  if (response.statusCode == 200 && response.body == 'success') {
    return 'Photo uploaded';
  } else {
    return 'Uploading error';
  }
}

Future<List<PostInfo>> downloadAllPosts() async {
  List<PostInfo> finalList = [];
  var response = await http.post(
      Uri.http('192.168.0.100', '/fluttergram/itemactions.php'),
      body: {'action': 'GET_INDEXES'});
  if (200 == response.statusCode && response.body != 'error') {
    for (Map singleMap in jsonDecode(response.body)) {
      var responsePost = await http.post(
          Uri.http('192.168.0.100', '/fluttergram/itemactions.php'),
          body: {'action': 'DOWNLOAD', "post_id": singleMap['post_id']});
      if (200 == response.statusCode && response.body != 'error') {
        finalList.add(PostInfo.parseJson(jsonDecode(responsePost.body)));
      } else {
        return Future.error('Connection Error');
      }
    }
    return finalList;
  } else {
    return Future.error('Connection Error');
  }
}

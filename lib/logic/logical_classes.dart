import 'dart:convert';
import 'dart:typed_data';

class PostInfo {
  late int postId;
  late Uint8List imageData;
  late int likesAmount;

  PostInfo(this.postId, this.imageData, this.likesAmount);

  PostInfo.parseJson(Map<String, dynamic> mapData) {
    postId = int.parse(mapData['post_id']);
    likesAmount = int.parse(mapData['amount_likes']);
    imageData = base64Decode(const Base64Codec().normalize(mapData['image']));
  }
}

import 'dart:typed_data';
import 'package:empat_task9/models/event_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:empat_task9/logic/logical_classes.dart';
import 'package:empat_task9/models/bloc_post.dart';
import 'package:empat_task9/models/state_bloc.dart';

class CustomButton extends StatelessWidget {
  final Widget child;

  const CustomButton({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color(0xFF715AFF),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(1, 2), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: child);
  }
}

class CustomAvatar extends StatelessWidget {
  final double avatarRadius;
  final double borderThick;
  final bool ifSeenBorder;
  final bool ifSeenAdd;
  final int photoIndex;
  final Uint8List? photoData;

  const CustomAvatar(
      {Key? key,
      this.avatarRadius = 65,
      this.borderThick = 10,
      this.photoIndex = 0,
      this.ifSeenBorder = true,
      this.ifSeenAdd = false,
      required this.photoData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: photoData != null,
      child: SizedBox(
        width: avatarRadius + borderThick,
        height: avatarRadius + borderThick,
        child: Stack(
          //alignment: Alignment.center,
          children: [
            Visibility(
              visible: ifSeenBorder,
              child: Container(
                height: avatarRadius + borderThick,
                //avatarRadius + borderThick,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFA682FF), Colors.red],
                    ),
                    shape: BoxShape.circle),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: avatarRadius,
                decoration: BoxDecoration(
                  boxShadow: ifSeenBorder
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(
                                1, 2), // changes position of shadow
                          ),
                        ],
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: MemoryImage(photoData!),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: ifSeenAdd,
              child: Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFFA682FF)),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: (avatarRadius + borderThick) / 3.5,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final PostInfo? postData;
  final bool useHero;

  final int photoIndex;

  const PostWidget(
      {Key? key,
      required this.postData,
      this.useHero = false,
      this.photoIndex = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CustomAvatar(
                photoData: postData?.imageData,
                avatarRadius: 40,
                borderThick: 5,
                photoIndex: photoIndex % 10,
              ),
              const SizedBox(
                width: 5,
              ),
              const Text(
                'Nickname',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              const Expanded(child: SizedBox()),
              const Padding(
                padding: EdgeInsets.all(3),
                child: Icon(Icons.menu, size: 35),
              )
            ],
          ),
        ),
        useHero
            ? Hero(
                tag: 'assets/img/profile_avatar (${photoIndex + 1}).jpg',
                child: postData?.imageData != null
                    ? Image.memory(postData!.imageData)
                    : const Text('No Image'),
              )
            : postData?.imageData != null
                ? Image.memory(postData!.imageData)
                : const Text('No Image'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      BlocBuilder<PostBloc, PostState>(
                        builder: (context, state) {
                          return InkWell(
                            onTap: () {
                              state.likedId.contains(photoIndex % 10)
                                  ? context
                                      .read<PostBloc>()
                                      .add(RemoveLike(photoIndex % 10))
                                  : context
                                      .read<PostBloc>()
                                      .add(AddLike(photoIndex % 10));
                            },
                            child: Icon(
                              Icons.thumb_up,
                              size: 35,
                              color: state.likedId.contains(photoIndex % 10)
                                  ? Colors.red
                                  : null,
                            ),
                          );
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 35,
                        ),
                      ),
                      const Icon(
                        Icons.send,
                        size: 35,
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.bookmark,
                    size: 35,
                  )
                ],
              ),
              Text(
                '${postData?.likesAmount} likes',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const Text(
                'Description',
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                'View all coments',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              )
            ],
          ),
        )
      ],
    );
  }
}

class Counter extends StatelessWidget {
  const Counter({super.key, required this.number, this.isVisible = true});

  final bool isVisible;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Container(
          width: 45,
          height: 45,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF715AFF),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class SelectivePhoto extends StatelessWidget {
  const SelectivePhoto({
    Key? key,
    required this.index,
    this.isSelected = false,
    required this.photoData,
  }) : super(key: key);
  final Uint8List? photoData;
  final int index;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: photoData != null,
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Hero(
          tag: 'assets/img/profile_avatar (${index + 1}).jpg',
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.memory(
                photoData!,
                fit: BoxFit.cover,
              ),
              Visibility(
                visible: isSelected,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                      height: 40,
                      //MediaQuery.of(context).size.height/15,
                      width: 40,
                      //MediaQuery.of(context).size.height/15,

                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF715AFF),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

showMessage(String text, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(text),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('cancel'))
        ],
      );
    },
  );
}

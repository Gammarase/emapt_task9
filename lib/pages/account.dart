import 'package:empat_task9/pages/custom_elements.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:empat_task9/models/bloc_post.dart';
import 'package:empat_task9/models/state_bloc.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  return Text(
                    state.userName,
                    style:
                        const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                  );
                }
              ),
              const Icon(
                Icons.menu,
                size: 28,
              )
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<PostBloc, PostState>(
                        builder: (context, state) {
                          return FutureBuilder(
                              future: state.postsContent,
                              builder: (context, snapshot) {
                                return snapshot.hasData
                                    ? CustomAvatar(
                                        photoData: snapshot.data?[0].imageData,
                                        borderThick: 0,
                                        avatarRadius: 100,
                                      )
                                    : const Text('Image loading');
                              });
                        }
                      ),
                      Column(
                        children: const [
                          Text(
                            '5',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Posts',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: const [
                          Text(
                            '128',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Followers',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: const [
                          Text(
                            '86',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Following',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    'Name',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    'Description',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: const [
                      Icon(Icons.link),
                      Text(
                        'website.com',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: const [
                      Expanded(
                        child: CustomButton(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Center(
                              child: Text(
                                'Edit profile',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      CustomButton(
                        child: Padding(
                          padding: EdgeInsets.all(1.5),
                          child: Icon(
                            Icons.add_a_photo_outlined,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    return FutureBuilder(
                        future: state.postsContent,
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? Wrap(
                                  children: List<Widget>.generate(
                                    snapshot.data!.length,
                                    (index) => SizedBox(
                                      height: MediaQuery.of(context).size.width / 3,
                                      width: MediaQuery.of(context).size.width / 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => Material(
                                                  child: SafeArea(
                                                    child: PostWidget(
                                                      postData:
                                                          snapshot.data?[index],
                                                      useHero: true,
                                                      photoIndex: index,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          child: SelectivePhoto(
                                            photoData:
                                                snapshot.data?[index].imageData,
                                            index: index,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const Text(
                                  'DataLoading...',
                                  style: TextStyle(
                                      fontSize: 40, fontWeight: FontWeight.bold),
                                );
                        });
                  }
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

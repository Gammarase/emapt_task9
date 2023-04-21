
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:empat_task9/models/bloc_post.dart';
import 'package:empat_task9/models/event_post.dart';
import 'package:empat_task9/models/state_bloc.dart';
import 'custom_elements.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 8, right: 8),
          child: Row(
            children: [
              const Text(
                'FlutterGram',
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              const Expanded(
                child: SizedBox(),
              ),
              BlocBuilder<PostBloc, PostState>(builder: (context, state) {
                return InkWell(
                  onTap: () => context.read<PostBloc>().add(ChangeTheme()),
                  child: CustomButton(
                    child: Icon(
                      state.whiteTheme ? Icons.sunny : Icons.dark_mode,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                );
              }),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  var response =
                      Navigator.of(context).pushNamed('/registration');
                  response.then(
                    (value) {
                      showMessage('Вітаємо, $value!', context);
                      context
                          .read<PostBloc>()
                          .add(UpdateNickname(value.toString()));
                    },
                  );
                },
                child: const CustomButton(
                  child: Icon(
                    Icons.account_circle,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 11,
            child: BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                return FutureBuilder(
                  future: state.postsContent,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(1),
                              child: CustomAvatar(
                                avatarRadius:
                                    MediaQuery.of(context).size.height / 11 - 10,
                                borderThick: 10,
                                photoIndex: index,
                                ifSeenBorder: index < 5 && index != 0,
                                ifSeenAdd: index == 0,
                                photoData: snapshot.data?[index].imageData,
                              ),
                            ),
                          )
                        : Container();
                  },
                );
              }
            )),
        Expanded(
          child: BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              return FutureBuilder(
                future: state.postsContent,
                builder: (context, snapshot) => snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) => PostWidget(
                          postData: snapshot.data?[index],
                          photoIndex: index,
                        ),
                      )
                    : const Center(
                        child: Text(
                          'DataLoading...',
                          style:
                              TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                      ),
              );
            }
          ),
        )
      ],
    );
  }
}

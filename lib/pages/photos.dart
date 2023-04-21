import 'package:empat_task9/models/bloc_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:empat_task9/models/event_post.dart';
import 'package:empat_task9/models/state_bloc.dart';
import 'custom_elements.dart';

class PhotoNavigate extends StatelessWidget {
  const PhotoNavigate({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            if (settings.name == '/') {
              return const PhotoPage();
            } else if (settings.name == '/post') {
              return const PostCaller();
            } else {
              throw Exception('Unacceptable route name: ${settings.name}');
            }
          },
        );
      },
    );
  }
}

class PostCaller extends StatelessWidget {
  const PostCaller({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: SafeArea(
        child: PostWidget(
          postData: arguments["postData"],
          useHero: arguments["useHero"],
          photoIndex: arguments["photoIndex"],
        ),
      ),
    );
  }
}

class PhotoPage extends StatelessWidget {
  const PhotoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10),
                      fillColor: Colors.grey,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'Search',
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                BlocBuilder<PostBloc, PostState>(
                  builder: (context, state) {
                    return Counter(
                      number: state
                          .selectedId
                          .length
                          .toString(),
                      isVisible:
                          state.selectedId.isNotEmpty,
                    );
                  }
                ),
              ],
            ),
          ),
          Wrap(
            children: List<Widget>.generate(
              50,
              (index) => SizedBox(
                height: MediaQuery.of(context).size.width / 3,
                width: MediaQuery.of(context).size.width / 3,
                child: Padding(
                  padding: const EdgeInsets.all(1),
                  child: BlocBuilder<PostBloc, PostState>(
                    builder: (context, state) {
                      return FutureBuilder(
                        future: state.postsContent,
                        builder: (context, snapshot) => snapshot.hasData
                            ? InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    '/post',
                                    arguments: {
                                      "postData": snapshot
                                          .data?[index % snapshot.data!.length],
                                      "useHero": true,
                                      "photoIndex": index,
                                    },
                                  );
                                },
                                onLongPress: () {
                                  state.selectedId.contains(index)
                                      ? context.read<PostBloc>().add(RemoveSelection(index))
                                      : context.read<PostBloc>().add(AddSelection(index));
                                },
                                child: SelectivePhoto(
                                  photoData: snapshot
                                      .data?[index % snapshot.data!.length]
                                      .imageData,
                                  index: index,
                                  isSelected: state.selectedId.contains(index),
                                ),
                              )
                            : const Text('Image loading'),
                      );
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

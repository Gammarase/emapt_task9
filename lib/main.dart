import 'dart:math';
import 'dart:typed_data';
import 'package:empat_task9/pages/statistic_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:empat_task9/logic/logical_fuctions.dart';
import 'package:empat_task9/pages/account.dart';
import 'package:empat_task9/pages/custom_elements.dart';
import 'package:empat_task9/pages/main_page.dart';
import 'package:empat_task9/pages/photos.dart';
import 'package:empat_task9/pages/registration.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'models/bloc_post.dart';
import 'models/event_post.dart';
import 'models/state_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => PostBloc(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(builder: (context, state) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: state.whiteTheme ? null : const ColorScheme.dark(),
        ),
        //home: const MyHomePage(),
        initialRoute: '/',
        routes: {
          '/': (context) => const MyHomePage(),
          '/registration': (context) => const RegistrationPage()
        },
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  var pages = [
    const MainPage(),
    const PhotoNavigate(),
    const AccountPage(),
    const StatisticPage()
  ];

  var navElements = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.photo_camera),
      label: 'Photo',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle),
      label: 'Account',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.stacked_bar_chart),
      label: 'Statistics',
    ),
  ];

  var drawerElements = List<Widget>.generate(
    5,
    (index) => Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          const Icon(
            Icons.circle,
            size: 10,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            'Option $index',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    ),
  );

  int pageNum = 0;

  late TabController _tabPageController;

  @override
  void initState() {
    _tabPageController = TabController(
      length: pages.length,
      vsync: this,
    );
    _tabPageController.addListener(() {
      setState(() {
        pageNum = _tabPageController.index;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xFFF4F4F8),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF715AFF),
        unselectedItemColor: const Color(0xFFA682FF),
        showUnselectedLabels: false,
        onTap: (index) {
          if (index != pageNum) {
            setState(() {
              pageNum = index;
            });
            _tabPageController.animateTo(pageNum,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut);
          }
        },
        currentIndex: pageNum,
        items: navElements,
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabPageController,
          children: pages,
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          uploadPicked().then((value) {
            showMessage(value, context);
            context.read<PostBloc>().add(RefreshPosts());
          });
        },
        child: const CustomButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabPageController.dispose();
    super.dispose();
  }

  Future<String> uploadPicked() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    Uint8List? bytePhoto = await file?.readAsBytes();
    if (bytePhoto != null) {
      return uploadPost(bytePhoto, Random().nextInt(100));
    } else {
      return Future.error('Error during picking photo');
    }
  }
}

import 'package:flutter/material.dart';
import 'dart:math';

class StatisticPage extends StatefulWidget {
  const StatisticPage({Key? key}) : super(key: key);

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage>
    with TickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;
  late final Animation<Color?> colorAnimation;

  late final AnimationController sunController;
  late final Animation<double> sunAnimation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(controller);
    colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.purple,
    ).animate(controller);
    sunController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    sunAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(sunController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          sunController.forward(from: 0);
        }
      });
    sunController.forward();
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    sunController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Your Spend in App time',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        AnimatedDiagram(
          animation: animation,
          colorAnimation: colorAnimation,
        ),
        Expanded(
          child: AnimatedSunrise(
            animation: sunAnimation,
          ),
        ),
      ],
    );
  }
}

class AnimatedDiagram extends AnimatedWidget {
  final List<double> diagramData = [5, 8, 7, 7, 5, 4, 7];
  final Animation<Color?> colorAnimation;

  AnimatedDiagram(
      {required this.colorAnimation,
      super.key,
      required Animation<double> animation})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return SizedBox(
      height: diagramData.reduce(max) * 55,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: diagramData
            .map(
              (e) => Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$e\nhours',
                      style: TextStyle(
                          color: Colors.black.withOpacity(animation.value),
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      height: e * 50 * animation.value,
                      width: MediaQuery.of(context).size.width /
                              diagramData.length -
                          10,
                      decoration: BoxDecoration(
                          color: colorAnimation.value
                              ?.withOpacity(animation.value),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(10))),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class AnimatedSunrise extends AnimatedWidget {
  const AnimatedSunrise({super.key, required Animation<double> animation})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return LayoutBuilder(builder: (context, constrains) {
      var sunSize = constrains.maxHeight / 4;
      return Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/photo_sky.jpeg"),
                  fit: BoxFit.cover),
            ),
          ),
          Container(
            color: Colors.blue.withOpacity(sin(animation.value * pi)),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: animation.value * (constrains.maxWidth - sunSize),
              bottom:
                  sin(animation.value * pi) * (constrains.maxHeight - sunSize),
            ),
            child: Container(
              width: sunSize,
              height: sunSize,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.yellow),
            ),
          ),
          Container(
            height: constrains.maxHeight / 3,
            color: Colors.green,
          ),
        ],
      );
    });
  }
}

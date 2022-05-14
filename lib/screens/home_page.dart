import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:wallpaper/model/image_model.dart';
import 'package:wallpaper/screens/image_page.dart';
import 'package:wallpaper/api/api_provider.dart';

import '../widget/custom_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<PreloadPageController> controllers = [];
  List<Data>? allData;

  @override
  void initState() {
    _loadImages();
    controllers = [
      PreloadPageController(viewportFraction: 0.6, initialPage: 3),
      PreloadPageController(viewportFraction: 0.6, initialPage: 3),
      PreloadPageController(viewportFraction: 0.6, initialPage: 3),
      PreloadPageController(viewportFraction: 0.6, initialPage: 3),
      PreloadPageController(viewportFraction: 0.6, initialPage: 3),
    ];
    super.initState();
  }

  _animatePage(int page, int index) {
    for (int i = 0; i < 5; i++) {
      if (i != index) {
        controllers[i].animateToPage(page,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
      }
    }
  }

  _loadImages() async {
    var imageModel = await ApiProvider().getImages(25);
    allData = imageModel.allData;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).backgroundColor,
      body: PreloadPageView.builder(
        controller:
            PreloadPageController(viewportFraction: 0.7, initialPage: 3),
        itemCount: 4,
        preloadPagesCount: 4,
        itemBuilder: (context, mainIndex) {
          return PreloadPageView.builder(
            itemCount: 4,
            preloadPagesCount: 4,
            controller: controllers[mainIndex],
            scrollDirection: Axis.vertical,
            physics: const ClampingScrollPhysics(),
            onPageChanged: (page) {
              _animatePage(page, mainIndex);
            },
            itemBuilder: (context, index) {
              var hitIndex = (mainIndex * 4) + index;
              Data? data;
              if (allData != null) {
                data = allData![hitIndex];
              }
              return GestureDetector(
                onTap: () {
                  if (allData != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImagePage(
                          model: data,
                          imageBoxFit: BoxFit.cover,
                        ),
                      ),
                    );
                  }
                },
                child: CustomCard(
                  title: data?.user,
                  description: data?.category,
                  url: data?.path,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:wallpaper/model/image_model.dart';

class ImagePage extends StatefulWidget {
  final Data? model;
  final BoxFit? imageBoxFit;
  ImagePage({this.model, this.imageBoxFit});

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  static const platform = MethodChannel('com.sohan.wallpaper/wallpaper');
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: AnimatedBuilder(
          animation: _controller!,
          builder: (context, child) => Stack(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: GestureDetector(
                  onTap: () {
                    if (_controller!.isCompleted) {
                      _controller!.reverse();
                    } else {
                      _controller!.forward();
                    }
                  },
                  child: CachedNetworkImage(
                    imageUrl: widget.model!.path!,
                    fit: widget.imageBoxFit,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Transform.translate(
                      offset: Offset(0, -_controller!.value * 64),
                      child: Container(
                        height: 64.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor,
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Visibility(
                              visible: true,
                              child: Container(
                                height: 64.0,
                                padding: const EdgeInsets.only(right: 8.0),
                                child: TextButton(
                                  child: const Text('Set as wallpaper'),
                                  onPressed: setWallpaperDialog,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, _controller!.value * 64),
                      child: Container(
                        height: 64.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor,
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: CircleAvatar(
                                      radius: 16.0,
                                      backgroundImage:
                                          NetworkImage(widget.model!.userImageURL!),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(widget.model!.user!),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: const Icon(Icons.share),
                                    onPressed: () {
                                      Share.share(widget.model!.url!);
                                    },
                                  ),
                                  Visibility(
                                    visible: false,
                                    child: IconButton(
                                      icon: const Icon(Icons.file_download),
                                      onPressed: () {},
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setWallpaperDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Set a wallpaper',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Home Screen',
                  style: TextStyle(color: Colors.black),
                ),
                leading: const Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                onTap: () => _setWallpaper(1),
              ),
              ListTile(
                title: const Text(
                  'Lock Screen',
                  style: TextStyle(color: Colors.black),
                ),
                leading: const Icon(
                  Icons.lock,
                  color: Colors.black,
                ),
                onTap: () => _setWallpaper(2),
              ),
              ListTile(
                title: const Text(
                  'Both',
                  style: TextStyle(color: Colors.black),
                ),
                leading: const Icon(
                  Icons.phone_android,
                  color: Colors.black,
                ),
                onTap: () => _setWallpaper(3),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _setWallpaper(int wallpaperType) async {
    var file =
        await DefaultCacheManager().getSingleFile(widget.model!.path!);
    try {
      final int result = await platform
          .invokeMethod('setWallpaper', [file.path, wallpaperType]);
      print('Wallpaer Updated.... $result');
    } on PlatformException catch (e) {
      print("Failed to Set Wallpaer: '${e.message}'.");
    }
    Fluttertoast.showToast(
        msg: "Wallpaper set successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
    Navigator.pop(context);
  }
}

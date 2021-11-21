// import 'dart:io';

import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SantaMaker(),
    );
  }
}

class SantaMaker extends StatefulWidget {
  const SantaMaker({Key? key}) : super(key: key);

  @override
  _SantaMakerState createState() => _SantaMakerState();
}

class _SantaMakerState extends State<SantaMaker> {
  ScreenshotController screenshotController = ScreenshotController();

  var bodies = [
    Image.asset('assets/body_beach_left.png'),
    Image.asset('assets/body_beach_right.png'),
    Image.asset('assets/body_gift_left.png'),
    Image.asset('assets/body_gift_right.png'),
    Image.asset('assets/body_normal_left.png'),
    Image.asset('assets/body_gift_right.png'),
    Image.asset('assets/body_normal_up.png'),
  ];

  var heads = [
    Image.asset('assets/head_sunglasses.png'),
    Image.asset('assets/head_starryeyes.png'),
    Image.asset('assets/head_normal.png'),
  ];
  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/background.png'))),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            children: [
              CarouselSlider(
                  items: bodies,
                  options: CarouselOptions(
                    height: 400,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1.2,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: false,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  )),
              Padding(
                padding: const EdgeInsets.only(bottom: 270),
                child: CarouselSlider(
                    items: heads,
                    options: CarouselOptions(
                      height: 400,
                      aspectRatio: 16 / 9,
                      viewportFraction: 1.2,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: false,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    )),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: () async {
                    final image = await screenshotController.capture();
                    if (image == null) return;

                    await saveImage(image);
                  },
                  backgroundColor: Color.fromRGBO(225, 50, 40, 1),
                  child: Icon(Icons.camera_alt),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: FloatingActionButton(
                  onPressed: () async {
                    final image = await screenshotController.capture();
                    if (image == null) return;

                    await saveAndShare(image);
                  },
                  backgroundColor: Color.fromRGBO(225, 50, 40, 1),
                  child: Icon(Icons.share),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> saveImage(Uint8List image) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '-')
        .replaceAll(':', '-');

    final name = 'screenshot_$time';

    final result = await ImageGallerySaver.saveImage(image, name: name);

    return result['filePath'];
  }

  Future saveAndShare(Uint8List bytes) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String directory = appDocDir.path;

    final image = File('$directory/flutter.png');
    image.writeAsBytesSync(bytes);

    await Share.shareFiles([image.path]);
  }
}

// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';

import 'package:file/file.dart' as file;
import 'package:file/memory.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  if (kIsWeb) {
    final file.FileSystem fs =
        MemoryFileSystem(); // We need a more persistent FS.
    IOOverrides.runZoned(
      () {
        IOOverrides.global = IOOverrides.current; // Welcome to the web, dart:io
        runApp(MyApp());
      },
      createDirectory: (String path) => fs.directory(path),
      createFile: (String path) => fs.file(path),
      createLink: (String path) => fs.link(path),
      getCurrentDirectory: () => fs.currentDirectory,
      setCurrentDirectory: (String path) => fs.currentDirectory = path,
      getSystemTempDirectory: () => fs.systemTempDirectory,
      stat: (String path) => fs.stat(path),
      statSync: (String path) => fs.statSync(path),
      fseIdentical: (String p1, String p2) => fs.identical(p1, p2),
      fseIdenticalSync: (String p1, String p2) => fs.identicalSync(p1, p2),
      fseGetType: (String path, bool followLinks) =>
          fs.type(path, followLinks: followLinks),
      fseGetTypeSync: (String path, bool followLinks) =>
          fs.typeSync(path, followLinks: followLinks),
      fsWatch: (String a, int b, bool c) =>
          throw UnsupportedError('unsupported'),
      fsWatchIsSupported: () => false,
    );
  } else {
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Picker Demo',
      home: MyHomePage(title: 'Image Picker Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _imageFile;
  dynamic _pickImageError;
  // bool isVideo = false;
  // VideoPlayerController _controller;
  String _retrieveDataError;

  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  Future<void> _playVideo(File file) async {
    if (file != null && mounted) {
      // await _disposeVideoController();
      // _controller = VideoPlayerController.file(file);
      // await _controller.setVolume(1.0);
      // await _controller.initialize();
      // await _controller.setLooping(true);
      // await _controller.play();
      setState(() {});
    }
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    // if (_controller != null) {
    //   await _controller.setVolume(0.0);
    // }
    // if (isVideo) {
    // final File file = await ImagePicker.pickVideo(source: source);
    // await _playVideo(file);
    // } else {
    await _displayPickImageDialog(context,
        (double maxWidth, double maxHeight, int quality) async {
      try {
        _imageFile = await ImagePicker.pickImage(
            source: source,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: quality);

        print('>>> _imageFile $_imageFile');
        setState(() {});
      } catch (e) {
        _pickImageError = e;
      }
    });
    // }
  }

  @override
  void deactivate() {
    // if (_controller != null) {
    //   _controller.setVolume(0.0);
    //   _controller.pause();
    // }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    // maxWidthController.dispose();
    // maxHeightController.dispose();
    // qualityController.dispose();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {
    // if (_controller != null) {
    //   await _controller.dispose();
    //   _controller = null;
    // }
  }

  // Widget _previewVideo() {
  //   final Text retrieveError = _getRetrieveErrorWidget();
  //   if (retrieveError != null) {
  //     return retrieveError;
  //   }
  //   if (_controller == null) {
  //     return const Text(
  //       'You have not yet picked a video',
  //       textAlign: TextAlign.center,
  //     );
  //   }
  //   return Padding(
  //     padding: const EdgeInsets.all(10.0),
  //     child: AspectRatioVideo(_controller),
  //   );
  // }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      return Image.file(_imageFile);
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: (_previewImage()),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              _onImageButtonPressed(ImageSource.gallery, context: context);
            },
            heroTag: 'image0',
            tooltip: 'Pick Image from gallery',
            child: const Icon(Icons.photo_library),
          )
        ],
      ),
    );
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add optional parameters'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: maxWidthController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration:
                      InputDecoration(hintText: "Enter maxWidth if desired"),
                ),
                TextField(
                  controller: maxHeightController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration:
                      InputDecoration(hintText: "Enter maxHeight if desired"),
                ),
                TextField(
                  controller: qualityController,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(hintText: "Enter quality if desired"),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                  child: const Text('PICK'),
                  onPressed: () {
                    double width = maxWidthController.text.isNotEmpty
                        ? double.parse(maxWidthController.text)
                        : null;
                    double height = maxHeightController.text.isNotEmpty
                        ? double.parse(maxHeightController.text)
                        : null;
                    int quality = qualityController.text.isNotEmpty
                        ? int.parse(qualityController.text)
                        : null;
                    onPick(width, height, quality);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
}

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);

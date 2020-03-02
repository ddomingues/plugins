//
// Generated file. Do not edit.
//

// ignore: unused_import
import 'dart:ui';

import 'package:image_picker/image_picker_web_plugin.dart';
import 'package:video_player_web/video_player_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerPlugins(PluginRegistry registry) {
  ImagePickerWebPlugin.registerWith(registry.registrarFor(ImagePickerWebPlugin));
  VideoPlayerPlugin.registerWith(registry.registrarFor(VideoPlayerPlugin));
  registry.registerMessageHandler();
}

import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as pt;
import 'package:permission_handler/permission_handler.dart';

Future<void> _saveStream(Stream<List<int>> stream, String savePath) async {
  print("Hello6");
  var file = File(savePath);
  var sink = file.openWrite();
  print("Hello7");
  // await stream.pipe(sink);
  // await sink.close();
  await stream.forEach((data) {
    sink.add(data);
  });
  print("Hello8");
  await sink.close();
}

class Download {
  Future<void> downloadVideo(String youtubeLink, String title) async {
    // var permisson = await Permission.storage.request();
    // if (permisson.isGranted) {
      print("Hello1");
      final yt = YoutubeExplode();

      final streamInfo =
          await yt.videos.streamsClient.getManifest('fRh_vgS2dFE');
      print("Hello2");
      final video = streamInfo.muxed.first;
      print("Hello3");
      final stream = await yt.videos.streamsClient.get(video);
      print("Hello4");
      final appDir = await pt.getExternalStorageDirectory();
      final savePath = appDir!.path + '/$title.mp4';

      // Save video file
      await _saveStream(stream, savePath);

      print('Video downloaded successfully to: $savePath');

      // Clean up
      yt.close();
    // } else {
      await Permission.storage.request();
    }
  }
// }

import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:file_selector/file_selector.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> readFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  if (result != null) {
    File file = File(result.files.single.path!);
    String content = await file.readAsString();
    return content;
  } else {
    // User canceled the picker
    return "";
  }
}

Future<bool> writeFile({
  required String data,
  required String filename,
}) async {
  if (Platform.isAndroid) {
    // 権限の確認
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      return false;
    }
    // 保存先の確認
    String? outputDir = await FilePicker.platform.getDirectoryPath();
    if (outputDir == null) {
      return false;
    }
    // ファイル名の決定
    String outputFile = "$outputDir/$filename";
    var file = File(outputFile);
    var count = 1;
    while (true) {
      // 既にファイルが存在していたら output (1).json みたいに別名にする
      bool exist = await file.exists();
      if (!exist) {
        break;
      }
      file = File(outputFile.replaceFirst(".json", " ($count).json"));
      count++;
    }
    await file.writeAsString(data);
    return true;
  } else if (Platform.isWindows) {
    final FileSaveLocation? path =
        await getSaveLocation(suggestedName: filename);
    if (path == null) {
      return false;
    }

    final Uint8List fileData = Uint8List.fromList(data.codeUnits);
    const mimeType = "application/json";
    final XFile textFile =
        XFile.fromData(fileData, mimeType: mimeType, name: filename);
    await textFile.saveTo(path.path);
    return true;
  }
  return false;
}

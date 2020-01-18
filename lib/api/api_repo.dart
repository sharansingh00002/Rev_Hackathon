import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info/device_info.dart';
import 'package:flutter_app/model.dart';
import 'package:http/http.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class ApiRepo {
  Future<bool> uploadPdf({String fileName}) async {
    Client client = Client();
    File file = File(fileName);
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo mobileUniqId = await deviceInfo.androidInfo;
    String deviceId = mobileUniqId.androidId;

    String base64 = base64Encode(file.readAsBytesSync());

    final response = await client.post('http://192.168.13.139:3000/upload',
        body: json.encode({
          "file": base64,
          "file_name": (basename(fileName).split('.pdf')[0])
        }),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});

    print('responseis ${response.statusCode}');
    return (response.statusCode == 200);
  }

  Future<String> downloadFile(String fileName) async {
    Client client = Client();
    final response =
        await client.get('http://192.168.13.139:3000/view_file/$fileName');
    String base64File = response.body;
    String filePath = await _createFileFromString(encodedStr: base64File);
    return filePath;
  }

  convertFile({String fileName}) async {
    File file = File(fileName);
    String base64 = base64Encode(file.readAsBytesSync());
    String fileAddress = await _createFileFromString(encodedStr: base64);
    OpenFile.open(fileAddress);
  }

  Future<String> _createFileFromString({String encodedStr}) async {
    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".txt");
    await file.writeAsBytes(bytes);
    return file.path;
  }

  Future getPdfLists() async {
    Client client = Client();
    final response = await client.get('http://192.168.13.139:3000/readyFiles');
    List<UserSharedCampaignsList> userSharedCampaignsList =
        userSharedCampaignsListFromJson(response.body);
    return userSharedCampaignsList;
  }
}

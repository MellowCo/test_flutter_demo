import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  XFile? photo;
  final ImagePicker _picker = ImagePicker();
  final dio = Dio();
  String uploadInfo = "等待上传";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("相机"),
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text("拍照"),
                  onPressed: () async {
                    photo = await _picker.pickImage(source: ImageSource.camera);

                    setState(() {
                      photo = photo;
                    });
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                OutlinedButton(
                  child: const Text("上传"),
                  onPressed: () async {
                    if (photo == null) {
                      // toast
                      Fluttertoast.showToast(msg: "请先拍照");
                      return;
                    }
                    // 上传
                    try {
                      EasyLoading.show(status: 'loading...');

                      final formData = FormData.fromMap({
                        'file': await MultipartFile.fromFile(photo!.path,
                            filename: 'upload.jpg')
                      });
                      final response = await dio.post(
                          'https://dev-cnfw.vasen.com/api/floor_heating_api/upload/receiveandupload',
                          data: formData);

                      setState(() {
                        uploadInfo = response.data.toString();
                      });

                      print(response);
                    } catch (e) {
                      Fluttertoast.showToast(msg: "上传失败 $e");
                    } finally {
                      EasyLoading.dismiss();
                    }
                  },
                ),
              ],
            ),
            photo == null
                ? const Text("未选择图片")
                : Image.file(
                    File(photo!.path),
                    width: 300,
                    height: 300,
                  ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SelectableText("上传结果: $uploadInfo"),
            ),
          ],
        ));
  }
}

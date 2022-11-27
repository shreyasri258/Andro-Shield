import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:malicious_android_app/loading.dart';

class ExampleStartScreen extends StatefulWidget {
  @override
  State<ExampleStartScreen> createState() => _ExampleStartScreenState();
}

class _ExampleStartScreenState extends State<ExampleStartScreen> {
  @override
  bool loading = false;

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return loading
        ? Loading()
        : MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/android_logo.png',
                      height: 380,
                      width: 400,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var picked = await FilePicker.platform.pickFiles(
                            allowedExtensions: ['apk'],
                            withReadStream: true,
                            type: FileType.custom);
                        if (picked != null) {
                          try {
                            http.MultipartRequest request =
                                http.MultipartRequest(
                                    'POST',
                                    Uri.parse(
                                        'https://malicious-apk.herokuapp.com/'));
                            final stream = picked.files.first.readStream!;
                            request.files.add(http.MultipartFile(
                              'file',
                              stream,
                              picked.files.first.size,
                              filename: picked.files.first.name,
                            ));
                            setState(() => loading = true);
                            http.StreamedResponse response =
                                await request.send();
                            setState(() => loading = false);
                            if (response.statusCode == 200) {
                              var json = await response.stream.bytesToString();
                              // print(json);
                              var list = jsonDecode(json);
                              var name1 = picked.files.first.name.toString();
                              if (list.toString() == "false") {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    backgroundColor: Colors.lightGreen,
                                    title: const Text("Safe APK"),
                                    content: Text(
                                        "We have tested this APK with multiple parameters, ${name1} is completely safe, go ahead and install it."),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Container(
                                          color: Colors.green,
                                          padding: const EdgeInsets.all(14),
                                          child: const Text("OK"),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    backgroundColor: Colors.redAccent,
                                    title: const Text("Danger APK"),
                                    content: Text(
                                        "We have tested this APK with multiple parameters, ${name1} is not safe.Do not install it!!!"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Container(
                                          color: Colors.green,
                                          padding: const EdgeInsets.all(14),
                                          child: const Text("OK"),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            } else {
                              setState(() => loading = false);
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text(
                                      "There was some error when extracting the APK, please try again"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Container(
                                        color: Colors.green,
                                        padding: const EdgeInsets.all(14),
                                        child: const Text("OK"),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } catch (e) {
                            setState(() => loading = false);
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Error"),
                                content: const Text(
                                    "There was some error uploading the file, please upload again"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Container(
                                      color: Colors.green,
                                      padding: const EdgeInsets.all(14),
                                      child: const Text("OK"),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Upload apk'),
                    ),
                    Center(
                        child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: size.height * 0.055,
                        // color: Colors.black87,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.copyright_outlined,
                                color: Colors.black87,
                              ),
                              Text(
                                'Copyright AndroShield 2022',
                                style: TextStyle(color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ),
          );
  }
}

import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class MessageSendScreen extends HookConsumerWidget {
  final _textController = TextEditingController();

  MessageSendScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _image = useState<XFile?>(null);

    return Scaffold(
      appBar: AppBar(
        title: const Text('新規メッセージ作成'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                child: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    filled: false,
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(8.0),
              child: _image.value == null
                  ? Container()
                  : Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.file(
                              File(_image.value!.path),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          onTap: () {
                            showGeneralDialog(
                              context: context,
                              pageBuilder: (context, animation1, animation2) {
                                return Container(
                                  color: Colors.black,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.arrow_back),
                                            color: Colors.white,
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Container(
                                            width: MediaQuery.of(context).size.width,
                                            height: MediaQuery.of(context).size.height,
                                            child: Image.file(
                                              File(_image.value!.path),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        Positioned(
                          top: -10,
                          right: -10,
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: IconButton(
                              iconSize: 20,
                              padding: EdgeInsets.all(0),
                              color: Colors.white,
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
                              ),
                              icon: Icon(Icons.close),
                              onPressed: () {
                                _image.value = null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            Container(
              color: Colors.brown[800],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () async {
                      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (image == null) return;
                      _image.value = image;
                    },
                    icon: Icon(
                      Icons.attach_file,
                      color: Colors.white,
                    ),
                  ),
                  TextButton.icon(
                    label: Text(
                      '送信',
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      final message = _textController.text;
                      if (message.isEmpty) {
                        showSnackBar(context: context, message: "メッセージを入力してください");
                        return;
                      }

                      showProgress(context);
                      try {
                        await FirebaseFunctions.instanceFor(region: 'asia-northeast1')
                            .httpsCallable('createNewMessage')
                            .call({"message": message});

                        showSnackBar(context: context, message: "メッセージを送信しました");
                        _textController.clear();
                      } catch (e) {
                        showSnackBar(context: context, message: "メッセージの送信に失敗しました");
                      } finally {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSnackBar(
      {required BuildContext context, required String message, Duration duration = const Duration(seconds: 3)}) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 20,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color: Color(0xFF333333),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  offset: Offset(0, 5),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () => overlayEntry.remove());
  }

  void showProgress(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration(milliseconds: 300),
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, animation1, animation2) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }
}

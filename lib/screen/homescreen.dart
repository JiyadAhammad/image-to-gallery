import 'dart:io';
import 'package:add_to_gallery/add_to_gallery.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';

import '../database/dbmodel.dart';
import 'displayscrren.dart';

const String flutter = 'flutter';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int count = 1;
  XFile? imageFile;

  Future<void> chooseImage(ImageSource src) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: src);
    XFile imageFile = XFile(pickedFile!.path);

    final File file = File(pickedFile.path);
    await AddToGallery.addToGallery(
      deleteOriginalFile: false,
      originalFile: file,
      albumName: flutter,
    );

    setState(
      () {
        imageFile = pickedFile;
        Hive.box<Gallery>('gallery').add(
          Gallery(imagePath: pickedFile.path),
        );
      },
    );
    File(imageFile.path);

    count++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Gallery'),
        centerTitle: true,
        elevation: 10,
      ),
      body: ValueListenableBuilder<Box<Gallery>>(
        valueListenable: Hive.box<Gallery>('gallery').listenable(),
        builder: (BuildContext context, Box<Gallery> box, Widget? _) {
          final List<dynamic> keys = box.keys.toList();
          if (keys.isEmpty) {
            return const Center(
              child: Text(
                'Add Image ',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 160,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemBuilder: (BuildContext context, int index) {
                final List<Gallery> data = box.values.toList();
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => DisplayImage(
                          image: data[index].imagePath,
                          index: index,
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: const Text('Do you want to delete the image?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('CANCEL'),
                          ),
                          TextButton(
                            onPressed: () {
                              data[index].delete();
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 0.5),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(
                          File(
                            data[index].imagePath!,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: keys.length,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          chooseImage(ImageSource.camera);
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

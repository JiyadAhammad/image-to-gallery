import 'dart:io';

import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:photo_view/photo_view.dart';

import '../database/dbmodel.dart';
import 'homescreen.dart';

class DisplayImage extends StatelessWidget {
  const DisplayImage({super.key, required this.image, required this.index});
  final String? image;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('back to gallery'),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            child: const Icon(Icons.delete),
            onTap: () {
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
                        Hive.box<Gallery>('Gallery').deleteAt(index);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) => const HomeScreen()),
                            (Route<dynamic> route) => false);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding:EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: PhotoView(
                    backgroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    imageProvider: FileImage(
                      File(image!),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

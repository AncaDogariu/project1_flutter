import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_1/database/databasehelper.dart';

import '../constants.dart';
/*
class ImageListPage extends StatefulWidget {
  final DatabaseHelper databaseHelper;

  const ImageListPage({Key? key, required this.databaseHelper}) : super(key: key);

  @override
  _ImageListPageState createState() => _ImageListPageState();
}

class _ImageListPageState extends State<ImageListPage> {
  List<Map<String, dynamic>> _images = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final images = await widget.databaseHelper.getImages();
    setState(() {
      _images = images;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image List'),
        backgroundColor: Constants.primaryColor,
      ),
      body: ListView.builder(
        itemCount: _images.length,
        itemBuilder: (context, index) {
          final image = _images[index];
          final imageFile = File(image['file_path']);
          final plantName = image['plant_name'];
          final accuracy = image['accuracy'];

          return ListTile(
            title: Image.file(imageFile),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Plant Name: $plantName'),
                Text('Accuracy: ${(accuracy * 100).toStringAsFixed(2)}%'),
              ],
            ),
          );
        },
      ),
    );
  }
}
*/
class ImageListPage extends StatefulWidget {
  final DatabaseHelper databaseHelper;

  const ImageListPage({Key? key, required this.databaseHelper}) : super(key: key);

  @override
  _ImageListPageState createState() => _ImageListPageState();
}

class _ImageListPageState extends State<ImageListPage> {
  List<Map<String, dynamic>> _images = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final images = await widget.databaseHelper.getImages();
    setState(() {
      _images = images.toList(); // Create a copy of the list
    });
  }

  Future<void> _deleteImage(int index) async {
    final image = _images[index];
    final db = await widget.databaseHelper.database;
    await db.delete('images', where: 'id = ?', whereArgs: [image['id']]);
    setState(() {
      _images.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image List'),
        backgroundColor: Constants.primaryColor,
      ),
      body: ListView.builder(
        itemCount: _images.length,
        itemBuilder: (context, index) {
          final image = _images[index];
          final imageFile = File(image['file_path']);
          final plantName = image['plant_name'];
          final accuracy = image['accuracy'];

          return ListTile(
            title: Image.file(imageFile),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Plant Name: $plantName'),
                Text('Accuracy: ${(accuracy * 100).toStringAsFixed(2)}%'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteImage(index);
              },
            ),
          );
        },
      ),
    );
  }
}

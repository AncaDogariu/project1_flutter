import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_app_1/screens/ImageListPage.dart';
import 'package:flutter_app_1/database/databasehelper.dart';
import '../classifier/classifier.dart';
import '../constants.dart';
import '../styles.dart';
import 'plant_photo_view.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;


// const _labelsFileName = 'assets/labels.txt';
// const _modelFileName = 'model_287_flowers.tflite'; 

const _labelsFileName = 'assets/labels.txt';
const _modelFileName = 'best_float32p.tflite'; 

class PlantRecogniser extends StatefulWidget {
  const PlantRecogniser({super.key});

  @override
  State<PlantRecogniser> createState() => _PlantRecogniserState();
}

enum _ResultStatus {
  notStarted,
  notFound,
  found,
}

class _PlantRecogniserState extends State<PlantRecogniser> {
  List<File> savedImages = [];
  bool _isAnalyzing = false;
  final picker = ImagePicker();
  File? _selectedImageFile;

  // Result
  _ResultStatus _resultStatus = _ResultStatus.notStarted;
  String _plantLabel = ''; 
  double _accuracy = 0.0;

  late Classifier _classifier;
  late DatabaseHelper _databaseHelper;


  @override
  void initState() {
    super.initState();
    _loadClassifier();  // run asynchronous loading of the classifier instance
    _databaseHelper = DatabaseHelper.instance; //  an instance of the DatabaseHelper class 

  }

  Future<void> _loadClassifier() async {
    debugPrint(
      'Start loading of Classifier with '
      'labels at $_labelsFileName, '
      'model at $_modelFileName',
    );
    // Call loadWith() with the file paths for the labels and model files.
    final classifier = await Classifier.loadWith(
      labelsFileName: _labelsFileName,
      modelFileName: _modelFileName,
    );
    //Save the instance to the widget’s state property
    _classifier = classifier!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBgColor,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 10.0),
            child: _buildTitle(),
            
          ),
        GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Constants.primaryColor.withOpacity(.15),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Constants.primaryColor,
                      ),
                    ),
                  ),
          const SizedBox(height: 20),
          _buildPhotolView(),
          const SizedBox(height: 10),
          _buildResultView(),
          const Spacer(flex: 5),
          _buildPickPhotoButton(
            title: 'Take a photo',
            source: ImageSource.camera,
          ),
          _buildPickPhotoButton(
            title: 'Upload from gallery',
            source: ImageSource.gallery,
          ),
          const Spacer(),
           _buildOpenImageListButton(),

        ],
        
      ),
    );
  }

  Widget _buildPhotolView() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        PlantPhotoView(file: _selectedImageFile),
        _buildAnalyzingText(),
      ],
    );
  }

  Widget _buildAnalyzingText() {
    if (!_isAnalyzing) {
      return const SizedBox.shrink();
    }
    return const Text('Analyzing...', style: kAnalyzingTextStyle);
  }

  Widget _buildTitle() {
    return const Text(
      'Identify!',
      style: kTitleTextStyle,
      textAlign: TextAlign.left,
    );
  }

  Widget _buildPickPhotoButton({
    required ImageSource source,
    required String title,
  }) {
    return TextButton(
      onPressed: () => _onPickPhoto(source),
      child: Container(
        width: 300,
        height: 50,
        color: kColorButtons,
        child: Center(
            child: Text(title,
                style: const TextStyle(
                  fontFamily: kButtonFont,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: kColorLightYellow,
                ))),
      ),
    );
  }

 Widget _buildOpenImageListButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageListPage(databaseHelper: _databaseHelper),
            
          ),
        );
      },
      style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Constants.primaryColor),),
      child: const Text('Open Image List'),
      
    );
  }


// Future<String> _uploadImageToFirebase(File imageFile) async {
//   try {
//     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     firebase_storage.Reference ref =
//         firebase_storage.FirebaseStorage.instance.ref().child(fileName);
//     await ref.putFile(imageFile);
//     String imageUrl = await ref.getDownloadURL();
//     return imageUrl;
//   } catch (e) {
//     print('Error uploading image to Firebase Storage: $e');
//     throw e; // Aruncare excepție în caz de eroare
//   }
// }



  void _setAnalyzing(bool flag) {
    setState(() {
      _isAnalyzing = flag;
    });
  }

  void _onPickPhoto(ImageSource source) async {
    //Pick an image from the image source( the camera or gallery)
    final pickedFile = await picker.pickImage(source: source);
    //Implement handling in case the user decides to cancel
    if (pickedFile == null) {
      return;
    }
    //Wrap the selected file path with a File object.
    final imageFile = File(pickedFile.path);

   // Change the state of _selectedImageFile to display the photo.
    setState(() {
      _selectedImageFile = imageFile;
    });
    final now = DateTime.now();
    final date = '${now.year}-${now.month}-${now.day}';

    _analyzeImage(imageFile);
    
  }

  void _analyzeImage(File image) async{
    _setAnalyzing(true);
    //Get the image from the file input
    final imageInput = img.decodeImage(image.readAsBytesSync())!;
    //Use Classifier to predict the best category
    final resultCategory = _classifier.predict(imageInput);
    // Define the result of the prediction (f the score is too low, less than 60%, it treats the result as Not Found)
    final result = resultCategory.score >= 0.6
        ? _ResultStatus.found
        : _ResultStatus.notFound;
    final plantLabel = resultCategory.label;
    final accuracy = resultCategory.score;

    _setAnalyzing(false);
    
    await _databaseHelper.insertImage(image.path, DateTime.now().toString(),
        plantLabel, accuracy); // Saving predicted image in the database

    //Change the state of the data responsible for the result display
    setState(() {
      _resultStatus = result;
      _plantLabel = plantLabel;
      _accuracy = accuracy;
    });
  }

  Widget _buildResultView() {
    var title = '';

    if (_resultStatus == _ResultStatus.notFound) {
      title = 'Fail to recognise';
    } else if (_resultStatus == _ResultStatus.found) {
      title = _plantLabel;
    } else {
      title = '';
    }

    var accuracyLabel = '';
    if (_resultStatus == _ResultStatus.found) {
      accuracyLabel = 'Accuracy: ${(_accuracy * 100).toStringAsFixed(2)}%';
    }

    return Column(
      children: [
        Text(title, style: kResultTextStyle),
        const SizedBox(height: 10),
        Text(accuracyLabel, style: kResultRatingTextStyle)
      ],
    );
  }
}

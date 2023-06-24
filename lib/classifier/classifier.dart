
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'classifier_category.dart';
import 'classifier_model.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'package:flutter/services.dart';

typedef ClassifierLabels = List<String>;

class Classifier {
  final ClassifierLabels _labels;
  final ClassifierModel _model;

  Classifier._({
    required ClassifierLabels labels,
    required ClassifierModel model,
  })  : _labels = labels,
        _model = model;

  static Future<Classifier?> loadWith({
    required String labelsFileName,
    required String modelFileName,
  }) async {
    try {
      final labels = await _loadLabels(labelsFileName);
      final model = await _loadModel(modelFileName);
      return Classifier._(labels: labels, model: model);
    } catch (e) {
      
      debugPrint('Can\'t initialize classifier: ${e.toString()}');
      if (e is Error) {
        debugPrintStack(stackTrace: e.stackTrace);
      }
      return null;
    }
  }

  static Future<ClassifierModel> _loadModel(String modelFileName) async {
    //Creates an interpreter with the model file
    final interpreter = await Interpreter.fromAsset(modelFileName);

    // Get input and output shape from the model
    final inputShape = interpreter.getInputTensor(0).shape;
    final outputShape = interpreter.getOutputTensor(0).shape;

    debugPrint('Input shape: $inputShape');
    debugPrint('Output shape: $outputShape');

    // Get input and output type from the model
    final inputType = interpreter.getInputTensor(0).type;
    final outputType = interpreter.getOutputTensor(0).type;

    debugPrint('Input type: $inputType');
    debugPrint('Output type: $outputType');

    return ClassifierModel(
      interpreter: interpreter,
      inputShape: inputShape,
      outputShape: outputShape,
      inputType: inputType,
      outputType: outputType,
    );
  }

  static Future<ClassifierLabels> _loadLabels(String labelsFileName) async {
    // Loads the labels using the file utility from tflite_flutter_helper
    final rawLabels = await FileUtil.loadLabels(labelsFileName);
    // Remove the index number from the label
    final labels = rawLabels
        .map((label) => label.substring(label.indexOf(' ')).trim())
        .toList();

    debugPrint('Labels: $labels');
    return labels;
  }

  void close() {
    _model.interpreter.close();
  }

  ClassifierCategory predict(Image image) {
    debugPrint(
      'Image: ${image.width}x${image.height}, '
      'size: ${image.length} bytes',
    );

    // Load the image and convert it to TensorImage for TensorFlow Input
    final inputImage = _preProcessInput(image);

    debugPrint(
      'Pre-processed image: ${inputImage.width}x${image.height}, '
      'size: ${inputImage.buffer.lengthInBytes} bytes',
    );

    // Define the output buffer: TensorBuffer stores the final scores of the prediction in raw format
    final outputBuffer = TensorBuffer.createFixedSize(
      _model.outputShape,
      _model.outputType,
    );

    // Run inference (interpreter reads the tensor image and stores the output in the buffer)
    _model.interpreter.run(inputImage.buffer, outputBuffer.buffer);
    debugPrint('OutputBuffer: ${outputBuffer.getDoubleList()}');

    // Post Process the outputBuffer
    final resultCategories = _postProcessOutput(outputBuffer);
    final topResult = resultCategories.first;

    debugPrint('Top category: $topResult');

    return topResult;
  }

  List<ClassifierCategory> _postProcessOutput(TensorBuffer outputBuffer) {
    // instance of TensorProcessorBuilder to parse and process the output
    final probabilityProcessor = TensorProcessorBuilder().build();
    probabilityProcessor.process(outputBuffer);

    // Map output values to the labels.
    final labelledResult = TensorLabel.fromList(_labels, outputBuffer); // association between labels and scores(outputbuffer values)

    // Build category instances with the list of label – score records
    final categoryList = <ClassifierCategory>[];
    labelledResult.getMapWithFloatValue().forEach((key, value) {
      final category = ClassifierCategory(key, value);
      categoryList.add(category);
      debugPrint('label: ${category.label}, score: ${category.score}');
    });

    // Sort the list to place the most likely result first
    categoryList.sort((a, b) => (b.score > a.score ? 1 : -1));

    return categoryList;
  }

 TensorImage _preProcessInput(Image image) {
    // Create the TensorImage and load the image data to it
    final inputTensor = TensorImage(_model.inputType);
    inputTensor.loadImage(image);

    // Crop the image to a square shape.
    final minLength = min(inputTensor.height, inputTensor.width);
    final cropOp = ResizeWithCropOrPadOp(minLength, minLength);

    // Resize the image operation to fit the shape requirements of the model.
    final shapeLength = _model.inputShape[2];
    final resizeOp = ResizeOp(shapeLength, shapeLength, ResizeMethod.BILINEAR);

    // Normalize the value of the data
    final normalizeOp = NormalizeOp(127.5, 127.5);

    // Create the image processor with the defined operations and preprocess the image
    final imageProcessor = ImageProcessorBuilder()
        // .add(cropOp)
        .add(resizeOp)
        .add(normalizeOp)
        .build();

    imageProcessor.process(inputTensor);

    // Return the preprocessed image
    return inputTensor;
  } 


// TensorImage _preProcessInput(Image image) {
//   // #1
//   final inputTensor = TensorImage(_model.inputType);
//   inputTensor.loadImage(image);

//   // #2
//   final targetSize = 224;
//   final aspectRatio = inputTensor.width / inputTensor.height;
//   final resizeWidth = (aspectRatio >= 1.0) ? targetSize : (targetSize * aspectRatio).round();
//   final resizeHeight = (aspectRatio >= 1.0) ? (targetSize / aspectRatio).round() : targetSize;
//   final resizeOp = ResizeOp(resizeWidth, resizeHeight, ResizeMethod.BILINEAR);

//   // #3
//   final normalizeOp = NormalizeOp(127.5, 127.5);

//   // #4
//   final imageProcessor = ImageProcessorBuilder()
//       .add(resizeOp)
//       .add(normalizeOp)
//       .build();

//   imageProcessor.process(inputTensor);

//   // #5
//   return inputTensor;
// }


}

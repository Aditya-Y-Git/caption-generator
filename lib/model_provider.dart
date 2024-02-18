import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mime/mime.dart';

class ModelProvider extends ChangeNotifier {
  String caption = "No caption";

  String get getCaption => caption;

  Future<void> generateCaption({
    required String promptString,
    required String imagePath,
  }) async {
    var mimeType = lookupMimeType(imagePath);
    mimeType ??= "image/jpeg";
    final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: 'apiKey');
    final imageBytes = await File(imagePath).readAsBytes();
    final content = [
      Content.multi([
        TextPart(promptString),
        DataPart(mimeType, imageBytes),
      ])
    ];
    try {
      final response = await model.generateContent(content);
      print(response.text);
      if (response.text != null) {
        caption = response.text!;
      }
    } catch (e) {
      print("Error occured $e");
    }
    notifyListeners();
  }
}

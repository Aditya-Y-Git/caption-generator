import 'dart:io';

import 'package:caption_generator/image_input.dart';
import 'package:caption_generator/model_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String prompt =
      "Generate a caption for the image, that I want to post on my social media ";
  String regeneratePrompt = "Generate another caption";

  File? selectedImage;
  String generatedCaption = "";
  bool isCaptionGenerated = false;
  bool isCaptionGenerating = false;
  TextEditingController keywordsController = TextEditingController();

  @override
  void dispose() {
    keywordsController.dispose();
    super.dispose();
  }

  void selectNewImage() {
    setState(() {
      selectedImage = null;
      isCaptionGenerated = false;
    });
  }

  void generateCaption(ModelProvider value) async {
    setState(() {
      isCaptionGenerating = true;
    });
    if (selectedImage != null) {
      await value.generateCaption(
        promptString: prompt,
        imagePath: selectedImage!.path,
      );
      setState(() {
        generatedCaption = value.caption;
        isCaptionGenerated = true;
        isCaptionGenerating = false;
      });
    }
  }

  void regenerateCaption(ModelProvider value) async {
    setState(() {
      isCaptionGenerating = true;
      isCaptionGenerated = false;
    });
    await value.generateCaption(
        promptString: regeneratePrompt, imagePath: selectedImage!.path);
    setState(() {
      generatedCaption = value.getCaption;
      isCaptionGenerated = true;
      isCaptionGenerating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelProvider>(
      builder: (context, value, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: MediaQuery.of(context).viewPadding.top + 50),
                // header
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    'Relax, let us take the caption worries off your hands',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // image picker
                Text(
                  isCaptionGenerated
                      ? 'Tap on image to pick new image'
                      : 'Pick your image',
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ImageInput(
                  onPickImage: (image) {
                    selectedImage = image;
                  },
                  onTapImage: selectNewImage,
                ),
                const SizedBox(height: 10),

                // generate caption button
                if (!isCaptionGenerated) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: keywordsController,
                      decoration:
                          const InputDecoration(hintText: "Enter any keywords"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isCaptionGenerating = true;
                      });
                      if (selectedImage != null) {
                        await value.generateCaption(
                          promptString: prompt + keywordsController.text,
                          imagePath: selectedImage!.path,
                        );
                        setState(() {
                          generatedCaption = value.caption;
                          isCaptionGenerated = true;
                          isCaptionGenerating = false;
                        });
                      }
                    },
                    child: const Text('Generate Caption'),
                  ),
                ],

                // circular progress indicator
                if (isCaptionGenerating)
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15)),
                    child: const CircularProgressIndicator(),
                  ),

                // generated caption
                if (isCaptionGenerated) ...[
                  const SizedBox(height: 10),
                  Text(
                    'Your caption',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15)),
                    child: Text(
                      generatedCaption,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // regenerate button
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isCaptionGenerating = true;
                          isCaptionGenerated = false;
                        });
                        await value.generateCaption(
                            promptString: regeneratePrompt,
                            imagePath: selectedImage!.path);
                        setState(() {
                          generatedCaption = value.getCaption;
                          isCaptionGenerated = true;
                          isCaptionGenerating = false;
                        });
                      },
                      child: Text(
                        "Didn't like? Generate another",
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ))
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

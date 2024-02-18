import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput(
      {super.key, required this.onPickImage, required this.onTapImage});
  final void Function(File image) onPickImage;
  final VoidCallback onTapImage;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? selectedImage;
  final imagePicker = ImagePicker();
  void selectFromGallery() async {
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;

    setState(() {
      selectedImage = File(pickedImage.path);
    });

    widget.onPickImage(selectedImage!);
  }

  void takePicture() async {
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedImage == null) return;

    setState(() {
      selectedImage = File(pickedImage.path);
    });

    widget.onPickImage(selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
      ),
      alignment: Alignment.center,
      child: selectedImage == null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: takePicture,
                  child: const Icon(
                    Icons.camera_alt,
                    size: 80,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: selectFromGallery,
                  child: const Icon(
                    Icons.image,
                    size: 80,
                    color: Colors.black,
                  ),
                ),
              ],
            )
          : GestureDetector(
              onTap: () {
                setState(() {
                  selectedImage = null;
                });
                widget.onTapImage();
              },
              child: Image.file(
                selectedImage!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
    );
  }
}

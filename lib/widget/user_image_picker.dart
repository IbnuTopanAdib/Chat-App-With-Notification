import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) onPickImage;

  const UserImagePicker({super.key, required this.onPickImage});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _userImagePicker;

  void pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 150,
      imageQuality: 50,
    );

    if (pickedImage == null) {
      return;
    }
    setState(() {
      _userImagePicker = File(pickedImage.path);
    });

    widget.onPickImage(_userImagePicker!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.orange.withOpacity(0.5),
          foregroundImage:
              _userImagePicker != null ? FileImage(_userImagePicker!) : null,
        ),
        TextButton(
          onPressed: pickImage,
          child: const Text('Upload Image'),
        )
      ],
    );
  }
}

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' show XFile;

/// Preview of an image the vendor has just picked or photographed.
///
/// `Image.file` takes a `dart:io` File, which does not exist on the web, and
/// an [XFile]'s `path` there is a blob URL rather than a real file — so the
/// obvious workarounds fail on one platform or the other. Reading the bytes
/// behaves identically everywhere.
///
/// The read is a Future even on mobile, hence the placeholder; it resolves
/// fast enough that it is rarely seen.
class PickedImage extends StatelessWidget {
  const PickedImage(
    this.file, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  final XFile file;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: file.readAsBytes(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey.shade200,
            child: const Center(
              child: Icon(Icons.broken_image_outlined, color: Colors.grey),
            ),
          );
        }
        if (!snapshot.hasData) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey.shade100,
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        return Image.memory(
          snapshot.data!,
          width: width,
          height: height,
          fit: fit,
        );
      },
    );
  }
}

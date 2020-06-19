

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final picker = ImagePicker();
  // Returns a [File] object pointing to the image that was picked.
  Future<PickedFile> pickImage({@required ImageSource source}) async {
    return picker.getImage(source: source);
  }
}
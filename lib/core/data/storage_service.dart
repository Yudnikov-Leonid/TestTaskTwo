import 'package:cloudinary/cloudinary.dart';
import 'package:image_picker/image_picker.dart';

abstract class StorageService {
  Future<(String?, bool)> loadImage(XFile file);
}

class StorageServiceImpl implements StorageService {

  @override
  Future<(String?, bool)> loadImage(XFile file) async {
    try {
      final cloudinary = Cloudinary.signedConfig(
        apiKey: '858661424547151',
        apiSecret: 'QH39cNlOLl2pHvLbdoA-cWq7z1w',
        cloudName: 'djayfmcan',
      );

      final response = await cloudinary.unsignedUpload(
          uploadPreset: 'userimage',
          file: file.path,
          resourceType: CloudinaryResourceType.image,
          fileName: file.name.split('.').first,
          progressCallback: (count, total) {
            print('Uploading image from file with progress: $count/$total');
          });

      if (response.isSuccessful) {
        print('url: ${response.secureUrl}');
        return (response.secureUrl, true);
      } else {
        return (response.error ?? 'Error', false);
      }
    } catch (e) {
      print('upload error: $e');
      return (e.toString(), true);
    }
  }
}

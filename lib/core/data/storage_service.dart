import 'package:cloudinary/cloudinary.dart';
import 'package:image_picker/image_picker.dart';

abstract class StorageService {
  Future<String?> loadImage(XFile file);
}

class StorageServiceImpl implements StorageService {
  @override
  Future<String?> loadImage(XFile file) async {
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
            //print('Uploading image from file with progress: $count/$total');
          });

      if (response.isSuccessful) {
        return response.secureUrl;
      }
    } catch (e) {
      print('upload error: $e');
    }
    return null;
  }
}

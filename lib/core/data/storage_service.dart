import 'package:cloudinary/cloudinary.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:profile_app/di.dart';

import 'keys.dart';

abstract class StorageService {
  Future<(String?, bool)> loadImage(XFile file);
}

class StorageServiceImpl implements StorageService {

  @override
  Future<(String?, bool)> loadImage(XFile file) async {
    try {
      final cloudinary = Cloudinary.signedConfig(
        apiKey: Keys.cloudStorageApiKey,
        apiSecret: Keys.cloudStorageApiSecret,
        cloudName: Keys.cloudStorageName,
      );

      final response = await cloudinary.unsignedUpload(
          uploadPreset: Keys.cloudStorageUploadPreset,
          file: file.path,
          resourceType: CloudinaryResourceType.image,
          fileName: file.name.split('.').first,
          progressCallback: (count, total) {
            di.get<Logger>().t('Uploading image from file with progress: $count/$total');
          });

      if (response.isSuccessful) {
        di.get<Logger>().d('url: ${response.secureUrl}');
        return (response.secureUrl, true);
      } else {
        di.get<Logger>().e('uploading error: ${response.error}');
        return (response.error ?? 'Error', false);
      }
    } catch (e) {
      di.get<Logger>().e(e.toString(), error: e);
      return (e.toString(), true);
    }
  }
}

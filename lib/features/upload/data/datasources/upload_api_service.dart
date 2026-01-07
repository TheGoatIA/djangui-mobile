import 'package:chopper/chopper.dart';
import 'package:http/http.dart' show MultipartFile;
import '../models/upload_model.dart';
import '../../../../core/network/models/base_response.dart';

part 'upload_api_service.chopper.dart';

@ChopperApi(baseUrl: '/upload')
abstract class UploadApiService extends ChopperService {
  static UploadApiService create([ChopperClient? client]) =>
      _$UploadApiService(client);

  @Post(path: '/receipt')
  @Multipart()
  Future<Response<BaseResponse<UploadResponseModel>>> uploadReceipt(
    @PartFile('receipt') String filePath,
  );

  @Post(path: '/avatar')
  @Multipart()
  Future<Response<BaseResponse<UploadResponseModel>>> uploadAvatar(
    @PartFile('avatar') MultipartFile file,
  );
}

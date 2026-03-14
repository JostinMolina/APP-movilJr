import 'package:dio/dio.dart';
import 'package:myapp/domain/message.dart';
import 'package:myapp/infrastructure/models/yes_no_model.dart';

class GetYesNoAnswer {
  final _dio = Dio();

  Future<Message> getAnswer() async {
    final response = await _dio.get('https://yesno.wtf/api');

    final yesNoModel = YesNoModel.fromJson(response.data);

    return yesNoModel.toMessageEntity();
  }
}

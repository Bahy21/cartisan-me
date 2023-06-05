import 'package:cartisan/app/api_classes/api_service.dart';
import 'package:cartisan/app/api_classes/post_api.dart';
import 'package:cartisan/app/controllers/auth_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks(
    [MockSpec<APIService>(), MockSpec<AuthService>(), MockSpec<PostAPI>()])
void main() {}

import 'package:easydiagno/Models/UserModel/userRegistration.dart';
import 'package:http/http.dart' as http;

Future<bool?> userRegistrationApi(UserRegistrationModel userReg) async {
  final response = await http.get(Uri.parse(
      'http://172.16.145.220:5000/user?email=${userReg.email}&password=${userReg.password}&name=${userReg.name}'));

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

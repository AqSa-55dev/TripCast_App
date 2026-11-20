
import 'package:http/http.dart' as http;

class ApiServices {

  getMethod(String completeUrl) async {

    http.Response response = await http.get(
      Uri.parse(completeUrl),
    );

    print("Complete Url ---> $completeUrl");
    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception("API Error: ${response.statusCode}");
    }
  }

}

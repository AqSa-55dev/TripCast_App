
import 'dart:convert';

import 'package:get/get.dart';

import '../model/city_search_model.dart';
import '../services/api_services/api_endpoints.dart';
import '../services/api_services/api_services.dart';

class ChooseLocationController extends GetxController {

  RxBool isLoading = false.obs;

  RxList<Result> listOfSearchCities = <Result>[].obs;

  CitySearchModel responseModel = CitySearchModel();

  getSearchCities(String searchText) async {
    try {

      isLoading.value = true;

      var responseFromApi = await ApiServices().getMethod(
        ApiEndpoints.searchCitiesUrl(searchText),
      );

      responseModel = CitySearchModel.fromJson(
        jsonDecode(responseFromApi),
      );

      listOfSearchCities.clear();

      for (var element in responseModel.results ?? []) {
        listOfSearchCities.add(element);
      }

      print("Search Cities--> ${listOfSearchCities.length}");

      isLoading.value = false;

      print("Response From API" + responseFromApi.toString());

    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }

}

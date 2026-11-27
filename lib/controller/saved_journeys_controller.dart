import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/local_storage/local_storage.dart';

class SavedJourneysController extends GetxController {
  static const String storageKey = "saved_journeys_list";

  // Reactive list of saved journeys (empty by default)
  RxList<Map<String, dynamic>> savedJourneys = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSavedJourneys();
  }

  // 1. Load saved journeys from LocalStorage (GetStorage)
  void loadSavedJourneys() {
    try {
      final data = LocalStorage.getData(key: storageKey);
      if (data != null && data is List) {
        savedJourneys.value = List<Map<String, dynamic>>.from(
          data.map((item) => Map<String, dynamic>.from(item)),
        );
      } else {
        savedJourneys.clear();
      }
    } catch (e) {
      debugPrint("Error loading saved journeys: $e");
      savedJourneys.clear();
    }
  }

  // 2. Save a journey to LocalStorage
  Future<void> saveJourney(Map<String, dynamic> journey) async {
    // Check if route already exists
    int existingIndex = savedJourneys.indexWhere(
      (item) => item['from'] == journey['from'] && item['to'] == journey['to'],
    );

    if (existingIndex >= 0) {
      // Update existing journey
      savedJourneys[existingIndex] = journey;
    } else {
      // Add new journey at top of list
      savedJourneys.insert(0, journey);
    }

    // Persist to GetStorage
    await LocalStorage.saveData(
      key: storageKey,
      value: savedJourneys.toList(),
    );
  }

  // 3. Delete a journey by index
  Future<void> deleteJourney(int index) async {
    if (index >= 0 && index < savedJourneys.length) {
      savedJourneys.removeAt(index);
      await LocalStorage.saveData(
        key: storageKey,
        value: savedJourneys.toList(),
      );
    }
  }

  // 4. Check if a route is already saved
  bool isJourneySaved(String from, String to) {
    return savedJourneys.any(
      (item) => item['from'] == from && item['to'] == to,
    );
  }
}

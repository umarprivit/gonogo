class SessionDataManager {
  static final SessionDataManager _instance = SessionDataManager._internal();
  factory SessionDataManager() => _instance;
  SessionDataManager._internal();

  final Map<String, dynamic> sessionData = {};

  void updateData(String key, dynamic value) {
    sessionData[key] = value;
  }

  List<String> getAllResults() {
    return sessionData.entries.map((e) => '${e.key}: ${e.value.toString()}').toList();
  }
}
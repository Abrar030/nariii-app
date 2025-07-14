class SOSLogRepository {
  // This is a singleton pattern. It ensures that only one instance of this
  // repository exists throughout the app, so all screens share the same data.

  // 1. Private constructor so it can't be instantiated from the outside.
  SOSLogRepository._internal();

  // 2. The single, static, private instance of the class.
  static final SOSLogRepository _instance = SOSLogRepository._internal();

  // 3. A factory constructor that returns the single instance.
  factory SOSLogRepository() {
    return _instance;
  }

  // The list of logs, held in memory.
  final List<Map<String, dynamic>> _logs = [];

  // A public getter to access the logs.
  List<Map<String, dynamic>> get logs => _logs;

  // A method to add a new log to the list.
  void addLog(Map<String, dynamic> log) {
    // Add to the beginning of the list so the newest appears first.
    _logs.insert(0, log);
  }
}
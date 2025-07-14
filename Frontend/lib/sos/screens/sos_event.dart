class SOSEvent {
  final DateTime dateTime;
  final String triggerMethod;
  final List<String> contactsNotified;
  final bool videoSent;
  final bool audioSent;

  SOSEvent({
    required this.dateTime,
    required this.triggerMethod,
    required this.contactsNotified,
    required this.videoSent,
    required this.audioSent,
  });
}
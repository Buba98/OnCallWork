class Message {
  final String text;
  final int lamport;
  final bool isEmployee;

  Message({
    required this.text,
    required this.lamport,
    required this.isEmployee,
  });

  Message.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        lamport = json['lamport'],
        isEmployee = json['is_employee'];

  Map<String, dynamic> get json => {
    'text': text,
    'lamport': lamport,
    'is_employee': isEmployee,
  };

  static List<Message> fromJsonList(Map<String, dynamic> document) {
    List<Message> messages = [];

    for (Map<String, dynamic> doc in document['messages']) {
      messages.add(Message.fromJson(doc));
    }

    return messages;
  }
}
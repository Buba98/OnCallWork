class Message {
  final String text;
  final int lamport;

  Message({
    required this.text,
    required this.lamport,
  });

  Message.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        lamport = json['lamport'];

  Map<String, dynamic> get json => {
        'text': text,
        'lamport': lamport,
      };

  static List<Message> fromJsonList(Map<String, dynamic> document) {
    List<Message> messages = [];

    for (Map<String, dynamic> doc in document['messages']) {
      messages.add(Message.fromJson(doc));
    }

    return messages;
  }
}

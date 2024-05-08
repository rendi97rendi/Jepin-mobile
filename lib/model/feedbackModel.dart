class FeedbackModel {
  final String id;
  final String userId;
  final String pesan;
  final String createdAt;
  final String updatedAt;
  final List<Reply> replies;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.pesan,
    required this.createdAt,
    required this.updatedAt,
    required this.replies,
  });

  factory FeedbackModel.fromMap(Map<String, dynamic> e) {
    // Ubah pengambilan replies menjadi list dari map
    final List<dynamic> repliesData = e['replies'] ?? [];
    final List<Reply> replies =
        repliesData.map((reply) => Reply.fromMap(reply)).toList();

    return FeedbackModel(
      id: e['id'].toString(),
      userId: e['user_id'].toString(),
      pesan: e['pesan'],
      createdAt: e['created_at'],
      updatedAt: e['updated_at'],
      replies: replies,
    );
  }
}

class Reply {
  final String id;
  final String idFeedback;
  final String pesan;
  final String createdAt;
  final String updatedAt;

  Reply({
    required this.id,
    required this.idFeedback,
    required this.pesan,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reply.fromMap(Map<String, dynamic> json) {
    return Reply(
      id: json['id'].toString(),
      idFeedback: json['id_feedback'].toString(),
      pesan: json['pesan'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

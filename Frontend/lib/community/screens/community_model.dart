class Community {
  String name;
  bool joined;
  final int members;
  final String image;

  Community({
    required this.name,
    required this.joined,
    required this.members,
    required this.image,
  });
}

class Post {
  final String author;
  final String content;
  final String time;
  bool liked;
  int likes;
  List<String> comments;

  Post({
    required this.author,
    required this.content,
    required this.time,
    this.liked = false,
    this.likes = 0,
    List<String>? comments,
  }) : comments = comments ?? [];
}

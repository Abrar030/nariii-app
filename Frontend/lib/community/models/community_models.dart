class Community {
  String name;
  bool joined;
  int members;
  String image; // Asset path for the community image

  Community({
    required this.name,
    this.joined = false,
    required this.members,
    required this.image,
  });
}

class Post {
  String author;
  String content;
  String time;
  int likes;
  List<String> comments;
  bool liked;

  Post({
    required this.author,
    required this.content,
    required this.time,
    this.likes = 0,
    List<String>? comments, // Nullable to allow initialization with no comments
    this.liked = false,
  }) : comments = comments ?? []; // Default to an empty list if null
}
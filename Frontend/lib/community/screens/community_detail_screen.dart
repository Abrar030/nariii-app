import 'package:flutter/material.dart';
import 'community_model.dart';

const Color kPrimaryRed = Color(0xFFF40000);

class CommunityDetailScreen extends StatefulWidget {
  final Community community;

  const CommunityDetailScreen({Key? key, required this.community}) : super(key: key);

  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen> {
  final List<Post> posts = [
    Post(author: "Alice", content: "Stay safe everyone!", time: "2h ago"),
    Post(author: "Bob", content: "There’s a traffic block near main road.", time: "1h ago"),
  ];

  final TextEditingController _postController = TextEditingController();

  void _submitPost() {
    final text = _postController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        posts.insert(0, Post(author: "You", content: text, time: "Just now"));
        _postController.clear();
      });
    }
  }

  void _toggleLike(Post post) {
    setState(() {
      post.liked = !post.liked;
      post.liked ? post.likes++ : post.likes--;
    });
  }

  void _addComment(Post post, String comment) {
    setState(() {
      post.comments.add(comment);
    });
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.community.name),
        backgroundColor: kPrimaryRed,
      ),
      body: Column(
        children: [
          // Community info header
          Container(
            width: double.infinity,
            color: Colors.grey[100],
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage(widget.community.image),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.community.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("${widget.community.members} members",
                        style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          // Posts list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return _buildPostCard(posts[index]);
              },
            ),
          ),
          // New post input
          _buildPostInputField(),
        ],
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Text(post.author.isNotEmpty ? post.author[0] : '?'),
                  backgroundColor: kPrimaryRed.withOpacity(0.2),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.author, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(post.time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.content, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(
                    post.liked ? Icons.favorite : Icons.favorite_border,
                    color: post.liked ? kPrimaryRed : Colors.grey,
                    size: 20,
                  ),
                  onPressed: () => _toggleLike(post),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(4),
                ),
                const SizedBox(width: 4),
                Text('${post.likes}'),
                const SizedBox(width: 24),
                const Icon(Icons.comment_outlined, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Text('${post.comments.length}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _postController,
              decoration: InputDecoration(
                hintText: 'Write a post...',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              ),
              onSubmitted: (_) => _submitPost(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _submitPost,
            color: kPrimaryRed,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../models/news.dart';
import '../screens/news_detail_screen.dart';

class NewsCard extends StatelessWidget {
  final News news;
  final VoidCallback onUpvote;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isOwner;

  const NewsCard({
    super.key,
    required this.news,
    required this.onUpvote,
    this.onEdit,
    this.onDelete,
    this.isOwner = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailScreen(newsId: news.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: news.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(news.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: news.imageUrl == null ? Colors.grey[300] : null,
                ),
                child: news.imageUrl == null
                    ? const Icon(Icons.image, size: 32)
                    : null,
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      news.content,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'By ${news.authorUsername}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text('${news.views} views'),
                        const Spacer(),
                        if (isOwner && onEdit != null)
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: onEdit,
                          ),
                        if (isOwner && onDelete != null)
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                            onPressed: onDelete,
                          ),
                        IconButton(
                          icon: Icon(
                            news.isUpvoted ? Icons.thumb_up : Icons.thumb_up_outlined,
                            size: 20,
                          ),
                          onPressed: onUpvote,
                        ),
                        Text('${news.totalUpvotes}'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
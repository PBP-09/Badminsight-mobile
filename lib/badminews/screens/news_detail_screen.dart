import 'package:flutter/material.dart';
import '../models/news.dart';
import '../services/news_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'create_edit_news_screen.dart';

class NewsDetailScreen extends StatefulWidget {
  final int newsId;

  const NewsDetailScreen({super.key, required this.newsId});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final NewsService _newsService = NewsService();
  late Future<News> _newsFuture;

  @override
  void initState() {
    super.initState();
    // Data will be loaded in didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadNewsDetail(context);
  }

  void _loadNewsDetail(BuildContext context) {
    final request = context.read<CookieRequest>();
    _newsFuture = _newsService.getNewsDetail(request, widget.newsId);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();
    final currentUsername = request.jsonData['username'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('News Detail'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          FutureBuilder<News>(
            future: _newsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final news = snapshot.data!;
                final isOwner = currentUsername == news.authorUsername;

                if (isOwner) {
                  return Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          if (!request.loggedIn) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please login to edit news')),
                              );
                            }
                            return;
                          }

                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateEditNewsScreen(news: news),
                            ),
                          );
                          if (result == true && mounted) {
                            // Refresh the news detail
                            setState(() {
                              _loadNewsDetail(context);
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          if (!request.loggedIn) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please login to delete news')),
                              );
                            }
                            return;
                          }

                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete News'),
                              content: const Text('Are you sure you want to delete this news?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            try {
                              final newsService = NewsService();
                              await newsService.deleteNews(request, news.id);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('News deleted successfully')),
                                );
                                Navigator.pop(context, true); // Return to list and refresh
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Failed to delete news')),
                                );
                              }
                            }
                          }
                        },
                      ),
                    ],
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: FutureBuilder<News>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Error loading news detail'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _loadNewsDetail(context);
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final news = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: news.imageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(news.imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: news.imageUrl == null ? Colors.grey[300] : null,
                  ),
                  child: news.imageUrl == null
                      ? const Icon(Icons.image, size: 64, color: Colors.grey)
                      : null,
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        news.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                      ),
                      const SizedBox(height: 8),

                      // Meta information
                      Row(
                        children: [
                          Text(
                            'By ${news.authorUsername}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            news.datePublished.toLocal().toString().split(' ')[0],
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Category badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          news.category[0].toUpperCase() + news.category.substring(1),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Content
                      Text(
                        news.content,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: 1.6,
                            ),
                      ),
                      const SizedBox(height: 24),

                      // Stats and actions
                      Row(
                        children: [
                          // Views
                          Row(
                            children: [
                              const Icon(Icons.visibility, size: 20, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '${news.views} views',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(width: 24),

                          // Upvotes
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  news.isUpvoted ? Icons.thumb_up : Icons.thumb_up_outlined,
                                  color: news.isUpvoted ? Colors.red : Colors.grey,
                                ),
                                onPressed: () async {
                                  final request = context.read<CookieRequest>();
                                  if (!request.loggedIn) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Please login to upvote')),
                                      );
                                    }
                                    return;
                                  }

                                  final newsService = NewsService();
                                  try {
                                    await newsService.upvoteNews(request, news.id);
                                    // Reload data after upvote
                                    setState(() {
                                      _loadNewsDetail(context);
                                    });
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Failed to upvote')),
                                      );
                                    }
                                  }
                                },
                              ),
                              Text(
                                '${news.totalUpvotes}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Read status
                      if (news.isRead)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.green),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle, color: Colors.green, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Read',
                                style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
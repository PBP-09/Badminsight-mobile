import 'package:flutter/material.dart';
import '../models/news.dart';
import '../services/news_service.dart';
import '../widgets/news_card.dart';
import '../widgets/trending_news_section.dart';
import '../widgets/news_filters.dart';
import 'package:badminsights_mobile/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'create_edit_news_screen.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final NewsService _newsService = NewsService();
  late Future<List<News>> _newsFuture;
  late Future<List<News>> _trendingFuture;

  String? _selectedCategory;
  String? _searchQuery;
  String _sortBy = 'date';

  @override
  void initState() {
    super.initState();
    // Data will be loaded in didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData(context);
  }

  void _loadData(BuildContext context) {
    final request = context.read<CookieRequest>();
    _newsFuture = _newsService.getNews(request,
      category: _selectedCategory,
      search: _searchQuery,
      sort: _sortBy,
    );
    _trendingFuture = _newsService.getTrendingNews(request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BadmiNews'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final request = context.read<CookieRequest>();
              if (!request.loggedIn) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please login to create news')),
                  );
                }
                return;
              }

              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateEditNewsScreen()),
              );
              if (result == true && mounted) {
                // Refresh the list if news was created
                setState(() {
                  _loadData(context);
                });
              }
            },
          ),
        ],
      ),
      drawer: const LeftDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _loadData(context);
          });
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trending Section
              FutureBuilder<List<News>>(
                future: _trendingFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return TrendingNewsSection(news: snapshot.data!);
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Filters
              NewsFilters(
                onCategoryChanged: (category) {
                  setState(() {
                    _selectedCategory = category;
                    _loadData(context);
                  });
                },
                onSearchChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                    _loadData(context);
                  });
                },
                onSortChanged: (sort) {
                  setState(() {
                    _sortBy = sort;
                    _loadData(context);
                  });
                },
              ),

              // News List
              FutureBuilder<List<News>>(
                future: _newsFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Error loading news'),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _loadData(context);
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

                  if (news.isEmpty) {
                    return const Center(
                      child: Text('No news available'),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: news.length,
                    itemBuilder: (context, index) {
                      final currentNews = news[index];
                      final request = context.read<CookieRequest>();
                      final currentUsername = request.jsonData['username'];

                      return NewsCard(
                        news: currentNews,
                        isOwner: currentUsername == currentNews.authorUsername,
                        onUpvote: () async {
                          if (!request.loggedIn) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please login to upvote')),
                              );
                            }
                            return;
                          }

                          try {
                            await _newsService.upvoteNews(request, currentNews.id);
                            // Reload data after upvote
                            setState(() {
                              _loadData(context);
                            });
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Failed to upvote')),
                              );
                            }
                          }
                        },
                        onEdit: () async {
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
                              builder: (context) => CreateEditNewsScreen(news: currentNews),
                            ),
                          );
                          if (result == true && mounted) {
                            // Refresh the list if news was updated
                            setState(() {
                              _loadData(context);
                            });
                          }
                        },
                        onDelete: () async {
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
                              await _newsService.deleteNews(request, currentNews.id);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('News deleted successfully')),
                                );
                                // Refresh the list
                                setState(() {
                                  _loadData(context);
                                });
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
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class BookmarkButton extends StatefulWidget {
  final bool isBookmarked;
  final VoidCallback onPressed;

  const BookmarkButton({
    super.key,
    required this.isBookmarked,
    required this.onPressed,
  });

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  late bool bookmarked;

  @override
  void initState() {
    super.initState();
    bookmarked = widget.isBookmarked;
  }

  void toggle() {
    setState(() {
      bookmarked = !bookmarked;
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: toggle,
      icon: Icon(
        bookmarked ? Icons.star : Icons.star_border,
        color: Colors.white,
      ),
      label: Text(
        bookmarked ? "Favorit" : "Tambah Favorit",
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            bookmarked ? Colors.orange : const Color(0xFF2563EB), // accent
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2,
      ),
    );
  }
}

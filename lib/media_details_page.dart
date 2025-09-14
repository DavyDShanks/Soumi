import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MediaDetailsPage extends StatelessWidget {
  final dynamic item;
  final String Function(dynamic) getTitle;
  final String Function(dynamic) getImageUrl;
  final String Function(dynamic) getBannerUrl;

  const MediaDetailsPage({
    super.key,
    required this.item,
    required this.getTitle,
    required this.getImageUrl,
    required this.getBannerUrl,

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          getTitle(item),
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 500,
              width: double.infinity,
              child: Image.network(
                getBannerUrl(item),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    child: Center(
                      child: Text(
                        "No Banner Available",
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
                height: 300,
                width: 200,
              child: Image.network(getImageUrl(item))),
            const SizedBox(height: 16),
            Text(
              getTitle(item),
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Placeholder for extra info
            Text(
              "More details coming soon...",
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

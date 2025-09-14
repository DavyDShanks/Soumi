import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soumi/media_details_page.dart';

class MediaGrid extends StatelessWidget {
  final List<dynamic> items;
  final ScrollController controller;
  final bool isLoading;
  final String Function(dynamic) getTitle;
  final String Function(dynamic) getImageUrl;
  final String Function(dynamic) getBannerUrl;
  final VoidCallback? onEndReached;

  const MediaGrid({
    super.key,
    required this.items,
    required this.controller,
    required this.isLoading,
    required this.getTitle,
    required this.getImageUrl,
    required this.getBannerUrl,
    this.onEndReached, 
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller,
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.65,
      ),
      itemCount: items.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == items.length) {
          // Loader at bottom
          return const Center(
            child: CircularProgressIndicator(color: Colors.red),
          );
        }

        final item = items[index];
        final title = getTitle(item);
        final imageUrl = getImageUrl(item);
        final bannerUrl = getBannerUrl(item);

        return GestureDetector(
          onTap: () {
           Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MediaDetailsPage(
                  item: item,
                  getTitle: getTitle,
                  getImageUrl: getImageUrl,
                  getBannerUrl: getBannerUrl,
                ),
              ),
            );
          },

          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(imageUrl, fit: BoxFit.cover),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.exo2(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

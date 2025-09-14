import 'package:flutter/material.dart';
import 'package:soumi/nav_bar.dart';

void main() {
  runApp(const Soumi());
}

class Soumi extends StatelessWidget {
  const Soumi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
      ),
      home: NavBar(),
    );
  }
}

// --- APP STRUCTURE ---
// Bottom navigation with 5 tabs:
//
// [ Anilist ] [ Simkl ] [ Home ] [ Search ] [ Profile ]
//
// 1. Anilist page (far left):
//    - Shows Anime & Manga (using Anilist GraphQL API)
//    - Recommendations come from Anilist
//    - Any anime/manga watched here must be tracked with Anilist
//    - Layout similar to Dantotsu app
//
// 2. Simkl page (second left):
//    - Shows Movies & TV Shows (using Simkl REST API)
//    - Recommendations come from Simkl
//    - Any movie/show watched here must be tracked with Simkl account
//
// 3. Home page (center):
//    - Recently watched section split by source:
//        * Anilist → Anime & Manga
//        * Simkl → Movies & TV shows
//        * Extensions → Other content
//    - Quick access to continue watching/reading
//    - Home is always the center tab and the default when app opens
//
// 4. Search page (second right):
//    - Universal search across all extensions
//    - By default, favorite extensions are searched first
//    - Others can be added manually
//    - Uses a priority queue (favorite extensions > others > unlikely to break)
//    - Includes search history and recent searches
//    - If a searched item exists in Anilist (anime/manga) or Simkl (movie/show),
//      redirect the user to the appropriate Anilist/Simkl page for tracking
//
// 5. Profile page (far right):
//    - Profile management (Anilist, Simkl, custom profiles)
//    - App settings and preferences
//
// --- SPECIAL RULES ---
// - The center tab is always Home
// - When switching back to Anilist or Simkl, the last selected state/extension
//   should reopen (like Cloudstream behavior)
// - Universal search results and home "recently watched" must check if the
//   item exists in Anilist or Simkl. If found, redirect to the respective hub
//   (Anilist or Simkl) for tracking
//
// --- APIs USED ---
// 1. Anilist API (GraphQL) → Anime & Manga tracking
// 2. Simkl API (REST) → Movies & TV shows tracking
// 3. Jikan API (REST) → Optional MyAnimeList search
// 4. Extension APIs (custom) → Extra sources (for universal search and playback)
//
// --- GOAL ---
// Create a Flutter app that combines Dantotsu-style tracking for anime/manga,
// Cloudstream-style extension handling, and Simkl tracking for movies/shows
// into one unified experience with Home as the central hub.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:soumi/media_grid.dart';

class AnilistPage extends StatefulWidget {
  const AnilistPage({super.key});

  @override
  State<AnilistPage> createState() => _AnilistPageState();
}

class _AnilistPageState extends State<AnilistPage> {
  final List<dynamic> _animeList = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchAnime();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMore) {
        _fetchAnime();
      }
    });
  }

  Future<void> _fetchAnime() async {
    setState(() => _isLoading = true);

    const query = r'''
      query($page: Int, $perPage: Int) {
        Page(page: $page, perPage: $perPage) {
          media(type: ANIME, sort: POPULARITY_DESC) {
            id
            title {
              romaji
              english
            }
            coverImage {
              large
            }
          }
        }
      }
    ''';

    final response = await http.post(
      Uri.parse("${dotenv.env['ANILIST_API_BASE_URL']}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "query": query,
        "variables": {"page": _currentPage, "perPage": 24},
      }),
    );


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newAnime = data["data"]["Page"]["media"];
      

      setState(() {
        _currentPage++;
        if (newAnime.isEmpty) {
          _hasMore = false;
        } else {
          _animeList.addAll(newAnime);
        }
      });
    } else {
      debugPrint("Error: ${response.statusCode}");
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Image.asset("assets/anilist_logo.png", color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 5,
        title: Center(

          child: Text("Anime", style: GoogleFonts.exo2(color: Colors.white)),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              backgroundImage: AssetImage("assets/profile.png"),
              radius: 15,
            ),
          ),
        ],
      ),
      body: MediaGrid(
        items: _animeList,
        controller: _scrollController,
        isLoading: _isLoading,
        getTitle: (anime) => anime["title"]["english"] ?? anime["title"]["romaji"] ?? "Unknown",
        getImageUrl: (anime) => anime["coverImage"]["large"],
        getBannerUrl: (anime) => anime["bannerImage"] ?? "", // Placeholder, implement if needed        
      ),

      // body: GridView.builder(
      //   controller: _scrollController,
      //   padding: const EdgeInsets.all(8),
      //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: 6,
      //     crossAxisSpacing: 8,
      //     mainAxisSpacing: 8,
      //     childAspectRatio: 0.65,
      //   ),
      //   itemCount: _animeList.length + (_isLoading ? 1 : 0),
      //   itemBuilder: (context, index) {
      //     if (index == _animeList.length) {
      //       return const Center(
      //         child: CircularProgressIndicator(color: Colors.red),
      //       );
      //     }

      //     final anime = _animeList[index];
      //     final title = anime["title"]["english"] ?? anime["title"]["romaji"];
      //     final imageUrl = anime["coverImage"]["large"];

      //     return GestureDetector(
      //       onTap: () {},
      //       child: ClipRRect(
      //         borderRadius: BorderRadius.circular(10),
      //         child: Stack(
      //           fit: StackFit.expand,
      //           children: [
      //             Image.network(imageUrl, fit: BoxFit.cover),
      //             Align(
      //               alignment: Alignment.bottomCenter,
      //               child: Container(
      //                 color: Colors.black.withOpacity(0.6),
      //                 padding: const EdgeInsets.all(4),
      //                 child: Text(
      //                   title ?? "Unknown",
      //                   maxLines: 1,
      //                   overflow: TextOverflow.ellipsis,
      //                   style: GoogleFonts.exo2(
      //                     color: Colors.white,
      //                     fontSize: 12,
      //                   ),
      //                   textAlign: TextAlign.center,
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),

    );
  }
}
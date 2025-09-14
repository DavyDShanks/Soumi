import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:soumi/media_grid.dart';

class SimklPage extends StatefulWidget {
  const SimklPage({super.key});

  @override
  State<SimklPage> createState() => _SimklPageState();
}

class _SimklPageState extends State<SimklPage> {

  List<dynamic> trending = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;


  @override
  void initState() {
    super.initState();
    fetchTrending();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading &&
          _hasMore) {
        fetchTrending();
      }
    });
  }

  Future<void> fetchTrending() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse(
        "${dotenv.env['TMDB_API_BASE_URL']}/trending/movie/day?page=$_currentPage",
      ),
      headers: {
        "Authorization":
            "Bearer ${dotenv.env['TMDB_API_HEADER_KEY']}",

      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data["results"] as List;

      setState(() {
        trending.addAll(results);
        _currentPage++;
        _hasMore = results.isNotEmpty;
      });
    } else {
      throw Exception("Failed to load trending");
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Image.asset("assets/simkl_logo.png", color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 5,
        title: Center(
          child: Text("Movies", style: GoogleFonts.exo2(color: Colors.white)),
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
        items: trending,
        controller: _scrollController,
        isLoading: _isLoading,
        getTitle: (movie) => movie["title"] ?? movie["name"] ?? "Unknown",
        getImageUrl: (movie) {
          final posterPath = movie["poster_path"];
          return posterPath != null
            ? "${dotenv.env['TMDB_IMAGE_BASE_URL']}/w500$posterPath"
            : "https://via.placeholder.com/200x300?text=No+Image";
        },
        getBannerUrl: (movie) {
          final backdropPath = movie["backdrop_path"];
          return backdropPath != null
            ? "${dotenv.env['TMDB_IMAGE_BASE_URL']}/original$backdropPath"
            : "https://via.placeholder.com/500x281?text=No+Image";
        },
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
      //   itemCount: trending.length + (_isLoading ? 1 : 0),
      //   itemBuilder: (context, index) {
      //     if (index == trending.length) {
      //       return const Center(
      //         child: CircularProgressIndicator(color: Colors.red),
      //       );
      //     }

      //     final movie = trending[index];
      //     final posterPath = movie["poster_path"];
      //     final title = movie["title"] ?? movie["name"];
      //     final imageUrl = posterPath != null
      //         ? "${dotenv.env['TMDB_IMAGE_BASE_URL']}/w500$posterPath"
      //         : "https://via.placeholder.com/200x300?text=No+Image";

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

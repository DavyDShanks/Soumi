import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:soumi/profile_page.dart'; // Future import (profile page not yet used)
import 'package:soumi/search_page.dart';

/// The HomePage widget is the main landing screen of the app.
/// It uses a StatefulWidget because we may want to update UI later.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State class for HomePage
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set overall background
      appBar: AppBar(
        backgroundColor: Colors.black, // Black app bar
        title: 
          /// Left icon button (extension icon)
          IconButton(
            icon: const Icon(Icons.extension, color: Colors.white),
            onPressed: () {
              // TODO: Add functionality for extension icon
            },
          ),
        actions: [
          /// Search button -> navigates to SearchPage
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),

          /// Profile button -> not implemented yet
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // TODO: Navigate to ProfilePage
            },
          ),
        ],

        /// Bottom bar under AppBar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0), // Height of bottom section
          child: Container(
            color: Colors.black,
            height: 30.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 5), // Left padding
                Text(
                  "Continue Reading",
                  style: GoogleFonts.exo2(color: Colors.white, fontSize: 20),
                ),
                const Spacer(), // Pushes arrow to the right
                IconButton(
                  alignment: Alignment.topRight,
                  onPressed: () {
                    // TODO: Add "Continue Reading" navigation
                  },
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),

      /// Main body of the page
      body: const Center(
        child: Text(
          'Welcome to Soumi App!',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}

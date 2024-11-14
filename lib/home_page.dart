// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:nba_api/model/team.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Team> teams = [];
  late Future<void> _teamFuture;

  @override
  void initState() {
    super.initState();
    _teamFuture = getTeams();
  }

  Future<void> getTeams() async {
    await Future.delayed(const Duration(seconds: 2));

    final url = Uri.parse('https://api.balldontlie.io/nfl/v1/teams/');
    final response = await http.get(
      url,
      headers: {
        'Authorization': '32feeb6b-61e7-48c7-b4be-29de1b82895f',
      },
    );
    final jsonData = jsonDecode(response.body);
    for (var eachTeam in jsonData['data']) {
      final team = Team(
        abbreviation: eachTeam['abbreviation'],
        location: eachTeam['location'],
        division: eachTeam['division'],
        id: eachTeam['id'],
      );

      teams.add(team);
    }
    // Sort teams by id
    teams.sort((a, b) => a.id.compareTo(b.id));
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 8, 8, 8),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('NBA teams'),
      ),
      body: Stack(
        children: [
          // Background animation using Lottie
          Positioned.fill(
            child: Lottie.asset(
              'lib/animations/background.json', // Path to your Lottie animation file
              fit: BoxFit.contain,
              repeat: true,
            ),
          ),

          // Your ListView.builder
          FutureBuilder(
            future: _teamFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemCount: teams.length + 1, // Plus one for the header
                  itemBuilder: (context, index) {
                    // The header tile
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade700,
                          ),
                          child: ListTile(
                            leading: Text(
                              'ID',
                              style: GoogleFonts.dotGothic16(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            title: Text(
                              "Abbreviation",
                              style: GoogleFonts.dotGothic16(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            subtitle: Text(
                              "Location",
                              style: GoogleFonts.eduNswActFoundation(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Text(
                              "Division",
                              style: GoogleFonts.eduNswActFoundation(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      index - 2;
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade400,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: Text(
                              '${teams[index].id}',
                              style: GoogleFonts.dotGothic16(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            title: Text(
                              teams[index].abbreviation,
                              style: GoogleFonts.dotGothic16(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            subtitle: Text(
                              teams[index].location,
                              style: GoogleFonts.eduNswActFoundation(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: Text(
                              teams[index].division,
                              style: GoogleFonts.eduNswActFoundation(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                );
              } else {
                return Center(
                  child: Lottie.asset(
                    'lib/animations/basketball.json',
                    width: 200,
                    height: 200,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

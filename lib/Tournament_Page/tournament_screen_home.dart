import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:wow_codes/Tournament_Page/tournament_card.dart';
import 'package:wow_codes/Config/Config.dart';

class TournamentHomeScreen extends StatefulWidget {
  const TournamentHomeScreen({super.key});

  @override
  _TournamentHomeScreenState createState() => _TournamentHomeScreenState();
}

class _TournamentHomeScreenState extends State<TournamentHomeScreen> {
  int _currentTabIndex = 0;
  List<Map<String, dynamic>> tournaments = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchTournamentData();
  }

  String formatValue(String value) {
    double val = double.tryParse(value) ?? 0.0;
    return val % 1 == 0 ? val.toInt().toString() : value;
  }

  

  Future<void> fetchTournamentData() async {
    final url = Uri.parse(tournamentApiLink);
    final body = {'type': 'get'};

    try {
      final response = await http.post(url, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          tournaments = List<Map<String, dynamic>>.from(data[0]['tournaments']);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load tournament data');
      }
    } catch (e) {
      print('Error fetching tournament data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 40.h),
                  _buildTabs(),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text('Recommended Tournaments',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.sp)),
                  ),
                  _buildRecommendedTournaments2(),
                ],
              ),
            ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Card(
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.tune_rounded),
              ),
            ),
            _buildTabItem('All', 0),
            const SizedBox(width: 8),
            _buildTabItem('QUICK', 1),
            const SizedBox(width: 8),
            _buildTabItem('2 Players • 1 Winner', 2),
            const SizedBox(width: 8),
            _buildTabItem('3 Players', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String label, int index) {
    bool isActive = _currentTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTabIndex = index;
        });
      },
      child: Card(
        elevation: isActive ? 4.0 : 2.0,
        color: isActive ? Colors.yellow[600] : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.black : Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendedTournaments2() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tournaments.length,
            itemBuilder: (context, index) {
              final tournament = tournaments[index];
              final prizePool = formatValue(tournament['prize_pool']);
              final maxPlayers = tournament['max_players'];
              final entryFee = formatValue(tournament['entry_fee']);
              final rankList =
                  List<Map<String, dynamic>>.from(tournament['rank']);
              final numberOfWinners = rankList.length;

              return TournamentCard(
                winners: numberOfWinners,
                prizePool: prizePool,
                maxPlayers: maxPlayers,
                entryFee: entryFee,
                rankList: rankList,
              );
            },
          ),
        ],
      ),
    );
  }
}

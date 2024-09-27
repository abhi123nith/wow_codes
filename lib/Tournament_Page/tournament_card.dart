import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DottedLine extends StatelessWidget {
  final double height;
  final double width;
  final Color color;

  const DottedLine({
    super.key,
    this.height = 1,
    this.width = 2,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (2 * width)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: width,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}

class TournamentCard extends StatefulWidget {
  final String prizePool;
  final String maxPlayers;
  final String entryFee;
  final List<Map<String, dynamic>> rankList;
  final int winners;

  const TournamentCard({
    super.key,
    required this.prizePool,
    required this.maxPlayers,
    required this.entryFee,
    required this.rankList,
    required this.winners,
  });

  @override
  _TournamentCardState createState() => _TournamentCardState();
}

class _TournamentCardState extends State<TournamentCard> {
  bool _detailsVisible = false;

  void _toggleDetails() {
    setState(() {
      _detailsVisible = !_detailsVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 2.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
          
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.r),
                    topRight: Radius.circular(25.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Icon(Icons.people_outline,
                                size: 20.sp, color: Colors.grey[600]),
                            SizedBox(width: 5.w),
                            Text(
                              widget.maxPlayers,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Center(
                        child: Text(
                          '${widget.maxPlayers} PLAYERS • ${widget.winners} WINNER',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _toggleDetails,
                      child: Container(
                        width: 100.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('PRIZE',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54)),
                            SizedBox(height: 0.5.h),
                            Text(
                              '\$${widget.prizePool}',
                              style: TextStyle(
                                  fontSize: 18.sp, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _toggleDetails,
                      child: Container(
                        width: 100.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('TIMER',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54)),
                            SizedBox(height: 0.5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.timer_outlined,
                                    size: 18.sp, color: Colors.red),
                                SizedBox(width: 5.w),
                                Text(
                                  '00M:22S',
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _toggleDetails,
                      child: Container(
                        width: 100.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade400,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('ENTRY',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54)),
                            SizedBox(height: 0.1.h),
                            Text(
                              '\$${widget.entryFee}',
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              if (_detailsVisible) ...[
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ...widget.rankList.map((rankData) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Rank ${rankData['rank']} : ',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${rankData['prize']}',
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }),
                      SizedBox(height: 10.h),
                      DottedLine(height: 1.h, width: 2.w, color: Colors.grey),
                      SizedBox(height: 10.h),
                      Text(
                        'The Payment is split in case of a tie.\nMaintain a good internet connection.\nAn unstable connection can lead to disqualification.',
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.5)),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.h),
                      DottedLine(height: 1.h, width: 2.w, color: Colors.grey),
                      SizedBox(height: 10.h),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.speed),
                          Text(
                            'QUICK',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'QUICK format has 10 seconds per move and a total game time of 5 minutes.',
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.5)),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

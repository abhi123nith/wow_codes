import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:wow_codes/Config/Config.dart';
import 'dart:convert';
import 'package:wow_codes/Helper/Helper.dart';

class ReferralPage extends StatefulWidget {
  @override
  _ReferralPageState createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  String? referralCode;

  List<Map<String, dynamic>> faqList = [];
  String youEarns = "0";
  String friendEarns = "0";

  @override
  void initState() {
    super.initState();
    fetchReferralCode();
    fetchFAQData();
  }

  Future<void> fetchReferralCode() async {
    Helper helper = Helper();
    Map? userData = await helper.getUserData();
    setState(() {
      if (userData != null && userData.containsKey('referral_code')) {
        referralCode = userData['referral_code'].toString();
      } else {
        referralCode = null;
      }
    });
  }

  Future<void> fetchFAQData() async {
    try {
      final response = await http.get(Uri.parse(referralUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['JSON_DATA'] != null && jsonData['JSON_DATA'] is List) {
          List<dynamic> jsonDataList = jsonData['JSON_DATA'];
          if (jsonDataList.isNotEmpty) {
            List<dynamic> faqs = jsonDataList[0]['faq'];
            setState(() {
              faqList = faqs.map((item) {
                return {
                  "question": item['question'],
                  "answer": item['answer'],
                };
              }).toList().cast<Map<String, dynamic>>();

              youEarns = jsonDataList[0]['bonus'][0]['you_earns'] ?? "0";
              friendEarns = jsonDataList[0]['bonus'][0]['friend_earns'] ?? "0";
            });
          }
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Failed to load FAQ data"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double textScaleFactor = MediaQuery.of(context).textScaleFactor; // For handling text scaling
    bool isPortrait = size.height > size.width;

    return Scaffold(
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(isPortrait ? size.width * 0.15 : size.width * 0.1),
                  bottomLeft: Radius.circular(isPortrait ? size.width * 0.15 : size.width * 0.1),
                ),
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.02,
                      vertical: size.height * 0.01,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: isPortrait ? size.width * 0.1 : size.height * 0.09),
                        Text(
                          "Refer your friends",
                          style: TextStyle(
                            fontSize: 26 / textScaleFactor,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "and Earn",
                          style: TextStyle(
                            fontSize: 26 / textScaleFactor,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: size.height * 0.005),
                        Icon(Icons.card_giftcard, size: isPortrait  ?size.height * 0.17  :size.width * 0.19, color: Colors.yellowAccent),
                        SizedBox(height: size.height * 0.0004),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const FaIcon(FontAwesomeIcons.coins, color: Colors.yellow),
                            SizedBox(width: size.width * 0.0099),
                            Text(
                              "$youEarns",
                              style: TextStyle(
                                fontSize: 28 / textScaleFactor,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Loyalty Points",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20 / textScaleFactor,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Text(
                          "Your friend gets $friendEarns Points on signup",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16 / textScaleFactor,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "and, you get $youEarns Points too every time",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16 / textScaleFactor,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: size.height * 0.02),
                        DottedBorder(
                          borderType: BorderType.RRect,
                          radius: Radius.circular(size.width * 0.02),
                          dashPattern: [6, 3],
                          color: Colors.white,
                          strokeWidth: 2,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.02,
                              vertical: size.height * 0.01,
                            ),
                            width: size.width * 0.6,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Your referral code',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 13 / textScaleFactor,
                                        ),
                                      ),

                                      Text(
                                        referralCode.toString(),
                                        style: TextStyle(
                                          fontSize: 26 / textScaleFactor,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: isPortrait ? size.height * 0.04 : size.width * 0.045 ,
                                  width:isPortrait ? size.width * 0.005 :size.width*0.004,
                                  color: Colors.white,
                                  margin: EdgeInsets.symmetric(horizontal:isPortrait ? size.width * 0.006 : size.height*0.001),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: "$referralCode"));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(right:isPortrait ? size.width * 0.04 : size.height*0.09),
                                    child: Column(
                                      children: [
                                        Text("Copy", style: TextStyle(fontWeight: FontWeight.bold,  fontSize: 14 / textScaleFactor, color: Colors.yellowAccent)),
                                        Text("Code", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 / textScaleFactor, color: Colors.yellowAccent)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Text(
                          "Share your Referral Code via",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18 / textScaleFactor,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        _buildShareButtons(),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ,
            SizedBox(height: size.height * 0.01),
            _buildFAQSection(),
          ],
        ),
      ),
    );
  }


  Widget _buildShareButtons() {
    Size size = MediaQuery.of(context).size;
    bool isPortrait =size.height > size.width;
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: isPortrait  ? size.width*.1 : size.height*0.07,vertical: isPortrait  ? size.width*.01 : size.height*0.01 ),
      child: _buildExpandedShareButton("Share", Colors.blue, FontAwesomeIcons.shareNodes),
    );
  }

  Widget _buildExpandedShareButton(String platform, Color color, IconData icon) {
    Size size = MediaQuery.of(context).size;
   bool  ispot = size.width > size.height;
    return
       GestureDetector(
        onTap: () {
          Share.share(
            "Use my referral code: $referralCode to earn rewards! $appDownloadLink",
          );
        },
        child: Container(
          padding:  EdgeInsets.symmetric(horizontal:  ispot ?  size.height*0.02 : size.height*0.06,vertical: ispot ?  size.height*0.02 : size.width*0.02),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(size.width*.03),
          ),
          // child:Container(
          //   padding:  EdgeInsets.symmetric( vertical: ispot ? size.height*0.01 : size.width*0.01),
        child:   Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: ispot ? size.height*0.1 : size.width*0.07 ),
               SizedBox(width: size.width*0.018),
              Text(
                platform,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
       )
       // ),

    );
  }

  Widget _buildFAQSection() {
  Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            "FAQs",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
          ),
           SizedBox(height:size.height*.002),
          ...faqList.map((faq) {
            return ExpansionTile(
              title: Text(
                faq["question"],
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(faq["answer"]),
                ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }
}

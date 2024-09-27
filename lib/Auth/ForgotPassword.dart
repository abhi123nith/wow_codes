import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:wow_codes/Auth/NewPassword.dart';
import 'package:wow_codes/Config/Config.dart';
import 'package:wow_codes/Usefull/Functions.dart';

import '../Usefull/Colors.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({super.key});

  @override
  State<forgotPassword> createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  bool isHide = false;

  bool loginPhone = false;

  String countryCode = "";
  String phone = "";
  PhoneNumber number = PhoneNumber(dialCode: "+91", isoCode: "IN");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: (MediaQuery.of(context).size.width < 900)
                  ? const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0)
                  : const EdgeInsets.symmetric(horizontal: 300.0, vertical: 25.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mainTextLeft("Forgot \nPassword?", Colors.white, 30.0,
                        FontWeight.bold, 2, "mons"),
                    const SizedBox(
                      height: 40.0,
                    ),
                    (!loginPhone)
                        ? TextFormField(
                            maxLength: 64,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Colors.white,
                            style: const TextStyle(
                              fontFamily: 'pop',
                              fontSize: 15.0,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                filled: true,
                                counterText: "",
                                fillColor: bgColorLight,
                                hintText: "    Email",
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: bgColor,
                                ),
                                hintStyle: const TextStyle(
                                    fontFamily: 'pop', color: Colors.grey),
                                labelStyle: const TextStyle(
                                    fontFamily: 'pop', color: Colors.white),
                                errorStyle: const TextStyle(
                                    fontFamily: 'mons',
                                    color: Colors.redAccent),
                                errorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(13.0)),
                                    borderSide:
                                        BorderSide(color: Colors.redAccent)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(13.0)),
                                    borderSide:
                                        BorderSide(color: bgColorLight)),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(13.0)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(13.0)),
                                    borderSide:
                                        BorderSide(color: Colors.transparent))),
                            onChanged: (text) {
                              email = text;
                            },
                            validator: (value) {
                              bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!);
                              if (!emailValid) {
                                return ("Please enter a valid email");
                              } else {
                                return null;
                              }
                            },
                          )
                        : Card(
                            color: bgColorLight,
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: BorderSide(
                                  color: bgColor,
                                  width: 0.0,
                                )),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 5.0),
                              child: InternationalPhoneNumberInput(
                                onInputChanged: (PhoneNumber n) {
                                  print(n.toString());
                                  phone = n.phoneNumber.toString();
                                  countryCode = n.dialCode.toString();
                                },
                                textStyle: const TextStyle(
                                  fontFamily: 'mons',
                                  fontSize: 13.0,
                                  color: Colors.white,
                                ),
                                selectorConfig: const SelectorConfig(
                                    selectorType:
                                        PhoneInputSelectorType.BOTTOM_SHEET),
                                initialValue: number,
                                maxLength: 13,
                                keyboardType: TextInputType.number,
                                cursorColor: Colors.white,
                                selectorTextStyle: const TextStyle(
                                  fontFamily: 'mons',
                                  fontSize: 13.0,
                                  color: Colors.white,
                                ),
                                inputDecoration: InputDecoration(
                                  filled: true,
                                  fillColor: bgColorLight,
                                  hintText: "Mobile Number",
                                  suffixIcon: const Icon(
                                    Iconsax.call,
                                    color: Colors.grey,
                                    size: 20.0,
                                  ),
                                  hintStyle: const TextStyle(
                                      fontFamily: 'mons', color: Colors.grey),
                                  labelStyle: const TextStyle(
                                      fontFamily: 'mons', color: Colors.white),
                                  errorStyle: const TextStyle(
                                      fontFamily: 'mons',
                                      color: Colors.redAccent),
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return ("Please Enter a Number");
                                  } else if (value.length < 10) {
                                    return ("Number should be 10 digits long");
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                loginPhone = !loginPhone;
                              });
                            },
                            child: mainTextLeft(
                                "Login with ${(loginPhone) ? 'Email' : 'Phone'}",
                                Colors.white,
                                13.0,
                                FontWeight.normal,
                                1,
                                "mons")),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Flexible(
                            child: mainTextLeft(
                                "*We will send you a verification code over email to reset your password",
                                Colors.grey,
                                10.0,
                                FontWeight.normal,
                                2,
                                "mons"))
                      ],
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      children: [
                        mainTextLeft("Reset Password", Colors.white, 25.0,
                            FontWeight.bold, 1, "mons"),
                        const Spacer(),
                        FloatingActionButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              SendCode();
                            }
                          },
                          mini: false,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          backgroundColor: Colors.white,
                          child: const Icon(
                            Icons.arrow_forward_sharp,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: mainText("Back", Colors.white, 13.0,
                                FontWeight.bold, 1, 'mons'),
                          ),
                          const Spacer(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          loaderss(isHide, context)
        ],
      ),
    );
  }

  SendCode() async {
    setState(() {
      isHide = true;
    });

    var url = Uri.parse(initiatepasswordReset);

    Map<String, String> body = {};
    if (loginPhone) {
      body['phone'] = removeCountryCode(countryCode, phone);
      // body['country_code'] = countryCode.substring(1,countryCode.length);
      body['country_code'] = countryCode;
    } else {
      body['email'] = email;
    }
    print(body);

    var req = http.MultipartRequest('POST', url);
    req.fields.addAll(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    // print()
    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(resBody);
      Map data = jsonDecode(resBody);
      List ll = data['JSON_DATA'];
      data = ll[0];
      if (data['success'] == "0") {
        toaster(context, data['msg']);
      } else {
        toaster(context, "OTP send successfully");
        Future.delayed((const Duration(seconds: 1)), () {
          navScreen(NewPassword(data: body), context, true);
        });
      }
    } else {
      toaster(context, "Something went wrong");
      print(res.reasonPhrase);
    }
    setState(() {
      isHide = false;
    });
  }
}

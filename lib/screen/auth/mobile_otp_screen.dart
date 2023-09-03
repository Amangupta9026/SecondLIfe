//
// OTP SCREEN
//

import 'dart:async';
import 'dart:developer';

// import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../global/all_images.dart';
import '../../global/color.dart';
import '../../resusable_widget/appbar.dart';
import 'helping_categories.dart';

class OTPScreen extends StatefulWidget {
  final String mobileNumber;
  final String verificationId;
  final int? resendToken;

  const OTPScreen({
    required this.mobileNumber,
    required this.verificationId,
    required this.resendToken,
    Key? key,
  }) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  // String _comingSms = 'Unknown';

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: StopWatchTimer.getMilliSecFromSecond(180),
  );

  // Future<void> initSmsListener() async {
  //   String? comingSms;
  //   try {
  //     comingSms = await AltSmsAutofill().listenForSms;
  //   } catch (e) {
  //     comingSms = 'Failed to get Sms.';
  //   }
  //   if (!mounted) return;
  //   setState(() {
  //     _comingSms = comingSms!;
  //     log("====>Message: $_comingSms");
  //     log(_comingSms[32]);
  //     List<String> otp = _comingSms.split(" ");
  //     otpController.text = otp[0];

  //     // otpController.text = _comingSms[32] +
  //     //     _comingSms[33] +
  //     //     _comingSms[34] +
  //     //     _comingSms[35] +
  //     //     _comingSms[36] +
  //     //     _comingSms[
  //     //         37]; //used to set the code in the message to a string and setting it to a textcontroller. message length is 38. so my code is in string index 32-37.
  //   });
  // }

  verifyOtp() async {
    String otp = otpController.text.trim();

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otp);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        if (mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HelperCategories(
                        mobileNumber: widget.mobileNumber,
                      )));
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid OTP. Please try again."),
        ),
      );
      log("$e");
    }
  }

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    // initSmsListener();
    // sendFirebaseOTP();
  }

  @override
  void dispose() {
    // AltSmsAutofill().unregisterListener();
    _stopWatchTimer.dispose();
    try {
      otpController.dispose();
    } catch (e) {
      // (e);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 4.0, 15.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const CustomBackButton(),
                        const Spacer(),
                        Image.asset(
                          appLogoTransparent,
                          // height: 80,
                          width: MediaQuery.of(context).size.width * 0.35,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0, top: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Enter code sent\nto your phone',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: colorBlack,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                'we send it to the number ${widget.mobileNumber}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: colorGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 50.0, right: 50),
                  child: PinCodeTextField(
                    autoFocus: true,
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      // borderRadius: BorderRadius.circular(10),
                      fieldHeight: 33,
                      fieldWidth: 20,
                      inactiveFillColor: backgroundColor,
                      inactiveColor: colorBlack,
                      selectedColor: colorBlack,
                      selectedFillColor: backgroundColor,
                      activeFillColor: backgroundColor,
                      activeColor: colorBlack,
                    ),
                    cursorColor: colorBlack,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    enablePinAutofill: true,
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    // boxShadows: const [],
                    onCompleted: (v) {
                      //do something or move to next screen when code complete
                    },
                    onChanged: (value) {
                      log(value);
                      if (mounted) {
                        setState(() {
                          log(value);
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StreamBuilder<int>(
                    stream: _stopWatchTimer.rawTime,
                    initialData: _stopWatchTimer.rawTime.value,
                    builder: (context, snap) {
                      final value = snap.data!;
                      final displayTime = StopWatchTimer.getDisplayTime(value,
                          hours: false, milliSecond: false);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _stopWatchTimer.rawTime.value != 0
                              ? const Text(
                                  "Resend code in",
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(fontSize: 16, color: colorGrey),
                                )
                              : InkWell(
                                  onTap: () {
                                    _stopWatchTimer.setPresetSecondTime(180);
                                    _stopWatchTimer.onExecute
                                        .add(StopWatchExecute.start);
                                    sendFirebaseOTP();
                                  },
                                  child: const Text(
                                    "RESEND CODE",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: colorBlack,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                          _stopWatchTimer.rawTime.value != 0
                              ? Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    displayTime,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: colorGrey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      onPressed: () {
                        verifyOtp(); // uncoment this

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => HelperCategories(
                        //               mobileNumber: widget.mobileNumber,
                        //             )));
                      },
                      child: const SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.only(top: 14.0, bottom: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.verified_user,
                                size: 24,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Verify Code",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    launchUrl(Uri.parse(
                        "https://support2heal.com/manage/privacy_policy"));
                  },
                  child: RichText(
                    textScaleFactor: 1,
                    text: const TextSpan(
                      text: 'By clicking, I accept the ',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorBlack,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'T&C',
                          style: TextStyle(
                              fontSize: 12,
                              color: colorBlue,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' and ',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorBlack,
                          ),
                        ),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                              fontSize: 12,
                              color: colorBlue,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  sendFirebaseOTP() async {
    try {
      EasyLoading.show(status: 'loading...');
      await FirebaseAuth.instance.signOut();
      await Future.delayed(const Duration(seconds: 1));
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.mobileNumber,
        timeout: const Duration(seconds: 120),
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) async {},
        forceResendingToken: widget.resendToken,
        codeSent: (String verificationId, int? resendToken) async {
          // Update the UI - wait for the user to enter the SMS code
          EasyLoading.dismiss();

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OTPScreen(
                        mobileNumber: widget.mobileNumber,
                        verificationId: verificationId,
                        resendToken: widget.resendToken,
                      )));

          // String smsCode = '227149';

          // // Create a PhoneAuthCredential with the code
          // PhoneAuthCredential credential = PhoneAuthProvider.credential(
          //     verificationId: verificationId, smsCode: smsCode);

          // // Sign the user in (or link) with the credential
          // await FirebaseAuth.instance.signInWithCredential(credential);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          EasyLoading.dismiss();
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
      log("$e");
    }
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:second_life/sharedpreference/sharedpreference.dart';
import 'package:second_life/widget/toast_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_constant.dart';
import '../../api/api_services.dart';
import '../../global/color.dart';

import '../../model/register_model.dart';
import '../../provider/login_screen_notifier.dart';
import '../home/home_screen.dart';
import '../listner_app_ui/listner_homescreen.dart';

// bool isListener = false;

class HelperCategories extends StatefulWidget {
  final String? mobileNumber;

  const HelperCategories({Key? key, this.mobileNumber}) : super(key: key);

  @override
  State<HelperCategories> createState() => _HelperCategoriesState();
}

class _HelperCategoriesState extends State<HelperCategories> {
  FirebaseMessaging? firebaseMessaging;
  String usedReferCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text(
            'Referral Code',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorWhite,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 100),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 10.0, 6, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Referral Code (Optional)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorBlack,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Material(
                          surfaceTintColor: Colors.white,
                          shadowColor: primaryColor,
                          elevation: 1,
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller:
                                  Provider.of<LoginScreenNotifier>(context)
                                      .referController,
                              autofocus: true,
                              style: const TextStyle(
                                fontSize: 15,
                                color: colorBlack,
                              ),
                              focusNode:
                                  Provider.of<LoginScreenNotifier>(context)
                                      .referCodeFocusNode,
                              decoration: const InputDecoration(
                                hintText: 'Enter Referral Code',
                                fillColor: Colors.white,
                                focusColor: Colors.white,
                                hoverColor: Colors.white,
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                usedReferCode = value;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: InkWell(
                      onTap: () async {
                        EasyLoading.show(status: 'loading...');
                        String? token =
                            await FirebaseMessaging.instance.getToken();

                        RegistrationModel registerModel =
                            await APIServices.registerAPI(
                                widget.mobileNumber.toString(),
                                token.toString(),
                                usedReferCode);

                        log(widget.mobileNumber.toString());
                        log(token.toString());
                        log(usedReferCode);

                        if (registerModel.status == true &&
                            registerModel.data != null) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString(
                              "userId", registerModel.data!.id.toString());
                          prefs.setString(
                              "userName", registerModel.data!.name!);

                          SharedPreference.setValue(PrefConstants.MOBILE_NUMBER,
                              registerModel.data?.mobileNo.toString());
                          SharedPreference.setValue(PrefConstants.MERA_USER_ID,
                              registerModel.data?.id.toString());
                          SharedPreference.setValue(PrefConstants.USER_TYPE,
                              registerModel.data?.userType.toString());

                          SharedPreference.setValue(PrefConstants.LISTENER_NAME,
                              registerModel.data?.name.toString());

                          SharedPreference.setValue(
                              PrefConstants.LISTENER_IMAGE,
                              registerModel.data?.image.toString());
                          SharedPreference.setValue(
                              PrefConstants.ONLINE,
                              registerModel.data?.onlineStatus == 1
                                  ? true
                                  : false);

                          EasyLoading.dismiss();

                          if (registerModel.data?.userType == 'user') {
                            // if (!isListener) {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool("isListener", false);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          } else {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool("isListener", true);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ListnerHomeScreen(),
                              ),
                            );
                          }
                        } else {
                          EasyLoading.dismiss();
                          toast(registerModel.message.toString());
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 50,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

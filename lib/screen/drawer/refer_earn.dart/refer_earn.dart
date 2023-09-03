import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../global/color.dart';

class ReferEarn extends StatelessWidget {
  const ReferEarn({super.key});

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
            child: SingleChildScrollView(
                child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 35, 15, 40),
          child: Column(children: [
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: primaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 15, 15, 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your code',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const Text('123456',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Row(
                        children: [
                          InkWell(
                              onTap: () {
                                Clipboard.setData(
                                    const ClipboardData(text: '123456'));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Copied to Clipboard')));
                              },
                              child:
                                  const Icon(Icons.copy, color: Colors.white)),
                          const SizedBox(width: 15),
                          InkWell(
                              onTap: () {
                                Share.share(
                                    subject: 'SecondLife',
                                    'hey! check out this amazing app\nhttps://play.google.com/store/apps/details?id=com.flashcoders.bhagavad_gita_ai&hl=en_IN&gl=US');
                              },
                              child:
                                  const Icon(Icons.share, color: Colors.white)),
                        ],
                      )
                    ],
                  ),
                )),
            const SizedBox(height: 30),
            const Text(
              'FAQ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorBlack,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'What is referral code?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorBlack,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'A referral code is a unique combination of letters and numbers that you can use to identify an associate, promotion, or offer. You can get referral codes from above Box. Just copy and share it with your friends and family.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorBlack,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'How to use referral code?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorBlack,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'You can use referral code by sharing it with your friends and family. You can share it via social media, email, text message, or WhatsApp. When someone uses your referral code, you will get a reward.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorBlack,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'How to get referral code?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorBlack,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'You can get referral code from above Box. Just copy and share it with your friends and family.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorBlack,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'How to get reward?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorBlack,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'You can get reward by someone using your referral code. When someone use your referral code, you will get a reward in youe SecondLife wallet account. You can use this reward to call and chat to any Listener.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorBlack,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'How to share referral code?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorBlack,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'You can share referral code via social media, email, or text message or WhatsApp.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorBlack,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'How to get more reward?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorBlack,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'You can get more reward by sharing your referral code with your friends and family. You can also get more reward by using referral code.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorBlack,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'How to get more referral code?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorBlack,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'You can get only 1 unique referral code. You can share it with your friends and family',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorBlack,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'When i will receive my reward?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorBlack,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'You will receive your reward when your referral use your referral code.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorBlack,
              ),
            ),
          ]),
        ))));
  }
}

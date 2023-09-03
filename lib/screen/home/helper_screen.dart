import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:second_life/global/color.dart';
import 'package:second_life/model/listner_display_model.dart';
import 'package:second_life/provider/helperscreen_notifier.dart';
import 'package:second_life/sharedpreference/sharedpreference.dart';

import '../../api/api_constant.dart';
import '../../widget/shimmer_progress_widget.dart';
import '../search/search_screen.dart';
import 'helper_detail_screen.dart';

class HelperScreen extends StatelessWidget {
  final ListnerDisplayModel? listnerDisplayModel;
  final bool isNavigatedFromSearchScreen;
  const HelperScreen(
      {super.key,
      this.listnerDisplayModel,
      this.isNavigatedFromSearchScreen = false});

  @override
  Widget build(BuildContext context) {
    log(SharedPreference.getValue(PrefConstants.MERA_USER_ID) ?? '',
        name: 'UserId');

    return Scaffold(
      appBar: isNavigatedFromSearchScreen
          ? AppBar(
              leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back, color: Colors.white)),
              title: const Text(
                "Search Results",
                style: TextStyle(fontSize: 20),
              ),
            )
          : null,
      floatingActionButton: isNavigatedFromSearchScreen
          ? null
          : FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchScreen(
                              listnerDisplayModel: listnerDisplayModel,
                            )));
              },
              child: const Icon(Icons.search),
            ),
      body: Consumer<HelperScreenNotifier>(builder: (context, ref, child) {
        return FutureBuilder(
            future: ref.searchValue.isNotEmpty
                ? ref.apiGetSearchList()
                : ref.apiGetListnerList(),
            builder: (context, snapshot) {
              return SafeArea(
                child: !snapshot.hasData
                    ? const ShimmerProgressWidget(
                        count: 8, isProgressRunning: true)
                    : SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: false,
                        onRefresh: ref.onRefresh,
                        controller: ref.refreshController,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              snapshot.data!.data!.isEmpty
                                  ? const Column(
                                      children: [
                                        SizedBox(height: 60),
                                        Center(
                                          child: Text('No Search Found',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              )),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(),
                              ListView.builder(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 40),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data?.data?.length ?? 0,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final snapshot2 =
                                        snapshot.data!.data![index];
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          6.0, 8, 6, 8),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HelperDetailScreen(
                                                        listnerDisplayModel:
                                                            snapshot2,
                                                        // ratingModel: ratingModel,
                                                      )));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.grey[500]!),
                                          ),
                                          child: Column(children: [
                                            Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // ClipRRect(
                                                        //   borderRadius:
                                                        //       const BorderRadius.only(
                                                        //           bottomLeft:
                                                        //               Radius.circular(9),
                                                        //           topLeft:
                                                        //               Radius.circular(9)),
                                                        //   child:
                                                        if (snapshot2.image !=
                                                            null) ...{
                                                          CachedNetworkImage(
                                                            imageUrl:
                                                                "${APIConstants.BASE_URL}${snapshot2.image}",
                                                            fit: BoxFit.cover,
                                                            height: 80,
                                                            width: 80,
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              width: 80.0,
                                                              height: 80.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image: DecorationImage(
                                                                    image:
                                                                        imageProvider,
                                                                    fit: BoxFit
                                                                        .cover),
                                                              ),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Image.asset(
                                                              "assets/logo.png",
                                                              width: 30,
                                                              height: 30,
                                                            ),
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Image.asset(
                                                              "assets/logo.png",
                                                              width: 30,
                                                              height: 30,
                                                            ),
                                                          ),
                                                        } else ...{
                                                          Container(
                                                            width: 80,
                                                            height: 80,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    width: 3,
                                                                    color:
                                                                        primaryColor),
                                                                shape: BoxShape
                                                                    .circle),
                                                            child: Image.asset(
                                                              "assets/logo.png",
                                                              width: 30,
                                                              height: 30,
                                                            ),
                                                            //  ),
                                                          ),
                                                        }
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 5.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const SizedBox(
                                                              height: 8),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        5,
                                                                        2,
                                                                        5,
                                                                        2),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  color: const Color(
                                                                      0xffE6EBF7),
                                                                ),
                                                                child:
                                                                    const Text(
                                                                  'Friendship',
                                                                  //ebookList[index].title,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color:
                                                                        colorDarkBlue,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                              Row(children: [
                                                                const Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .green,
                                                                  size: 16,
                                                                ),
                                                                const SizedBox(
                                                                    width: 2),
                                                                Text(
                                                                    snapshot2
                                                                            .totalRatingReview
                                                                            ?.toString() ??
                                                                        '0',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .orange,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    )),
                                                              ]),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                snapshot2
                                                                        .name ??
                                                                    '',
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Color(
                                                                      0xffE6EBF7),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          4.0),
                                                                  child: Text(
                                                                    snapshot2
                                                                            .age ??
                                                                        '',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .grey,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 5),
                                                          Text(
                                                              snapshot2.about ??
                                                                  '',
                                                              maxLines: 2,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 11,
                                                                color:
                                                                    colorBlack,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              )),
                                                          const SizedBox(
                                                              height: 5),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              snapshot2.onlineStatus ==
                                                                      1
                                                                  ? const Text(
                                                                      'JOIN',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .green,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ))
                                                                  : const Text(
                                                                      'Busy',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .red,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      )),
                                                              const Icon(
                                                                Icons
                                                                    .arrow_forward_ios,
                                                                size: 16,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 5),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                          ]),
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
              );
            });
      }),
    );
  }
}

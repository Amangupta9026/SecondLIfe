import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:second_life/api/api_services.dart';
import 'package:second_life/model/listner_display_model.dart';

class HelperScreenNotifier extends ChangeNotifier {
  ListnerDisplayModel? listnerDisplayModel;
  String searchValue = '';

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    await apiGetListnerList();
    refreshController.refreshCompleted();
  }


  // Listner Display API

  Future<ListnerDisplayModel?> apiGetListnerList() async {
    try {
      return listnerDisplayModel = await APIServices.getListnerData();
    } catch (e) {
      log(e.toString());
    } finally {
    }
    return listnerDisplayModel;
  }


   Future<ListnerDisplayModel?> apiGetSearchList() async {
    try {
      return await APIServices.searchListener(searchTerm: searchValue);
    } catch (e) {
      log(e.toString());
    } finally {
     
    }
    return listnerDisplayModel;
  }

  void setSearchValue(String value) {
    searchValue = value;
  }

}

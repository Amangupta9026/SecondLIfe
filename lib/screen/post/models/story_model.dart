// ignore_for_file: depend_on_referenced_packages

import 'package:meta/meta.dart';
import 'package:second_life/screen/post/models/models.dart';


class Story {
  final User? user;
  final String? imageUrl;
  final bool? isViewed;

  const Story({
    @required this.user,
    @required this.imageUrl,
    this.isViewed = false,
  });
}

import 'package:flutter/material.dart';
import 'package:second_life/global/color.dart';
import 'package:second_life/screen/post/data/data.dart';
import 'package:second_life/screen/post/models/post_model.dart';
import 'package:second_life/screen/post/widgets/widgets.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TrackingScrollController _trackingScrollController =
      TrackingScrollController();

  @override
  void dispose() {
    _trackingScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xffA3E0F5),
          centerTitle: true,
          title: const Text('Feed',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: colorBlack)),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: colorBlack,
            ),
          ),
        ),
        body: _HomeScreenMobile(scrollController: _trackingScrollController),
      ),
    );
  }
}

class _HomeScreenMobile extends StatelessWidget {
  final TrackingScrollController? scrollController;

  const _HomeScreenMobile({
    Key? key,
    @required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.0, bottom: 40),
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          const SliverToBoxAdapter(
            child: CreatePostContainer(currentUser: currentUser),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
            sliver: SliverToBoxAdapter(
              child: Rooms(onlineUsers: onlineUsers),
            ),
          ),

          // SliverPadding(
          //   padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
          //   sliver: SliverToBoxAdapter(
          //     child: Stories(
          //       currentUser: currentUser,
          //       stories: stories,
          //     ),
          //   ),
          // ),

          // Post feed list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final Post post = posts[index];
                return PostContainer(post: post);
              },
              childCount: posts.length,
            ),
          ),
        ],
      ),
    );
  }
}

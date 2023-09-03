import 'package:flutter/material.dart';
import 'package:second_life/screen/post/models/models.dart';
import 'package:second_life/screen/post/widgets/widgets.dart';

class CreatePostContainer extends StatelessWidget {
  final User? currentUser;

  const CreatePostContainer({
    Key? key,
    @required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 0.0),
        elevation: 0.0,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileAvatar(imageUrl: currentUser?.imageUrl),
                  const SizedBox(width: 8.0),
                  const Expanded(
                    child: TextField(
                      maxLines: 2,
                      decoration: InputDecoration.collapsed(
                        hintText: 'What\'s on your mind?',
                      ),
                    ),
                  )
                ],
              ),
              const Divider(thickness: 0.5),
              const SizedBox(height: 10.0),
              SizedBox(
                height: 40.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => print('Photo'),
                      icon: const Icon(
                        Icons.photo_library,
                        color: Colors.green,
                      ),
                      label: const Text('Photo'),
                    ),
                    const SizedBox(width: 10.0),
                    const VerticalDivider(width: 8.0),
                    const SizedBox(width: 10.0),
                    ElevatedButton.icon(
                      onPressed: () => print('Video'),
                      icon: const Icon(
                        Icons.video_call,
                        color: Colors.purpleAccent,
                      ),
                      label: const Text('Video'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

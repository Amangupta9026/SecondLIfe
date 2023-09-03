import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:second_life/provider/helperscreen_notifier.dart';
import 'package:second_life/provider/login_screen_notifier.dart';

final List<SingleChildWidget> multiProviderNames = [
  ChangeNotifierProvider(create: (_) => HelperScreenNotifier()),
  ChangeNotifierProvider(create: (_) => LoginScreenNotifier()),

 
];

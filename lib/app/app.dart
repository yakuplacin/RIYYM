import 'package:riyym/services/media_service.dart';
import 'package:stacked/stacked_annotations.dart';
@StackedApp(
  dependencies: [
    LazySingleton(classType: MediaService),
  ],
)
class AppSetup {}
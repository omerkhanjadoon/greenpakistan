import 'package:green_pakistan/src/models/nursery.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class WalkthroughController extends ControllerMVC {
  List<Nursery> topNursery = <Nursery>[];

  WalkthroughController() {
    //listenForTopNursery();
  }
//  void listenForTopNursery() async {
//    LocationData _locationData = await getCurrentLocation();
//    final Stream<Nursery> stream = await getNearNursery(_locationData, _locationData);
//    stream.listen((Nursery _nursery) {
//      setState(() => topNursery.add(_nursery));
//    }, onError: (a) {}, onDone: () {});
//  }
}

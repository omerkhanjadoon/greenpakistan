import 'package:green_pakistan/src/models/nursery.dart';
import 'package:green_pakistan/src/repository/nursery_repository.dart';
import 'package:green_pakistan/src/repository/search_repository.dart';
import 'package:green_pakistan/src/repository/settings_repository.dart';
import 'package:location/location.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class SearchController extends ControllerMVC {
  List<Nursery> nurserys = <Nursery>[];

  SearchController() {
    listenForNursery();
  }

  void listenForNursery({String search}) async {
    if (search == null) {
      search = await getRecentSearch();
    }
    LocationData _locationData = await getCurrentLocation();
    final Stream<Nursery> stream = await searchNursery(search, _locationData);
    stream.listen((Nursery _nursery) {
      setState(() => nurserys.add(_nursery));
    }, onError: (a) {}, onDone: () {});
  }

  Future<void> refreshSearch(search) async {
    nurserys = <Nursery>[];
    listenForNursery(search: search);
  }

  void saveSearch(String search) {
    setRecentSearch(search);
  }
}

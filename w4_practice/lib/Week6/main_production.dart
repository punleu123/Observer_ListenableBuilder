import 'package:provider/provider.dart';
import 'package:w4_practice/Week6/data/repositories/songs/song_repository_remote.dart';

import 'data/repositories/songs/song_repository.dart';
import 'main_common.dart';

List<Provider> get providersProduction {
  return [
    Provider<SongRepository>(create: (context) => SongRepositoryRemote()),
  ];
}

void main() {
  mainCommon(providersProduction);
}

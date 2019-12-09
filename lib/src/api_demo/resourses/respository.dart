import 'dart:async';
import 'news_api_provider.dart';
import 'news_db_provider.dart';
import '../models/model.dart';

class Repository {
  List<Source> sources = <Source>[
    NewsApiProvider(),
    dbProvider,
  ];

  List<Cache> caches = <Cache>[
    dbProvider,
  ];

  Future<List<int>> fetchTopIds() {
    return sources[0].fetchTopIds();
  }

  Future<ItemModel> fetchItem(int id) async {
    Source source;
    ItemModel item;
    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) break;
    }
    if (item != null) {
      for (var cache in caches) {
        cache.addItem(item);
      }
    }
    return item;
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();

  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
}

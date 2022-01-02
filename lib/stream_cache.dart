import 'dart:async';

import 'dart:collection';

class StreamCache {
  static HashMap<String, StreamController<String?>> cache = HashMap();
  static HashMap<String, StreamController<bool>> cacheRefresh = HashMap();

  StreamCache._privateConstructor();

  static StreamCache instance() {
    if (_instance != null) {
      return _instance!;
    } else {
      _instance = StreamCache._privateConstructor();
    }
    return _instance!;
  }

  static StreamCache? get inst => _instance;
  static StreamCache? _instance;

  static StreamController<String?> getStream(String id) {
    if (!cache.containsKey(id)) {
      cache[id] = StreamController<String>.broadcast();
    }
    return cache[id]!;
  }

  static StreamController<bool> getStreamRefresh(String id) {
    if (!cacheRefresh.containsKey(id)) {
      cacheRefresh[id] = StreamController<bool>.broadcast();
    }
    return cacheRefresh[id]!;
  }

  static void closeStream(String id){
    if (cache.containsKey(id)) {
      cache[id]?.close();
      cache.remove(id);
    }
  }
  static void closeRefreshStream(String id){
    if (cacheRefresh.containsKey(id)) {
      cacheRefresh[id]?.close();
      cacheRefresh.remove(id);
    }
  }

}

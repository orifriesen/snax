import 'dart:core';

Map<String, Map<String, dynamic>> _cachedResponses = {};
const _maxCacheEntries = 15;

class Cache {
  static void add(String key, dynamic value) {
    //Write the data
    _cachedResponses[key] = {
      't': DateTime.now().millisecondsSinceEpoch,
      'v': value
    };
    print("[eschers cache] Added a value to cache");
    //Return if it's not overflowing yet
    if (_cachedResponses.length <= _maxCacheEntries) return;
    //Delete the last element as this new one will take it's place
    var timestamps = _cachedResponses.values.map((e) => e['t']).toList();
    timestamps.sort();
    _cachedResponses.removeWhere((key, value) => value['t'] == timestamps.last);
  }

  static bool has(String key) { 
    //Uncomment line below to completely disable cache
    //return false;
    return _cachedResponses.containsKey(key); 
    }
  static dynamic fetch(String key) {
    print("[eschers cache] Using a value from cache. items in cache right now: ${_cachedResponses.length}/$_maxCacheEntries");
    return _cachedResponses[key]['v'];
  }
}

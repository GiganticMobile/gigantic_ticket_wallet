import 'dart:developer' as developer;

/// common checks for all api responses
class Checks {

  /// this file contains common checks made to the responses from api requests
  static void checkResponseCode(int code) {
    if (code == 404) {
      developer.log('API 404 no connection error',
          name: 'API FAILED CHECK ERROR',);
      throw Exception('404 no connection');
    } else if (code == 500) {
      developer.log('API 500 unexpected error', name: 'API FAILED CHECK ERROR');
      throw Exception('500 api error');
    } else if (code == 401) {
      developer.log('API 401 unauthorised error',
          name: 'API FAILED CHECK ERROR',);
      throw Exception('401 unauthorised connection');
    }
  }

  /// This checks if the api response returned an error
  /*static void checkIfReturnedError(dynamic json) {
    const statusJsonKey = 'status';
    const messageJsonKey = 'message';
    //this checks if the result from the api is an error
    if (json case {
    statusJsonKey: final String status,
    messageJsonKey: final String message,
    }) {
      if (status != 'OK') {
        throw Exception(message);
      }
    }
  }*/

  /// checks if the api returned an empty list
  /*static bool checkIsEmpty(dynamic json) {

    //in api results like in fetch stats if no items are found
    // (for example no stats found)
    //then the api returns an empty list. If not then the api will return a map.

    try {
      json as Map;
      //not empty
      return false;
    } catch (_) {
      //empty
      return true;
    }
  }*/
}

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:news/localStorage.dart';

class ProfileProvider with ChangeNotifier{
    Map _profile = {};

    void removeUser(){
      _profile = {};
      notifyListeners();
    }

    void setUser(user){
      _profile = user;
      notifyListeners();
    }

    initUser() async {
      var user = await authenticate();
      if (user != null) {
        _profile = user;
        return true;
      } else {
        return false;
      }
    }

    Map get profile => _profile;
}
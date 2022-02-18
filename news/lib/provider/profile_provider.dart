import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ProfileProvider with ChangeNotifier{
    Map _profile = {};


    void removeUser(){
      _profile = {};
      notifyListeners();
    }

    void setUser(user){
      _profile = user;
      print(_profile);
      notifyListeners();
    }
    Map get profile => _profile;
}
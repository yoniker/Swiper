


import 'package:flutter/material.dart';

enum UserType{
POF_USER,REAL_USER
}

class UserId{

  final String id;
  final UserType userType;

  UserId( {@required this.id,@required this.userType});

}
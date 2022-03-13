


import 'package:flutter/material.dart';

enum UserType{
DUMMY,REAL_USER
}

class UserId{

  final String? id;
  final UserType userType;

  const UserId( {required this.id,required this.userType});

}
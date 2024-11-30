import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gonogo/consent_form.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';

void main() {
  runApp(SafeArea(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(child: ConsentForm()),
    ),
  ));
}






















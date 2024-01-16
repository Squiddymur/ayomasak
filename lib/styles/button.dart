import 'package:ayomakan/styles/color.dart';
import 'package:flutter/material.dart';

final ButtonStyle buttonPrimary = ElevatedButton.styleFrom(
    minimumSize: const Size(300, 51),
    backgroundColor: greenPrimary,
    elevation: 2,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
      Radius.circular(10),
    )));

final ButtonStyle buttonDaftar = ElevatedButton.styleFrom(
    minimumSize: const Size(136, 51),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))));
final ButtonStyle buttonMasuk = ElevatedButton.styleFrom(
    minimumSize: const Size(136, 51),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))));

final ButtonStyle buttonSimpan = ElevatedButton.styleFrom(
    minimumSize: const Size(300, 51),
    backgroundColor: greenPrimary,
    elevation: 2,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
      Radius.circular(10),
    )));

final ButtonStyle buttonLogin = ElevatedButton.styleFrom(
    minimumSize: const Size(300, 51),
    backgroundColor: greenPrimary,
    elevation: 2,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
      Radius.circular(10),
    )));

final ButtonStyle buttonIkuti = ElevatedButton.styleFrom(
    minimumSize: const Size(182, 32),
    backgroundColor: greenPrimary,
    elevation: 2,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
      Radius.circular(10),
    )));

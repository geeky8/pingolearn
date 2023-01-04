// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pingolearn/enums.dart';
import 'package:pingolearn/models.dart';
import 'package:pingolearn/repository.dart';
import 'package:pingolearn/screens/home_screen.dart';

class NewsController extends GetxController {
  final state = StoreState.SUCCESS.obs;
  final newsState = StoreState.SUCCESS.obs;
  final news = <Model>[].obs;

  final repo = Repository();
  final myRemoteConfig = FirebaseRemoteConfig.instance.obs;

  Future<void> getNews() async {
    final result =
        await repo.getNews(myRemoteConfig.value.getString('country'));
    state.value = StoreState.LOADING;

    if (result != null) {
      news
        ..clear()
        ..addAll(result);
    }

    state.value = StoreState.SUCCESS;
  }

  Future<void> signup(
    String email,
    String password,
    String name,
    BuildContext context,
  ) async {
    final auth = FirebaseAuth.instance;
    try {
      state.value = StoreState.LOADING;
      final user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final fireStore = FirebaseFirestore.instance;

      // data been added to users collection in Firestore
      final data = {"name": name, "email": email};
      await fireStore.collection('users').add(data);

      await setupRemoteConfig();

      state.value = StoreState.SUCCESS;
      if (user.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ),
        );
      } else {
        Fluttertoast.showToast(msg: 'Failed to register the user');
      }
    } on FirebaseAuthException catch (e) {
      state.value = StoreState.SUCCESS;
      Fluttertoast.showToast(msg: 'Failed to register the user');
    }
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    final auth = FirebaseAuth.instance;
    try {
      state.value = StoreState.LOADING;
      final user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      await setupRemoteConfig();
      state.value = StoreState.SUCCESS;
      if (user.user != null) {
        Future.delayed(
          Duration.zero,
          () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomeScreen(),
              ),
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      state.value = StoreState.SUCCESS;
      Fluttertoast.showToast(msg: 'Failed to sign in the user');
    }
  }

  Future<void> setupRemoteConfig() async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await remoteConfig.setDefaults(<String, dynamic>{
      'country': 'in',
    });
    RemoteConfigValue(null, ValueSource.valueStatic);
    myRemoteConfig.value = remoteConfig;

    try {
      // Using zero duration to force fetching from remote server.
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();
    } on PlatformException catch (exception) {
      // Fetch exception.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
      print(exception);
    }
  }
}

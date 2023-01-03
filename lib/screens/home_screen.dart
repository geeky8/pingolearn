// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pingolearn/constants.dart';
import 'package:pingolearn/controller.dart';
import 'package:pingolearn/enums.dart';
import 'package:pingolearn/models.dart';
import 'package:pingolearn/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final model = Model(
    source: 'News Souce',
    description:
        'Dependencies specify other packages that your package needs in order to work.',
    time: '10 mins Ago',
    image: 'image',
  );

  _getNews() async {
    final controller = Get.put(NewsController());
    controller.newsState.value = StoreState.LOADING;
    await controller.getNews();
    controller.newsState.value = StoreState.SUCCESS;
  }

  @override
  void initState() {
    _getNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewsController>();
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: customText(
            'MyNews',
            18,
            FontWeight.bold,
          ),
          backgroundColor: Colors.blue[700],
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () async {
                final auth = FirebaseAuth.instance;
                await auth.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.send,
                size: 18,
              ),
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText('Top Headlines', 17, FontWeight.w600),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Obx(() {
                  final state = controller.newsState.value;
                  switch (state) {
                    case StoreState.LOADING:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case StoreState.SUCCESS:
                      return ListView.separated(
                          separatorBuilder: (_, index) {
                            return const SizedBox(
                              height: 30,
                            );
                          },
                          itemCount: controller.news.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (_, index) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 7),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        customText(
                                          controller.news[index].source,
                                          14,
                                          FontWeight.bold,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: customText(
                                                  controller
                                                      .news[index].description,
                                                  13,
                                                  FontWeight.w500,
                                                  maxLines: 3),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        customText(controller.news[index].time,
                                            11, FontWeight.w500,
                                            color: Colors.grey),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Expanded(
                                    flex: 4,
                                    child: SizedBox(
                                      // height: 70,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                            controller.news[index].image),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    case StoreState.FAILURE:
                      return const SizedBox();
                  }
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

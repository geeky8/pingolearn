import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pingolearn/constants.dart';
import 'package:pingolearn/controller.dart';
import 'package:pingolearn/enums.dart';
import 'package:pingolearn/screens/login_screen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewsController());
    return Scaffold(
      body: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: customText(
            'MyNews',
            20,
            FontWeight.bold,
            color: Colors.blue[700],
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        bottomNavigationBar: SizedBox(
          height: MediaQuery.of(context).size.height / 9,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    // controller.state.value = StoreState.LOADING;
                    await controller.signup(
                      emailController.text.trim(),
                      passController.text.trim(),
                      nameController.text.trim(),
                      context,
                    );
                    // controller.state.value = StoreState.SUCCESS;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[700],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: customText(
                      'SignUp',
                      16,
                      FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    customText(
                      'Already have an account?',
                      14,
                      FontWeight.w600,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: customText(
                        ' Login',
                        16,
                        FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Obx(
          () => Stack(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const Spacer(),
                    // Expanded(child: SizedBox()),
                    customTextFormField(
                        emailController,
                        TextInputType.emailAddress,
                        'E-mail',
                        'abc@gmail.com',
                        Icons.email, validator: (value) {
                      if (value != null) {
                        if (!emailRegex.hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                      }
                      return null;
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    customTextFormField(
                      passController,
                      TextInputType.visiblePassword,
                      'Password',
                      'pass',
                      Icons.password,
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    customTextFormField(
                      nameController,
                      TextInputType.name,
                      'Name',
                      'xyz',
                      Icons.person,
                    ),
                  ],
                ),
              ),
              if (controller.state.value == StoreState.LOADING)
                Container(
                  decoration: const BoxDecoration(color: Colors.black26),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

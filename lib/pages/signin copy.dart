import 'package:admin_addschedule/pages/homewithsidenav.dart';
import 'package:admin_addschedule/pages/signup.dart';
import 'package:admin_addschedule/services/firestore.dart';
import 'package:admin_addschedule/themes/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter/cupertino.dart';


class SignIn2 extends StatefulWidget {
  const SignIn2({super.key});

  @override
  State<SignIn2> createState() => _SignIn2State();
}

class _SignIn2State extends State<SignIn2> {

  bool isRegister = true;
  final _form = GlobalKey<FormState>();
  bool showPassword = true;

  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void resetForm() {
    _form.currentState!.reset();
    mailController.clear();
    passwordController.clear();
  }

  userLogin() async {
    if (_form.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: mailController.text,
          password: passwordController.text,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SidebarXExampleApp()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "No User Found for that Email",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Wrong Password Provided by User",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        }
      }
    }
  }

  registration() async {
    if (_form.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: mailController.text,
          password: passwordController.text,
        );

        Map<String, dynamic> userInfoMap = {
          "email": userCredential.user!.email,
          "password": passwordController.text,
          "id": userCredential.user!.uid,
        };

        await FirestoreService().addUser(userCredential.user!.uid, userInfoMap);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Registered Successfully",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        );

        resetForm();
        setState(() {
          isRegister = false;
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account Already exists",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLarge = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      body: Container(
        color: bgColor,
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: isLarge ? Container(
            width: 850,
            height: 600,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: outlineColor, width: 1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 424,
                      height: 600,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Form(
                              key: _form,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    isRegister ? 'Create Account!' : 'Welcome Back!',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    isRegister ? 'Please register here to continue' : 'Please login here to continue',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 20),
                                  TextFormField(
                                    controller: mailController,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.email),
                                      labelText: 'Email',
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    autocorrect: false,
                                    textCapitalization: TextCapitalization.none,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    controller: passwordController,
                                    obscureText: showPassword,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.lock),
                                      labelText: 'Password',
                                      suffixIcon: IconButton(
                                        icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            showPassword = !showPassword;
                                          });
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty || value.length < 8) {
                                        return 'Password must be at least 8 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 25),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 18),
                                      backgroundColor: Color(0xff274c77),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: isRegister ? registration : userLogin,
                                    child: Text(
                                      isRegister ? 'Register' : 'Login',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(isRegister ? 'Already have an account?' : 'New to platform?'),
                                      TextButton(
                                        onPressed: () {
                                          resetForm();
                                          setState(() {
                                            isRegister = !isRegister;
                                          });
                                        },
                                        child: Text(isRegister ? 'Login here' : 'Register Here'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: Color(0xff274c77),
                          borderRadius: BorderRadius.only(topRight: Radius.circular(25),bottomRight: Radius.circular(25))
                        ),
                      width: 424,
                      height: 600,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'CISC Room Utilization',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 28,
                                color: highlightColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Image.asset('logo-white.png'),
                            ),
                            const Text(
                              'Schedule your room usage with registrar directly through CISC Room Utilization',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: highlightColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ) : Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: outlineColor, width: 1),
              borderRadius: BorderRadius.circular(25),
            ),
            width: 350,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                      key: _form,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Cisc Room Util.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            isRegister ? 'Create Account!' : 'Welcome Back!',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                          ),
                          Text(
                            isRegister ? 'Please register here to continue' : 'Please login here to continue',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: mailController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: passwordController,
                            obscureText: showPassword,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    showPassword = !showPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty || value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 25),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              backgroundColor: Color(0xff274c77),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: isRegister ? registration : userLogin,
                            child: Text(
                              isRegister ? 'Register' : 'Login',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(isRegister ? 'Already have an account?' : 'New to platform?'),
                              TextButton(
                                onPressed: () {
                                  resetForm();
                                  setState(() {
                                    isRegister = !isRegister;
                                  });
                                },
                                child: Text(isRegister ? 'Login here' : 'Register Here'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


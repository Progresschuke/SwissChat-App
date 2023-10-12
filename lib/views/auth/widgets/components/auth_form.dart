import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiss_chat_app/controllers/login_state_provider.dart';
import 'package:swiss_chat_app/helpers/dialogs.dart';

import '../../../../api/api.dart';
import '../../../../controllers/image_picker_provider.dart';
import 'image_input.dart';

class AuthForm extends ConsumerStatefulWidget {
  const AuthForm({super.key});

  @override
  ConsumerState<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends ConsumerState<AuthForm> {
  final form = GlobalKey<FormState>();

  var _isLogin = true;
  var _isAuthenticating = false;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';

  void _submit() async {
    final selectedImage = ref.watch(profileImageStateProvider);
    FocusScope.of(context).unfocus();
    final isValid = form.currentState!.validate();

    if (!_isLogin && selectedImage == null) {
      Dialogs.showSnackbar(
          context, 'Fill out the form correctly with an image');

      return;
    }

    if (!isValid) {
      return;
    } else {
      form.currentState!.save();
    }

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        await APIs.auth.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
        //to control login state of users and manage the stored data to be displayed
        ref.read(loginStateProvider.notifier).isLoginTrue();
        APIs.storeUserData(APIs.auth.currentUser!);
        if (context.mounted) {
          context.go('/contact');
        }
      } else {
        final userCredentials = await APIs.auth.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final storageRef = APIs.storage
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');

        await storageRef.putFile(selectedImage!);
        final imageUrl = await storageRef.getDownloadURL();

        APIs.createUser(_enteredUsername, _enteredEmail, imageUrl);
        //to control login state of users and manage the stored data to be displayed
        ref.read(loginStateProvider.notifier).isLoginFalse();

        //to reset image
        // ref.read(profileImageStateProvider.notifier).resetImage();

        //save user's data locally
        sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences!.setString('uid', userCredentials.user!.uid);
        await sharedPreferences!
            .setString('email', userCredentials.user!.email!);
        await sharedPreferences!.setString('name', _enteredUsername);
        await sharedPreferences!.setString('imageUrl', imageUrl);
        if (context.mounted) {
          context.go('/contact');
        }
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        _isAuthenticating = false;
      });
      if (error.code == 'email-already-in-use') {}
      Dialogs.showSnackbar(context, error.message ?? 'Authentication failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: form,
            child: Column(
              children: [
                if (!_isLogin) const ImageInput(),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredEmail = value!;
                  },
                ),
                if (!_isLogin)
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                    autocorrect: false,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value.trim().length <= 4) {
                        return 'Please enter a valid username';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _enteredUsername = value!;
                    },
                  ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  autocorrect: false,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.trim().length < 6) {
                      return ' password must be at least 6 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredPassword = value!;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                if (_isAuthenticating) const CircularProgressIndicator(),
                if (!_isAuthenticating)
                  ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                        elevation: 3,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .tertiaryContainer
                            .withOpacity(.85)),
                    child: Text(_isLogin ? 'Log in' : 'Sign up'),
                  ),
                if (!_isAuthenticating)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(_isLogin
                        ? 'Create an account'
                        : 'I have an existing account'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

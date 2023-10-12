import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiss_chat_app/controllers/login_state_provider.dart';
import 'package:swiss_chat_app/models/chat_user.dart';
import 'package:swiss_chat_app/views/profile/widgets/components/profile_stats.dart';

import '../../../../api/api.dart';

class ProfileForm extends ConsumerStatefulWidget {
  const ProfileForm({super.key});

  @override
  ConsumerState<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends ConsumerState<ProfileForm> {
  ChatUser? user;

  @override
  void initState() {
    getSavedData();
    super.initState();
  }

  getSavedData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    bool isLogin = ref.watch(loginStateProvider);

    if (isLogin) {
      user = await APIs.getLoggedUserData();
    } else {
      user = await APIs.getStoredData();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          if (user != null)
            if (user!.username == null)
              SizedBox(
                child: Column(
                  children: [
                    ProfileStats(
                      heading: 'Name',
                      icon: CupertinoIcons.person,
                      title: 'Name',
                      subtitle: 'This name will be displayed as your username',
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 0.003 * size.height,
                    ),
                    ProfileStats(
                      heading: 'About',
                      icon: CupertinoIcons.info_circle,
                      title: 'A Flutter Developer',
                      subtitle: "userEmail",
                      onTap: () {},
                    ),
                  ],
                ),
              ),
          if (user != null)
            if (user!.username != null)
              SizedBox(
                child: Column(
                  children: [
                    ProfileStats(
                      heading: 'Name',
                      icon: CupertinoIcons.person,
                      title: user!.username,
                      subtitle: 'This name will be displayed as your username',
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 0.003 * size.height,
                    ),
                    ProfileStats(
                      heading: 'About',
                      icon: CupertinoIcons.info_circle,
                      title: user!.about ?? 'A Flutter Developer',
                      subtitle: user!.email ?? "userEmail",
                      onTap: () {},
                    )
                  ],
                ),
              ),
          if (user == null)
            SizedBox(
              child: Column(
                children: [
                  ProfileStats(
                    heading: 'Name',
                    icon: CupertinoIcons.person,
                    title: 'Name',
                    subtitle: 'This name will be displayed as your username',
                    onTap: () {},
                  ),
                  SizedBox(
                    height: 0.003 * size.height,
                  ),
                  ProfileStats(
                    heading: 'About',
                    icon: CupertinoIcons.info_circle,
                    title: 'A Flutter Developer',
                    subtitle: "userEmail",
                    onTap: () {},
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ChangeName extends StatelessWidget {
  const ChangeName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 0.5 * size.height,
            padding: EdgeInsets.symmetric(
                vertical: 0.006 * size.height, horizontal: 0.07 * size.width),
            width: size.width,
            child: TextFormField(
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD95151)),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD95151)),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                errorStyle: TextStyle(color: Color(0xFFD95151)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                labelText: 'Enter your name',
                labelStyle: TextStyle(
                  color: Color(0xFFC9C9C9),
                ),
                // suffixIcon: suffixIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

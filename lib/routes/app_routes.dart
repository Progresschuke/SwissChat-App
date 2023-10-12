import 'package:go_router/go_router.dart';
import 'package:swiss_chat_app/views/auth/auth.dart';
import 'package:swiss_chat_app/views/chat/chat.dart';
import 'package:swiss_chat_app/views/contact/contact.dart';
import 'package:swiss_chat_app/views/profile/profile.dart';
import 'package:swiss_chat_app/views/splash/splash.dart';

class AppRouter {
  GoRouter router = GoRouter(routes: [
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/contact',
      builder: (context, state) => const ContactScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatScreen(),
    ),
    // GoRoute(
    //   path: '/navs',
    //   builder: (context, state) => const NavScreen(),
    // ),
    // GoRoute(
    //   path: '/meal',
    //   builder: (context, state) => const MealScreen(),
    // ),
    // GoRoute(
    //   path: '/newItem',
    //   builder: (context, state) => const NewMealItemScreen(),
    // ),
  ]);
}

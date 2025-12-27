import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/auth/presentation/pages/sign_up_page.dart';
import '../../features/books/presentation/pages/main_wrapper.dart';
import '../../features/books/presentation/pages/add_book_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const MainWrapper()),
      GoRoute(path: '/signin', builder: (context, state) => const SignInPage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignUpPage()),
      GoRoute(
        path: '/add_book',
        builder: (context, state) => const AddBookPage(),
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = authState.user != null;
      final isLoggingIn = state.uri.toString() == '/signin';
      final isSigningUp = state.uri.toString() == '/signup';

      if (!isLoggedIn && !isLoggingIn && !isSigningUp) {
        return '/signin';
      }

      if (isLoggedIn && (isLoggingIn || isSigningUp)) {
        return '/';
      }

      return null;
    },
  );
});

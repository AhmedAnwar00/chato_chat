enum AppRoute {
  splash('/'),
  login('/login'),
  signUp('/sign-up'),
  chat('/chat');

  const AppRoute(this.path);

  final String path;
}

enum AppRoute {
  splash('/'),
  login('/login'),
  signUp('/sign-up');

  const AppRoute(this.path);

  final String path;
}

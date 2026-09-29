enum AppRoute {
  splash('/'),
  login('/login'),
  signUp('/sign-up'),
  fakeHome('/fake-home');

  const AppRoute(this.path);

  final String path;
}

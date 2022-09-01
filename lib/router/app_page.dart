enum AppPage {
  splash('Splash', ''),
  login('Login', 'login'),
  welcome('Welcome', 'welcome');

  const AppPage(this.name, this.path);

  final String name;
  final String path;

  String get fullPath => '/$path';
}

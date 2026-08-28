enum AppEnvironment { development, staging, production }

abstract final class AppConfig {
  static const environmentName = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  static AppEnvironment get environment => switch (environmentName) {
    'staging' => AppEnvironment.staging,
    'production' => AppEnvironment.production,
    _ => AppEnvironment.development,
  };
}

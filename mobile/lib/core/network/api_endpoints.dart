abstract final class ApiEndpoints {
  static const health = '/api/v1/health';
  static const requestRegistrationOtp = '/api/v1/auth/register/request-otp';
  static const register = '/api/v1/auth/register';
  static const login = '/api/v1/auth/login';
  static const refreshToken = '/api/v1/auth/token/refresh';
  static const requestPasswordOtp = '/api/v1/auth/password/request-otp';
  static const verifyPasswordOtp = '/api/v1/auth/password/verify-otp';
  static const resetPassword = '/api/v1/auth/password/reset';
  static const me = '/api/v1/auth/me';
  static const logout = '/api/v1/auth/logout';
  static const logoutAll = '/api/v1/auth/logout-all';

  static String customers(String businessId) =>
      '/api/v1/businesses/$businessId/customers';

  static String customer(String businessId, String clientUuid) =>
      '${customers(businessId)}/$clientUuid';

  static String restoreCustomer(String businessId, String clientUuid) =>
      '${customer(businessId, clientUuid)}/restore';

  static String deleteCustomerPermanently(
    String businessId,
    String clientUuid,
  ) => '${customer(businessId, clientUuid)}/permanent';

  static String customerPhoto(String businessId, String clientUuid) =>
      '${customer(businessId, clientUuid)}/photo';
}

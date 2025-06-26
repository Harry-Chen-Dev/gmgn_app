import '../models/user.dart';
import 'local_storage_service.dart';

class AuthService {
  static User? _currentUser;

  static User? get currentUser => _currentUser;

  // 初始化服务
  static Future<void> initialize() async {
    await LocalStorageService.initializeDefaultUsers();
    _currentUser = await LocalStorageService.getCurrentUser();
  }

  static Future<User?> login(String email, String password) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(seconds: 1));

    final user = await LocalStorageService.loginUser(
      email: email,
      password: password,
    );

    if (user != null) {
      _currentUser = user;
      return user;
    }

    return null;
  }

  static Future<bool> register(String email, String password) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(seconds: 1));

    return await LocalStorageService.registerUser(
      email: email,
      password: password,
    );
  }

  static Future<void> logout() async {
    await LocalStorageService.logoutUser();
    _currentUser = null;
  }

  static Future<User?> getCurrentUser() async {
    if (_currentUser == null) {
      _currentUser = await LocalStorageService.getCurrentUser();
    }
    return _currentUser;
  }

  // 检查邮箱是否已注册
  static Future<bool> isEmailRegistered(String email) async {
    return await LocalStorageService.isEmailRegistered(email);
  }

  // 更新用户信息
  static Future<bool> updateUser(User user) async {
    final success = await LocalStorageService.updateUser(user);
    if (success) {
      _currentUser = user;
    }
    return success;
  }

  // 获取测试账号（用于开发）
  static List<Map<String, String>> getTestAccounts() {
    return LocalStorageService.getTestAccounts();
  }
}

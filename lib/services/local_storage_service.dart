import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class LocalStorageService {
  static const String _usersKey = 'registered_users';
  static const String _currentUserKey = 'current_user';

  // 预设测试账号
  static final List<Map<String, dynamic>> _defaultUsers = [
    {
      'email': 'test@gmgn.ai',
      'password': '123456',
      'id': '58519234',
      'walletAddress': '6bis3...sgkz',
      'solBalance': 12.3456789,
      'followers': 1234,
      'isBalanceVisible': true,
    },
    {
      'email': 'demo@gmgn.ai',
      'password': '123456',
      'id': '12345678',
      'walletAddress': 'AbCd1...XyZ9',
      'solBalance': 5.6789012,
      'followers': 567,
      'isBalanceVisible': true,
    },
    {
      'email': 'admin@gmgn.ai',
      'password': 'admin123',
      'id': '11111111',
      'walletAddress': 'Admin...1234',
      'solBalance': 100.0,
      'followers': 10000,
      'isBalanceVisible': true,
    },
  ];

  // 初始化默认用户数据
  static Future<void> initializeDefaultUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final existingUsers = prefs.getString(_usersKey);

    if (existingUsers == null) {
      // 如果没有用户数据，则初始化默认用户
      await prefs.setString(_usersKey, json.encode(_defaultUsers));
    }
  }

  // 获取所有注册用户
  static Future<List<Map<String, dynamic>>> getRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    if (usersJson != null) {
      final List<dynamic> usersList = json.decode(usersJson);
      return usersList.cast<Map<String, dynamic>>();
    }

    return [];
  }

  // 用户注册
  static Future<bool> registerUser({
    required String email,
    required String password,
  }) async {
    try {
      final users = await getRegisteredUsers();

      // 检查邮箱是否已存在
      final existingUser = users.firstWhere(
        (user) => user['email'] == email,
        orElse: () => {},
      );

      if (existingUser.isNotEmpty) {
        return false; // 邮箱已存在
      }

      // 生成新用户数据
      final newUser = {
        'email': email,
        'password': password,
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'walletAddress': _generateWalletAddress(),
        'solBalance': 0.0,
        'followers': 0,
        'isBalanceVisible': true,
      };

      users.add(newUser);

      // 保存到本地存储
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_usersKey, json.encode(users));

      return true;
    } catch (e) {
      return false;
    }
  }

  // 用户登录
  static Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final users = await getRegisteredUsers();

      final userMap = users.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
        orElse: () => {},
      );

      if (userMap.isNotEmpty) {
        final user = User.fromJson(userMap);

        // 保存当前登录用户
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_currentUserKey, json.encode(userMap));

        return user;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // 获取当前登录用户
  static Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_currentUserKey);

      if (userJson != null) {
        final userMap = json.decode(userJson);
        return User.fromJson(userMap);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // 用户登出
  static Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  // 检查邮箱是否已注册
  static Future<bool> isEmailRegistered(String email) async {
    final users = await getRegisteredUsers();
    return users.any((user) => user['email'] == email);
  }

  // 更新用户信息
  static Future<bool> updateUser(User user) async {
    try {
      final users = await getRegisteredUsers();
      final userIndex = users.indexWhere((u) => u['id'] == user.id);

      if (userIndex != -1) {
        users[userIndex] = user.toJson();

        // 保存到本地存储
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_usersKey, json.encode(users));

        // 如果是当前用户，也更新当前用户信息
        final currentUser = await getCurrentUser();
        if (currentUser?.id == user.id) {
          await prefs.setString(_currentUserKey, json.encode(user.toJson()));
        }

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // 生成钱包地址
  static String _generateWalletAddress() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;

    String address = '';
    for (int i = 0; i < 8; i++) {
      address += chars[(random + i) % chars.length];
    }

    return '${address.substring(0, 4)}...${address.substring(4)}';
  }

  // 获取测试账号列表（用于开发测试）
  static List<Map<String, String>> getTestAccounts() {
    return [
      {
        'email': 'test@gmgn.ai',
        'password': '123456',
        'description': '测试账号1 - 已验证用户',
      },
      {
        'email': 'demo@gmgn.ai',
        'password': '123456',
        'description': '测试账号2 - 普通用户',
      },
      {
        'email': 'admin@gmgn.ai',
        'password': 'admin123',
        'description': '测试账号3 - 管理员账号',
      },
    ];
  }
}

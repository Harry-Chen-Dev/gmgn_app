import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String walletAddress;
  final int followers;
  final double solBalance;
  final bool isBalanceVisible;

  const User({
    required this.id,
    required this.email,
    required this.walletAddress,
    required this.followers,
    required this.solBalance,
    this.isBalanceVisible = true,
  });

  User copyWith({
    String? id,
    String? email,
    String? walletAddress,
    int? followers,
    double? solBalance,
    bool? isBalanceVisible,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      walletAddress: walletAddress ?? this.walletAddress,
      followers: followers ?? this.followers,
      solBalance: solBalance ?? this.solBalance,
      isBalanceVisible: isBalanceVisible ?? this.isBalanceVisible,
    );
  }

  // 从JSON创建User对象
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      walletAddress: json['walletAddress'] as String,
      followers: json['followers'] as int,
      solBalance: (json['solBalance'] as num).toDouble(),
      isBalanceVisible: json['isBalanceVisible'] as bool? ?? true,
    );
  }

  // 将User对象转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'walletAddress': walletAddress,
      'followers': followers,
      'solBalance': solBalance,
      'isBalanceVisible': isBalanceVisible,
    };
  }

  @override
  List<Object?> get props => [
        id,
        email,
        walletAddress,
        followers,
        solBalance,
        isBalanceVisible,
      ];
}

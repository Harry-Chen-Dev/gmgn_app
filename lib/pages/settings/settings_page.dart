import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '设置',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              // TODO: 刷新用户信息
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return _buildAuthenticatedContent(context, state);
          } else {
            return _buildUnauthenticatedContent(context);
          }
        },
      ),
    );
  }

  Widget _buildAuthenticatedContent(
      BuildContext context, AuthAuthenticated state) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // 用户信息区域
                _buildUserInfoSection(context, state),
                const SizedBox(height: 20),

                // 设置选项列表
                _buildSettingsOptions(context),
              ],
            ),
          ),
        ),

        // 底部断开连接按钮
        _buildDisconnectButton(context),
      ],
    );
  }

  Widget _buildUnauthenticatedContent(BuildContext context) {
    return const Center(
      child: Text(
        '请先登录',
        style: TextStyle(
          fontSize: 16,
          color: Color(0xFF666666),
        ),
      ),
    );
  }

  Widget _buildUserInfoSection(BuildContext context, AuthAuthenticated state) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // 用户头像
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF00C851),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/gmgn_avatar.png',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00C851),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),

          // 用户信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      state.user.walletAddress,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.edit,
                      size: 16,
                      color: Color(0xFF999999),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      '钱包地址: ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF999999),
                      ),
                    ),
                    Text(
                      state.user.walletAddress,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF999999),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.copy,
                      size: 14,
                      color: Color(0xFF999999),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F0F0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.remove,
                        size: 12,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text(
                      'UID: ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF999999),
                      ),
                    ),
                    Text(
                      state.user.id.padLeft(8, '0'),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF999999),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.copy,
                      size: 14,
                      color: Color(0xFF999999),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOptions(BuildContext context) {
    final options = [
      {
        'icon': Icons.card_giftcard,
        'title': '邀请好友',
        'subtitle': '邀请好友赚佣金',
        'trailing': '💰',
        'hasArrow': true,
      },
      {
        'icon': Icons.security,
        'title': '安全设置',
        'hasArrow': true,
      },
      {
        'icon': Icons.account_balance_wallet,
        'title': '钱包管理',
        'hasArrow': true,
      },
      {
        'icon': Icons.tune,
        'title': '偏好设置',
        'hasArrow': true,
      },
      {
        'icon': Icons.notifications,
        'title': '消息设置',
        'trailing': '已关闭',
        'hasArrow': true,
      },
      {
        'icon': Icons.help_outline,
        'title': '帮助与反馈',
        'hasArrow': true,
      },
      {
        'icon': Icons.info_outline,
        'title': '关于我们',
        'trailing': '1.1.1.21(1010121)',
        'hasArrow': true,
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: options
            .map((option) => _buildSettingItem(
                  context,
                  icon: option['icon'] as IconData,
                  title: option['title'] as String,
                  subtitle: option['subtitle'] as String?,
                  trailing: option['trailing'] as String?,
                  hasArrow: option['hasArrow'] as bool? ?? false,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    String? trailing,
    bool hasArrow = false,
  }) {
    return InkWell(
      onTap: () {
        _handleSettingTap(context, title);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: const Color(0xFF333333),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              Text(
                trailing,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF999999),
                ),
              ),
              const SizedBox(width: 8),
            ],
            if (hasArrow)
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: Color(0xFF999999),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisconnectButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () => _showLogoutDialog(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.red,
          elevation: 0,
          side: const BorderSide(color: Color(0xFFE5E5E5)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          '断开连接',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _handleSettingTap(BuildContext context, String title) {
    // 处理各个设置项的点击事件
    switch (title) {
      case '邀请好友':
        _showInviteFriends(context);
        break;
      case '安全设置':
        _showSecuritySettings(context);
        break;
      case '钱包管理':
        _showWalletManagement(context);
        break;
      case '偏好设置':
        _showPreferences(context);
        break;
      case '消息设置':
        _showNotificationSettings(context);
        break;
      case '帮助与反馈':
        _showHelpAndFeedback(context);
        break;
      case '关于我们':
        _showAboutUs(context);
        break;
    }
  }

  void _showInviteFriends(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('邀请好友功能开发中...')),
    );
  }

  void _showSecuritySettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('安全设置功能开发中...')),
    );
  }

  void _showWalletManagement(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('钱包管理功能开发中...')),
    );
  }

  void _showPreferences(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('偏好设置功能开发中...')),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('消息设置功能开发中...')),
    );
  }

  void _showHelpAndFeedback(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('帮助与反馈功能开发中...')),
    );
  }

  void _showAboutUs(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('关于我们'),
        content: const Text(
          'GMGN App\n'
          '版本: 1.1.1.21(1010121)\n'
          '更快发现，秒级交易\n'
          '快速链上操作，一键交易；自动止盈止损。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认退出'),
        content: const Text('确定要断开连接并退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '取消',
              style: TextStyle(color: Color(0xFF999999)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 关闭对话框
              Navigator.pop(context); // 返回上一页
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
            child: const Text(
              '确定',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

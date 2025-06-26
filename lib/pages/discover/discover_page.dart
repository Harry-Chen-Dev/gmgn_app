import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/discover/discover_bloc.dart';
import '../../bloc/discover/discover_event.dart';
import '../../bloc/discover/discover_state.dart';
import '../../models/token.dart';
import '../auth/login_page.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _authService.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    _authService.removeListener(_onAuthStateChanged);
    super.dispose();
  }

  void _onAuthStateChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _authService.isLoggedIn
            ? _buildLoggedInContent()
            : _buildLoggedOutContent(),
      ),
    );
  }

  Widget _buildLoggedOutContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(
            height: MediaQuery.of(context).size.height - 200, // 给底部留空间
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 宣传内容
                const Text(
                  '更快发现，秒级交易 🚀',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    '快速链上操作，一键交易；自动止盈止损。',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 40),

                // 登录注册按钮
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () => _navigateToRegister(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFDDDDDD)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              '注册',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () => _navigateToLogin(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00C851),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              '登录',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildTabSection(),
          _buildFilterSection(),
          SizedBox(
            height: 400, // 固定高度给代币列表
            child: _buildTokenList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedInContent() {
    return Column(
      children: [
        _buildHeader(),
        _buildBalanceSection(),
        _buildActionButtons(),
        _buildTabSection(),
        _buildFilterSection(),
        Expanded(child: _buildTokenList()),
        _buildBottomBanner(),
      ],
    );
  }

  void _navigateToLogin() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
    if (result == true) {
      // 登录成功后自动刷新页面
      setState(() {});
    }
  }

  void _navigateToRegister() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
    if (result == true) {
      // 注册成功后自动刷新页面
      setState(() {});
    }
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image.asset(
                'assets/images/gmgn_avatar.png',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00C851),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.person, color: Colors.white, size: 20),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                  SizedBox(width: 16),
                  Icon(Icons.search, color: Color(0xFF999999), size: 20),
                  SizedBox(width: 8),
                  Text(
                    '搜索代币/钱包',
                    style: TextStyle(color: Color(0xFF999999), fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.qr_code_scanner,
                color: Color(0xFF333333), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF9945FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'S',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text('SOL',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              const Text('总余额',
                  style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
              const SizedBox(width: 4),
              const Icon(Icons.visibility_off_outlined,
                  size: 16, color: Color(0xFF999999)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Color(0xFF999999)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '≈ 0.0028205',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const Row(
            children: [
              Icon(Icons.attach_money, size: 16, color: Color(0xFF666666)),
              Text('SOL',
                  style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(Icons.arrow_downward, '充值'),
              _buildActionButton(Icons.arrow_upward, '提现'),
              _buildActionButtonWithBadge(Icons.credit_card, '法币买币', 'HOT'),
              _buildActionButton(Icons.card_giftcard, '邀请好友'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(icon, color: const Color(0xFF333333), size: 24),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF333333))),
      ],
    );
  }

  Widget _buildActionButtonWithBadge(
      IconData icon, String label, String badge) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, color: const Color(0xFF333333), size: 24),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF333333))),
      ],
    );
  }

  Widget _buildTabSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildTab('自选列表', true),
          _buildTab('战绩', false),
          _buildTab('新币', false),
          _buildTab('热门', false),
          _buildTab('监控广场', false),
          const Spacer(),
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFF333333),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.expand_more, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isSelected ? const Color(0xFF00C851) : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? const Color(0xFF00C851) : const Color(0xFF666666),
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          _buildFilterChip('新创建', true),
          _buildFilterChip('即将打满', false),
          _buildFilterChip('飙升', false),
          _buildFilterChip('已开盘', false),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.filter_list, size: 16, color: Color(0xFF666666)),
              const SizedBox(width: 4),
              const Text('筛选',
                  style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
              const SizedBox(width: 8),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    const Icon(Icons.whatshot, color: Colors.white, size: 12),
              ),
              const SizedBox(width: 4),
              const Text('暂停',
                  style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF666666),
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildTokenList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildTokenItem(index);
      },
    );
  }

  Widget _buildTokenItem(int index) {
    final tokens = [
      {
        'name': 'Jew',
        'symbol': '3UQn...pump',
        'time': '10s',
        'holders': '3',
        'volume': '\$417.21',
        'marketCap': '\$4.74K',
        'percentage': '0%',
        'changes': ['0%', '0%', '0%'],
        'comments': '0',
        'devPercent': '100%',
        'action': '买入',
        'image': 'assets/images/gmgn_avatar.png',
      },
      {
        'name': 'STORAGE',
        'symbol': 'Eeeu...pump',
        'time': '15s',
        'holders': '5',
        'volume': '\$440.01',
        'marketCap': '\$4.07K',
        'percentage': '0%',
        'changes': ['3%', 'Run', '0%'],
        'comments': '2',
        'devPercent': '100%',
        'action': '买入',
        'image': 'assets/images/gmgn_avatar.png',
      },
      {
        'name': 'PWSWR',
        'symbol': '2gAv...pump',
        'time': '18s',
        'holders': '4',
        'volume': '\$2.32',
        'marketCap': '\$4.06K',
        'percentage': '0%',
        'changes': ['0%', '0%', '0%'],
        'comments': '2',
        'devPercent': '0%',
        'action': '买入',
        'image': 'assets/images/gmgn_avatar.png',
      },
      {
        'name': 'Kitler',
        'symbol': '9ujF...pump',
        'time': '20s',
        'holders': '8',
        'volume': '\$2.21K',
        'marketCap': '\$5.72K',
        'percentage': '21%',
        'changes': ['16%', '99%', '0%'],
        'comments': '7',
        'devPercent': '96%',
        'action': '买入',
        'image': 'assets/images/gmgn_avatar.png',
      },
      {
        'name': 'Reet',
        'symbol': '3s9T...pump',
        'time': '22s',
        'holders': '6',
        'volume': '\$1.89K',
        'marketCap': '\$3.45K',
        'percentage': '15%',
        'changes': ['8%', '45%', '2%'],
        'comments': '5',
        'devPercent': '88%',
        'action': '买入',
        'image': 'assets/images/gmgn_avatar.png',
      },
    ];

    final token = tokens[index % tokens.length];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Image.asset(
                    token['image'] as String,
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00C851),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.currency_bitcoin,
                            color: Colors.white, size: 16),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(token['name'] as String,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Text(token['symbol'] as String,
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF666666))),
                        const SizedBox(width: 8),
                        const Icon(Icons.copy,
                            size: 12, color: Color(0xFF999999)),
                        const SizedBox(width: 8),
                        const Icon(Icons.search,
                            size: 12, color: Color(0xFF999999)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(token['time'] as String,
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF00C851))),
                        const SizedBox(width: 12),
                        const Icon(Icons.person,
                            size: 12, color: Color(0xFF666666)),
                        const SizedBox(width: 2),
                        Text(token['holders'] as String,
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF666666))),
                        const SizedBox(width: 12),
                        Text('V ${token['volume']}',
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF666666))),
                        const SizedBox(width: 12),
                        Text('MC ${token['marketCap']}',
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF666666))),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: token['percentage'] == '0%'
                      ? const Color(0xFFF0F0F0)
                      : const Color(0xFF00C851),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  token['percentage'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: token['percentage'] == '0%'
                        ? const Color(0xFF666666)
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ...((token['changes'] as List<String>).map((change) => Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: change == 'Run'
                          ? Colors.red
                          : change == '0%'
                              ? const Color(0xFFF0F0F0)
                              : const Color(0xFF00C851),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      change,
                      style: TextStyle(
                        fontSize: 10,
                        color: change == '0%'
                            ? const Color(0xFF666666)
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))),
              const SizedBox(width: 8),
              const Icon(Icons.chat_bubble_outline,
                  size: 12, color: Color(0xFF666666)),
              const SizedBox(width: 2),
              Text(token['comments'] as String,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF666666))),
              const SizedBox(width: 12),
              const Icon(Icons.favorite_border,
                  size: 12, color: Color(0xFFFF6B9D)),
              const SizedBox(width: 2),
              Text(token['devPercent'] as String,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFFFF6B9D))),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00C851),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.flash_on, size: 12, color: Colors.white),
                    const SizedBox(width: 2),
                    Text(
                      token['action'] as String,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber, color: Color(0xFFFF8F00), size: 16),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              '当前链上余额不足，请充值后再进行操作',
              style: TextStyle(fontSize: 12, color: Color(0xFF663C00)),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              '去充值',
              style: TextStyle(fontSize: 12, color: Color(0xFF00C851)),
            ),
          ),
        ],
      ),
    );
  }
}

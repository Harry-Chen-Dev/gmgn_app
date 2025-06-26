import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth/login_page.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/assets/assets_bloc.dart';

class AssetsPage extends StatefulWidget {
  const AssetsPage({super.key});

  @override
  State<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> with TickerProviderStateMixin {
  bool isBalanceVisible = true;
  int selectedAnalysisTab = 0;
  List<String> analysisTabs = ['PnL', '分析', '盈利分布', '钓鱼检测'];
  late TabController _portfolioTabController;

  @override
  void initState() {
    super.initState();
    _portfolioTabController = TabController(length: 2, vsync: this);
    _portfolioTabController.addListener(() {
      setState(() {}); // 重建UI以更新标签状态
    });
    // 加载资产数据
    context.read<AssetsBloc>().add(LoadAssets());
  }

  @override
  void dispose() {
    _portfolioTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return _buildLoggedInContent(state);
            } else {
              return _buildLoggedOutContent();
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoggedOutContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            const Text(
              '请先登录查看资产',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '登录后即可查看您的数字资产详情',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
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
                  '立即登录',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoggedInContent(AuthAuthenticated state) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildUserHeader(state),
                _buildBalanceSection(state),
                _buildActionButtons(),
                _buildAnalysisSection(),
                _buildStatsSection(),
                _buildPortfolioSection(),
              ],
            ),
          ),
        ];
      },
      body: _buildPortfolioContent(),
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

  Widget _buildUserHeader(AuthAuthenticated state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // 用户头像
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image.asset(
                'assets/images/gmgn_avatar.png',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00C851),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.person, color: Colors.white, size: 24),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          // 用户信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.user.walletAddress,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '粉丝 ${state.user.followers}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          // 右侧图标
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.copy,
                  size: 16,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.menu,
                  size: 16,
                  color: Color(0xFF666666),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.school,
                      size: 16,
                      color: Colors.white,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '教程',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.refresh,
                  size: 16,
                  color: Color(0xFF666666),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSection(AuthAuthenticated state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'SOL',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: Color(0xFF666666),
              ),
              const Spacer(),
              const Text(
                '总余额',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isBalanceVisible = !isBalanceVisible;
                  });
                },
                child: Icon(
                  isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                  size: 16,
                  color: const Color(0xFF666666),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isBalanceVisible
                ? '≈ ${state.user.solBalance.toStringAsFixed(7)}'
                : '≈ ****',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isBalanceVisible ? 'SOL' : '***',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            icon: Icons.arrow_downward,
            label: '充值',
            onTap: () {},
          ),
          _buildActionButton(
            icon: Icons.arrow_upward,
            label: '提现',
            onTap: () {},
          ),
          _buildActionButton(
            icon: Icons.credit_card,
            label: '法币买币',
            hasHotTag: true,
            onTap: () {},
          ),
          _buildActionButton(
            icon: Icons.card_giftcard,
            label: '邀请好友',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    bool hasHotTag = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: const Color(0xFF333333),
                ),
              ),
              if (hasHotTag)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4444),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'HOT',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: analysisTabs.asMap().entries.map((entry) {
                  int index = entry.key;
                  String tab = entry.value;
                  bool isSelected = selectedAnalysisTab == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAnalysisTab = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF333333)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tab,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF999999),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '7d',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: Color(0xFF666666),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStatRow('总盈亏', '-0.145 SOL(-79.76%)', isNegative: true),
          _buildStatRow('未实现利润', '-- SOL'),
          _buildStatRow('7d 平均持仓时长', '--'),
          _buildStatRow('7d 买入总成本', '-- SOL'),
          _buildStatRow('7d 代币平均买入成本', '-- SOL'),
          _buildStatRow('7d 代币平均实现利润', '-- SOL'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {bool isNegative = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isNegative
                  ? const Color(0xFFFF4444)
                  : const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortfolioSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // 持有代币/活动 切换
          Row(
            children: [
              GestureDetector(
                onTap: () => _portfolioTabController.animateTo(0),
                child: Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: _portfolioTabController.index == 0
                        ? const Border(
                            bottom:
                                BorderSide(color: Color(0xFF333333), width: 2),
                          )
                        : null,
                  ),
                  child: Text(
                    '持有代币',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: _portfolioTabController.index == 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _portfolioTabController.index == 0
                          ? const Color(0xFF333333)
                          : const Color(0xFF999999),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () => _portfolioTabController.animateTo(1),
                child: Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: _portfolioTabController.index == 1
                        ? const Border(
                            bottom:
                                BorderSide(color: Color(0xFF333333), width: 2),
                          )
                        : null,
                  ),
                  child: Text(
                    '活动',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: _portfolioTabController.index == 1
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: _portfolioTabController.index == 1
                          ? const Color(0xFF333333)
                          : const Color(0xFF999999),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // U闪兑按钮
              Stack(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'U 闪兑',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF4444),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 排序和筛选
          Row(
            children: [
              const Text(
                '排序：',
                style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
              const Text(
                '最后活跃 从高到低',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333)),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down,
                  size: 16, color: Color(0xFF666666)),
              const Spacer(),
              const Icon(Icons.tune, size: 16, color: Color(0xFF666666)),
              const SizedBox(width: 4),
              const Text(
                '筛选',
                style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTokenList() {
    final List<Map<String, dynamic>> tokens = [
      {
        'symbol': 'USDC',
        'name': 'USD Coin',
        'icon': Icons.monetization_on,
        'lastActive': '39d',
        'balance': '0.542518 SOL',
        'quantity': '416.5',
        'avgBuyPrice': '0.00599 SOL',
        'avgBuyValue': '\$0.00208',
        'totalProfit': '-0.0₁₁₄ SOL(-96.38%)',
        'unrealizedProfit': '-0.0₁₁₄ SOL(-96.38%)',
        'isNegative': true,
      },
      {
        'symbol': 'CASEY',
        'name': 'Casey Token',
        'icon': Icons.psychology,
        'lastActive': '41d',
        'balance': '-- SOL',
        'quantity': '--',
        'avgBuyPrice': '-- SOL',
        'avgBuyValue': '--',
        'totalProfit': '-- SOL',
        'unrealizedProfit': '-- SOL',
        'isNegative': false,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tokens.length,
      itemBuilder: (context, index) {
        final token = tokens[index];
        return _buildTokenItem(token);
      },
    );
  }

  Widget _buildTokenItem(Map<String, dynamic> token) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // 代币头部信息
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  token['icon'],
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          token['symbol'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.copy,
                            size: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '最后活跃: ${token['lastActive']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.share, size: 16, color: Color(0xFF666666)),
                  const SizedBox(width: 8),
                  const Text(
                    '分享',
                    style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '更多',
                    style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.more_vert,
                      size: 16, color: Color(0xFF666666)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 代币详细数据
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '余额 ⊙ / 数量',
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      token['balance'],
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      token['quantity'],
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '总买入 / 平均',
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      token['avgBuyPrice'],
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      token['avgBuyValue'],
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      '总利润 / 未实现利润',
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      token['totalProfit'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: token['isNegative']
                            ? const Color(0xFFFF4444)
                            : const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      token['unrealizedProfit'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: token['isNegative']
                            ? const Color(0xFFFF4444)
                            : const Color(0xFF333333),
                      ),
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

  Widget _buildPortfolioContent() {
    return TabBarView(
      controller: _portfolioTabController,
      children: [
        _buildTokenList(), // 持有代币列表
        _buildActivityList(), // 活动列表
      ],
    );
  }

  Widget _buildActivityList() {
    final List<Map<String, dynamic>> activities = [
      {
        'symbol': 'USDC',
        'icon': Icons.monetization_on,
        'type': '买入',
        'time': '05/17 03:28:58',
        'quantity': '416.5',
        'price': '\$0.0409',
        'total': '0.0₁₁715 SOL',
        'profit': '--',
        'profitColor': const Color(0xFF999999),
        'isBuy': true,
      },
      {
        'symbol': 'CASEY',
        'icon': Icons.psychology,
        'type': '卖出',
        'time': '05/15 11:26:57',
        'quantity': '1.7713K',
        'price': '\$0.0218',
        'total': '0.0₃₂6602 SOL',
        'profit': '-\$1.01',
        'profitColor': const Color(0xFFFF4444),
        'isBuy': false,
      },
      {
        'symbol': 'CASEY',
        'icon': Icons.psychology,
        'type': '买入',
        'time': '05/15 11:26:30',
        'quantity': '1.7784K',
        'price': '\$0.0499',
        'total': '0.0012101 SOL',
        'profit': '--',
        'profitColor': const Color(0xFF999999),
        'isBuy': true,
      },
      {
        'symbol': 'Morphiese',
        'icon': Icons.psychology_alt,
        'type': '卖出',
        'time': '05/15 11:24:25',
        'quantity': '21.087K',
        'price': '\$0.0673',
        'total': '0.0₃₉7525 SOL',
        'profit': '-\$0.163',
        'profitColor': const Color(0xFFFF4444),
        'isBuy': false,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        return _buildActivityItem(activity);
      },
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // 活动头部信息
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  activity['icon'],
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          activity['symbol'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.copy,
                            size: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: activity['isBuy']
                                ? const Color(0xFF00C851)
                                : const Color(0xFFFF4444),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            activity['type'],
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          activity['time'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    '利润',
                    style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activity['profit'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: activity['profitColor'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 活动详细数据
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '数量',
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity['quantity'],
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '价格',
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity['price'],
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          '总额 ',
                          style:
                              TextStyle(fontSize: 12, color: Color(0xFF999999)),
                        ),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: const Icon(
                            Icons.remove_red_eye,
                            size: 10,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity['total'],
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333)),
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
}

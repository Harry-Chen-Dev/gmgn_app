import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/discover/discover_bloc.dart';
import '../../bloc/discover/discover_event.dart';
import '../../bloc/discover/discover_state.dart';
import '../../models/token.dart';
import '../auth/login_page.dart';
import '../settings/settings_page.dart';

class DiscoverPageBloc extends StatefulWidget {
  const DiscoverPageBloc({super.key});

  @override
  State<DiscoverPageBloc> createState() => _DiscoverPageBlocState();
}

class _DiscoverPageBlocState extends State<DiscoverPageBloc> {
  @override
  void initState() {
    super.initState();
    // 初始化时加载代币数据
    context.read<DiscoverBloc>().add(const DiscoverLoadTokens());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is AuthAuthenticated) {
              return _buildLoggedInContent();
            } else {
              return _buildLoggedOutContent();
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoggedOutContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
            height: 400,
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
      setState(() {});
    }
  }

  void _navigateToRegister() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
    if (result == true) {
      setState(() {});
    }
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // 检查登录状态，如果已登录则跳转到设置页面
              final authState = context.read<AuthBloc>().state;
              if (authState is AuthAuthenticated) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              } else {
                // 未登录则跳转到登录页面
                _navigateToLogin();
              }
            },
            child: CircleAvatar(
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
                      child: const Icon(Icons.person,
                          color: Colors.white, size: 20),
                    );
                  },
                ),
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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('SOL',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    const Text('总余额',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF666666))),
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
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildActionButtons() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '≈ ${state.user.solBalance.toStringAsFixed(7)}',
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const Row(
                  children: [
                    Icon(Icons.attach_money,
                        size: 16, color: Color(0xFF666666)),
                    Text('SOL',
                        style:
                            TextStyle(fontSize: 14, color: Color(0xFF666666))),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(Icons.arrow_downward, '充值'),
                    _buildActionButton(Icons.arrow_upward, '提现'),
                    _buildActionButtonWithBadge(
                        Icons.credit_card, '法币买币', 'HOT'),
                    _buildActionButton(Icons.card_giftcard, '邀请好友'),
                  ],
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
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
    return BlocBuilder<DiscoverBloc, DiscoverState>(
      builder: (context, state) {
        String currentTab = 'watchlist';
        if (state is DiscoverLoaded) {
          currentTab = state.currentTab;
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _buildTab('自选列表', currentTab == 'watchlist', 'watchlist'),
              _buildTab('战绩', currentTab == 'records', 'records'),
              _buildTab('新币', currentTab == 'new_coins', 'new_coins'),
              _buildTab('热门', currentTab == 'hot', 'hot'),
              _buildTab('监控广场', currentTab == 'monitor', 'monitor'),
              const Spacer(),
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFF333333),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.expand_more,
                    color: Colors.white, size: 16),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTab(String title, bool isSelected, String tabKey) {
    return GestureDetector(
      onTap: () {
        context.read<DiscoverBloc>().add(DiscoverTabChanged(tab: tabKey));
      },
      child: Container(
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
            color:
                isSelected ? const Color(0xFF00C851) : const Color(0xFF666666),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return BlocBuilder<DiscoverBloc, DiscoverState>(
      builder: (context, state) {
        String currentFilter = 'new_created';
        if (state is DiscoverLoaded) {
          currentFilter = state.currentFilter;
        }

        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              _buildFilterChip(
                  '新创建', currentFilter == 'new_created', 'new_created'),
              _buildFilterChip(
                  '即将打满', currentFilter == 'nearly_full', 'nearly_full'),
              _buildFilterChip('飙升', currentFilter == 'surge', 'surge'),
              _buildFilterChip('已开盘', currentFilter == 'listed', 'listed'),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.filter_list,
                      size: 16, color: Color(0xFF666666)),
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
                    child: const Icon(Icons.whatshot,
                        color: Colors.white, size: 12),
                  ),
                  const SizedBox(width: 4),
                  const Text('暂停',
                      style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, String filterKey) {
    return GestureDetector(
      onTap: () {
        context
            .read<DiscoverBloc>()
            .add(DiscoverFilterChanged(filter: filterKey));
      },
      child: Container(
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
      ),
    );
  }

  Widget _buildTokenList() {
    return BlocBuilder<DiscoverBloc, DiscoverState>(
      builder: (context, state) {
        if (state is DiscoverLoading) {
          return const Center(
              child: CircularProgressIndicator(color: Color(0xFF00C851)));
        } else if (state is DiscoverLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<DiscoverBloc>().add(const DiscoverRefreshTokens());
            },
            child: ListView.builder(
              itemCount: state.tokens.length,
              itemBuilder: (context, index) {
                return _buildTokenItem(state.tokens[index]);
              },
            ),
          );
        } else if (state is DiscoverError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<DiscoverBloc>()
                        .add(const DiscoverLoadTokens());
                  },
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }
        return const Center(child: Text('暂无数据'));
      },
    );
  }

  Widget _buildTokenItem(Token token) {
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
                    token.imageUrl,
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
                        Text(token.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Text(token.symbol,
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
                        Text(token.timeAgo,
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF00C851))),
                        const SizedBox(width: 12),
                        const Icon(Icons.person,
                            size: 12, color: Color(0xFF666666)),
                        const SizedBox(width: 2),
                        Text('${token.holders}',
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF666666))),
                        const SizedBox(width: 12),
                        Text('V \$${token.volume24h.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 12, color: Color(0xFF666666))),
                        const SizedBox(width: 12),
                        Text(
                            'MC \$${(token.marketCap / 1000).toStringAsFixed(1)}K',
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
                  color: token.priceChange24h == 0
                      ? const Color(0xFFF0F0F0)
                      : const Color(0xFF00C851),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${token.priceChange24h.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: token.priceChange24h == 0
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
              ...token.priceChanges.map((change) => Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: change == 0
                          ? const Color(0xFFF0F0F0)
                          : const Color(0xFF00C851),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${change.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 10,
                        color: change == 0
                            ? const Color(0xFF666666)
                            : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )),
              const SizedBox(width: 8),
              const Icon(Icons.chat_bubble_outline,
                  size: 12, color: Color(0xFF666666)),
              const SizedBox(width: 2),
              Text('${token.comments}',
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF666666))),
              const SizedBox(width: 12),
              const Icon(Icons.favorite_border,
                  size: 12, color: Color(0xFFFF6B9D)),
              const SizedBox(width: 2),
              Text('${token.devPercent.toStringAsFixed(0)}%',
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
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.flash_on, size: 12, color: Colors.white),
                    SizedBox(width: 2),
                    Text('买入',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
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
            child: const Text('去充值',
                style: TextStyle(fontSize: 12, color: Color(0xFF00C851))),
          ),
        ],
      ),
    );
  }
}

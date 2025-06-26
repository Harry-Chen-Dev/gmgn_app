import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/experts/experts_bloc.dart';
import '../../models/expert.dart';

class ExpertsPage extends StatefulWidget {
  const ExpertsPage({super.key});

  @override
  State<ExpertsPage> createState() => _ExpertsPageState();
}

class _ExpertsPageState extends State<ExpertsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int selectedTabIndex = 0; // 用于牛人榜内部的Tab
  int currentMainTabIndex = 0; // 用于顶部主Tab（牛人榜/钱包跟单）
  final List<String> tabs = ['全部', 'Pump聪明钱', '聪明钱', '新钱包', 'KOL/VC'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging ||
        _tabController.index != currentMainTabIndex) {
      setState(() {
        currentMainTabIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpertsBloc()..add(LoadExperts()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildExpertsListPage(),
                    _buildWalletFollowPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              _tabController.animateTo(0);
              setState(() {
                currentMainTabIndex = 0;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '牛人榜',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: currentMainTabIndex == 0
                          ? const Color(0xFF333333)
                          : const Color(0xFF999999)),
                ),
                if (currentMainTabIndex == 0)
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 40,
                    height: 3,
                    decoration: BoxDecoration(
                      color: const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              _tabController.animateTo(1);
              setState(() {
                currentMainTabIndex = 1;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '钱包跟单',
                  style: TextStyle(
                    fontSize: 16,
                    color: currentMainTabIndex == 1
                        ? const Color(0xFF333333)
                        : const Color(0xFF999999),
                    fontWeight: currentMainTabIndex == 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                if (currentMainTabIndex == 1)
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 60,
                    height: 3,
                    decoration: BoxDecoration(
                      color: const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.search, color: Color(0xFF999999), size: 24),
              if (currentMainTabIndex == 1) ...[
                const SizedBox(width: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF333333),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('创建',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // 牛人榜页面
  Widget _buildExpertsListPage() {
    return Column(
      children: [
        _buildExpertsTabSection(),
        _buildFilterSection(),
        Expanded(child: _buildExpertsList()),
      ],
    );
  }

  Widget _buildExpertsTabSection() {
    return Container(
      height: 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            int index = entry.key;
            String tab = entry.value;
            bool isSelected = selectedTabIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() => selectedTabIndex = index);
                // 根据选择的tab筛选专家
                String filterType = 'all';
                switch (index) {
                  case 0:
                    filterType = 'all';
                    break;
                  case 1:
                    filterType = 'pump_smart';
                    break;
                  case 2:
                    filterType = 'smart_money';
                    break;
                  case 3:
                    filterType = 'new_wallet';
                    break;
                  case 4:
                    filterType = 'kol_vc';
                    break;
                }
                context
                    .read<ExpertsBloc>()
                    .add(FilterExpertsByType(filterType));
              },
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xFF333333) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF999999),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          const Text('周期：',
              style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
          const Text('7D',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333))),
          const SizedBox(width: 20),
          const Text('排序：',
              style: TextStyle(fontSize: 14, color: Color(0xFF666666))),
          Row(
            children: [
              const Text('PnL 从高到低',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333))),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down,
                  color: Color(0xFF666666), size: 20),
            ],
          ),
          const Spacer(),
          const Icon(Icons.tune, color: Color(0xFF999999), size: 20),
          const SizedBox(width: 8),
          const Text('筛选',
              style: TextStyle(fontSize: 14, color: Color(0xFF999999))),
        ],
      ),
    );
  }

  Widget _buildExpertsList() {
    return BlocBuilder<ExpertsBloc, ExpertsState>(
      builder: (context, state) {
        if (state is ExpertsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ExpertsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<ExpertsBloc>().add(LoadExperts());
                  },
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        } else if (state is ExpertsLoaded) {
          final experts = state.experts;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: experts.length,
            itemBuilder: (context, index) {
              return _buildExpertItemFromModel(experts[index]);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildExpertItem(int index) {
    final List<Map<String, dynamic>> expertData = [
      {
        'rank': 1,
        'address': 'AdBd...vwdq',
        'balance': '0.404',
        'profit': '+\$699.05',
        'profitPercent': '+20K% PnL',
        'followers': '14',
        'trades': '6 (5/1)/100%',
        'lastActive': '1h以前',
        'rankColor': const Color(0xFFFFD700), // 金色
      },
      {
        'rank': 2,
        'address': 'A4aV..YKBA',
        'balance': '0.1',
        'profit': '+\$6.39K',
        'profitPercent': '+16.66K% PnL',
        'followers': '178',
        'trades': '3 (1/2)/100%',
        'lastActive': '2d以前',
        'rankColor': const Color(0xFFC0C0C0), // 银色
      },
      {
        'rank': 3,
        'address': 'C7gh...52Em',
        'balance': '0',
        'profit': '+\$5.83K',
        'profitPercent': '+13.91K% PnL',
        'followers': '50',
        'trades': '4 (1/3)/100%',
        'lastActive': '1d以前',
        'rankColor': const Color(0xFFCD7F32), // 铜色
      },
      {
        'rank': 4,
        'address': '7Ep1...dBcQ',
        'balance': '0',
        'profit': '+\$5.74K',
        'profitPercent': '+13.55K% PnL',
        'followers': '55',
        'trades': '5 (1/4)/100%',
        'lastActive': '2d以前',
        'rankColor': const Color(0xFFF5F5F5), // 普通排名
      },
      {
        'rank': 5,
        'address': 'J4Pc...RfNW',
        'balance': '0.2',
        'profit': '+\$12.09K',
        'profitPercent': '+24.18K% PnL',
        'followers': '89',
        'trades': '7 (2/5)/100%',
        'lastActive': '3h以前',
        'rankColor': const Color(0xFFF5F5F5), // 普通排名
      },
    ];

    final data = expertData[index % expertData.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // 排名标识
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: data['rankColor'],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  data['rank'] == 1
                      ? '1st'
                      : data['rank'] == 2
                          ? '2nd'
                          : data['rank'] == 3
                              ? '3rd'
                              : '${data['rank']}th',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: data['rank'] <= 3
                        ? Colors.white
                        : const Color(0xFF666666),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 头像
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
                        child: const Icon(Icons.person,
                            color: Colors.white, size: 20),
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
                    Row(
                      children: [
                        Text(
                          data['address'],
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333)),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.edit,
                            size: 16, color: Color(0xFF999999)),
                        const SizedBox(width: 4),
                        const Icon(Icons.copy,
                            size: 16, color: Color(0xFF999999)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: const Color(0xFF9945FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'S',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          data['balance'],
                          style: const TextStyle(
                              fontSize: 14, color: Color(0xFF333333)),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.help_outline,
                            size: 14, color: Color(0xFF999999)),
                      ],
                    ),
                  ],
                ),
              ),
              // 盈亏数据
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    data['profit'],
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00C851)),
                  ),
                  Text(
                    data['profitPercent'],
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 统计信息
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('粉丝',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    const SizedBox(height: 4),
                    Text(data['followers'],
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333))),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('交易数/胜率',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    const SizedBox(height: 4),
                    Text(data['trades'],
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333))),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('最后活动',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    const SizedBox(height: 4),
                    Text(data['lastActive'],
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 操作按钮
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_outlined,
                          color: Color(0xFF666666), size: 18),
                      SizedBox(width: 4),
                      Text('跟单',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF333333),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star_border, color: Colors.white, size: 18),
                      SizedBox(width: 4),
                      Text('关注',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpertItemFromModel(Expert expert) {
    Color getRankColor(int rank) {
      switch (rank) {
        case 1:
          return const Color(0xFFFFD700); // 金色
        case 2:
          return const Color(0xFFC0C0C0); // 银色
        case 3:
          return const Color(0xFFCD7F32); // 铜色
        default:
          return const Color(0xFFF5F5F5); // 普通排名
      }
    }

    String getRankText(int rank) {
      switch (rank) {
        case 1:
          return '1st';
        case 2:
          return '2nd';
        case 3:
          return '3rd';
        default:
          return '${rank}th';
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // 排名标识
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: getRankColor(expert.rank),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  getRankText(expert.rank),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: expert.rank <= 3
                        ? Colors.white
                        : const Color(0xFF666666),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 头像
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Image.asset(
                    expert.avatarUrl,
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
              const SizedBox(width: 12),
              // 用户信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          expert.walletAddress,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333)),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.edit,
                            size: 16, color: Color(0xFF999999)),
                        const SizedBox(width: 4),
                        const Icon(Icons.copy,
                            size: 16, color: Color(0xFF999999)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: const Color(0xFF9945FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'S',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          expert.solBalance.toStringAsFixed(3),
                          style: const TextStyle(
                              fontSize: 14, color: Color(0xFF333333)),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.help_outline,
                            size: 14, color: Color(0xFF999999)),
                      ],
                    ),
                  ],
                ),
              ),
              // 盈亏数据
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '+\$${expert.pnl.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00C851)),
                  ),
                  Text(
                    '+${expert.pnlPercentage.toStringAsFixed(1)}% PnL',
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xFF999999)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 统计信息
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('粉丝',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    const SizedBox(height: 4),
                    Text(expert.followers.toString(),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333))),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('交易数/胜率',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    const SizedBox(height: 4),
                    Text(
                        '${expert.totalTrades} (${(expert.totalTrades * expert.winRate / 100).round()}/${expert.totalTrades - (expert.totalTrades * expert.winRate / 100).round()})/${expert.winRate.toStringAsFixed(0)}%',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333))),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('最后活动',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    const SizedBox(height: 4),
                    Text(expert.lastActivity,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 操作按钮
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_outlined,
                          color: Color(0xFF666666), size: 18),
                      SizedBox(width: 4),
                      Text('跟单',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    context.read<ExpertsBloc>().add(ToggleFollow(expert.id));
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: expert.isFollowing
                          ? const Color(0xFFF5F5F5)
                          : const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            expert.isFollowing ? Icons.star : Icons.star_border,
                            color: expert.isFollowing
                                ? const Color(0xFF666666)
                                : Colors.white,
                            size: 18),
                        const SizedBox(width: 4),
                        Text(expert.isFollowing ? '已关注' : '关注',
                            style: TextStyle(
                                fontSize: 14,
                                color: expert.isFollowing
                                    ? const Color(0xFF666666)
                                    : Colors.white,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 钱包跟单页面
  Widget _buildWalletFollowPage() {
    return BlocBuilder<ExpertsBloc, ExpertsState>(
      builder: (context, state) {
        if (state is ExpertsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ExpertsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<ExpertsBloc>().add(LoadWalletFollows());
                  },
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        } else if (state is ExpertsLoaded) {
          final walletFollows = state.walletFollows;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: walletFollows.length,
            itemBuilder: (context, index) {
              return _buildFollowItemFromModel(walletFollows[index]);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFollowItem(int index) {
    final List<Map<String, dynamic>> followData = [
      {
        'name': 'lucy...n',
        'address': '81ns...6Ulu',
        'badge': '🔴',
        'hasClosed': true,
        'totalBuy': '--',
        'totalSell': '--',
        'profit': '--',
        'profitColor': const Color(0xFF999999),
        'followBuy': '0',
        'followSell': '0',
        'lastTrade': '--',
        'avatar': 'https://example.com/avatar1.png',
      },
      {
        'name': 'Pain',
        'address': 'HAN6...96q6',
        'badge': '',
        'hasClosed': true,
        'totalBuy': '0.35',
        'totalSell': '0.141',
        'profit': '-\$0.0324(-18.63%)',
        'profitColor': const Color(0xFFFF4444),
        'followBuy': '2',
        'followSell': '1',
        'lastTrade': '41天前',
        'avatar': 'https://example.com/avatar2.png',
      },
      {
        'name': 'gake',
        'address': 'DNfu...eBHm',
        'badge': '',
        'hasClosed': true,
        'totalBuy': '--',
        'totalSell': '--',
        'profit': '--',
        'profitColor': const Color(0xFF999999),
        'followBuy': '0',
        'followSell': '0',
        'lastTrade': '--',
        'avatar': 'https://example.com/avatar3.png',
      },
      {
        'name': 'trader4',
        'address': '6YHc...DYXr',
        'badge': '',
        'hasClosed': false,
        'totalBuy': '1.25',
        'totalSell': '0.80',
        'profit': '+\$0.125(+12.5%)',
        'profitColor': const Color(0xFF00C851),
        'followBuy': '3',
        'followSell': '2',
        'lastTrade': '2小时前',
        'avatar': 'https://example.com/avatar4.png',
      },
    ];

    final data = followData[index % followData.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
      ),
      child: Column(
        children: [
          // 用户信息行
          Row(
            children: [
              // 头像
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB6C1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/images/gmgn_avatar.png',
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB6C1),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(Icons.person,
                            color: Colors.white, size: 24),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 用户名和地址
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          data['name'],
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333)),
                        ),
                        if (data['badge'].isNotEmpty) ...[
                          const SizedBox(width: 4),
                          Text(data['badge'],
                              style: const TextStyle(fontSize: 12)),
                        ],
                        const SizedBox(width: 8),
                        const Icon(Icons.edit,
                            size: 16, color: Color(0xFF999999)),
                        const SizedBox(width: 8),
                        if (data['hasClosed'])
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5E5E5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('已关单',
                                style: TextStyle(
                                    fontSize: 10, color: Color(0xFF666666))),
                          ),
                        const SizedBox(width: 8),
                        const Icon(Icons.copy,
                            size: 16, color: Color(0xFF999999)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data['address'],
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF999999)),
                    ),
                  ],
                ),
              ),
              // 跟单详情
              const Row(
                children: [
                  Text('跟单详情',
                      style: TextStyle(fontSize: 14, color: Color(0xFF999999))),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right, color: Color(0xFF999999), size: 16),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 交易数据行
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('总买入',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    const SizedBox(height: 4),
                    Text(
                      data['totalBuy'],
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('总卖出',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    const SizedBox(height: 4),
                    Text(
                      data['totalSell'],
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('已实现利润',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    const SizedBox(height: 4),
                    Text(
                      data['profit'],
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: data['profitColor']),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 统计信息行
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('跟单买/卖',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          data['followBuy'],
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF00C851)),
                        ),
                        const Text(' / ',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFF999999))),
                        Text(
                          data['followSell'],
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF4444)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('最近交易时间',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    const SizedBox(height: 4),
                    Text(
                      data['lastTrade'],
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 再次跟单按钮
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.copy, color: Color(0xFF666666), size: 18),
                SizedBox(width: 8),
                Text('再次跟单',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFollowItemFromModel(Expert expert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
      ),
      child: Column(
        children: [
          // 用户信息行
          Row(
            children: [
              // 头像
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB6C1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    expert.avatarUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB6C1),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(Icons.person,
                            color: Colors.white, size: 24),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 用户名和地址
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          expert.displayName ?? expert.walletAddress,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333)),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.edit,
                            size: 16, color: Color(0xFF999999)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E5E5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('已关单',
                              style: TextStyle(
                                  fontSize: 10, color: Color(0xFF666666))),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.copy,
                            size: 16, color: Color(0xFF999999)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      expert.walletAddress,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF999999)),
                    ),
                  ],
                ),
              ),
              // 跟单详情
              const Row(
                children: [
                  Text('跟单详情',
                      style: TextStyle(fontSize: 14, color: Color(0xFF999999))),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right, color: Color(0xFF999999), size: 16),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 交易数据行
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('总买入',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    const SizedBox(height: 4),
                    Text(
                      expert.totalTrades > 0
                          ? expert.totalTrades.toString()
                          : '--',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('总卖出',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    const SizedBox(height: 4),
                    Text(
                      expert.winRate > 0
                          ? expert.winRate.toInt().toString()
                          : '--',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('已实现利润',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    const SizedBox(height: 4),
                    Text(
                      expert.pnl > 0
                          ? '+\$${expert.pnl.toStringAsFixed(2)}(+${expert.pnlPercentage.toStringAsFixed(1)}%)'
                          : '--',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: expert.pnl > 0
                              ? const Color(0xFF00C851)
                              : const Color(0xFF999999)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 统计信息行
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('跟单买/卖',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          (expert.totalTrades * 0.6).toInt().toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF00C851)),
                        ),
                        const Text(' / ',
                            style: TextStyle(
                                fontSize: 16, color: Color(0xFF999999))),
                        Text(
                          (expert.totalTrades * 0.4).toInt().toString(),
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF4444)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('最近交易时间',
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF999999))),
                    const SizedBox(height: 4),
                    Text(
                      expert.lastActivity,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 再次跟单按钮
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.copy, color: Color(0xFF666666), size: 18),
                SizedBox(width: 8),
                Text('再次跟单',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

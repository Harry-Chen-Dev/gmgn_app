import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'pages/discover/discover_page_bloc.dart';
import 'pages/experts/experts_page.dart';
import 'pages/trade/trade_page.dart';
import 'pages/follow/follow_page.dart';
import 'pages/assets/assets_page.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/discover/discover_bloc.dart';
import 'bloc/experts/experts_bloc.dart';
import 'bloc/trade/trade_bloc.dart';
import 'bloc/assets/assets_bloc.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化认证服务
  await AuthService.initialize();

  runApp(const GMGNApp());
}

class GMGNApp extends StatelessWidget {
  const GMGNApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(const AuthCheckRequested()),
        ),
        BlocProvider<DiscoverBloc>(
          create: (context) => DiscoverBloc(),
        ),
        BlocProvider<ExpertsBloc>(
          create: (context) => ExpertsBloc(),
        ),
        BlocProvider<TradeBloc>(
          create: (context) => TradeBloc(),
        ),
        BlocProvider<AssetsBloc>(
          create: (context) => AssetsBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'GMGN',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00C851)),
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const MainPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DiscoverPageBloc(),
    const ExpertsPage(),
    const TradePage(),
    const FollowPage(),
    const AssetsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildCustomBottomNavBar(),
    );
  }

  Widget _buildCustomBottomNavBar() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E5E5), width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.explore, '发现'),
          _buildNavItem(1, Icons.trending_up, '牛人榜'),
          _buildCenterTradeButton(),
          _buildNavItem(3, Icons.favorite_border, '关注'),
          _buildNavItem(4, Icons.account_balance_wallet, '资产'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color:
                isSelected ? const Color(0xFF00C851) : const Color(0xFF999999),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF00C851)
                  : const Color(0xFF999999),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterTradeButton() {
    final isSelected = _selectedIndex == 2;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = 2),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00C851) : const Color(0xFF333333),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.swap_horiz,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              '交易',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import '../models/user.dart';
import '../models/token.dart';
import '../models/expert.dart';
import '../models/asset.dart';

class MockData {
  // Mock用户数据
  static const User mockUser = User(
    id: '1',
    email: 'user@example.com',
    walletAddress: '6bis...sgkz',
    followers: 0,
    solBalance: 0.0028205,
    isBalanceVisible: true,
  );

  // Mock代币数据
  static final List<Token> mockTokens = [
    const Token(
      id: '1',
      name: 'Jew',
      symbol: '3UQn...pump',
      address: '3UQnpump',
      imageUrl: 'assets/images/gmgn_avatar.png',
      price: 417.21,
      marketCap: 4740,
      volume24h: 417.21,
      priceChange24h: 0,
      holders: 3,
      timeAgo: '10s',
      priceChanges: [0, 0, 0],
      comments: 0,
      devPercent: 100,
      isNew: true,
    ),
    const Token(
      id: '2',
      name: 'STORAGE',
      symbol: 'Eeeu...pump',
      address: 'Eeeupump',
      imageUrl: 'assets/images/gmgn_avatar.png',
      price: 440.01,
      marketCap: 4070,
      volume24h: 440.01,
      priceChange24h: 0,
      holders: 5,
      timeAgo: '15s',
      priceChanges: [3, 0, 0], // Run表示异常状态
      comments: 2,
      devPercent: 100,
      isNew: true,
    ),
    const Token(
      id: '3',
      name: 'PWSWR',
      symbol: '2gAv...pump',
      address: '2gAvpump',
      imageUrl: 'assets/images/gmgn_avatar.png',
      price: 2.32,
      marketCap: 4060,
      volume24h: 2.32,
      priceChange24h: 0,
      holders: 4,
      timeAgo: '18s',
      priceChanges: [0, 0, 0],
      comments: 2,
      devPercent: 0,
      isNew: true,
    ),
    const Token(
      id: '4',
      name: 'Kitler',
      symbol: '9ujF...pump',
      address: '9ujFpump',
      imageUrl: 'assets/images/gmgn_avatar.png',
      price: 2210,
      marketCap: 5720,
      volume24h: 2210,
      priceChange24h: 21,
      holders: 8,
      timeAgo: '20s',
      priceChanges: [16, 99, 0],
      comments: 7,
      devPercent: 96,
      isNew: true,
    ),
    const Token(
      id: '5',
      name: 'Reet',
      symbol: '3s9T...pump',
      address: '3s9Tpump',
      imageUrl: 'assets/images/gmgn_avatar.png',
      price: 1890,
      marketCap: 3450,
      volume24h: 1890,
      priceChange24h: 15,
      holders: 6,
      timeAgo: '22s',
      priceChanges: [8, 45, 2],
      comments: 5,
      devPercent: 88,
      isNew: true,
    ),
  ];

  // Mock专家数据
  static final List<Expert> mockExperts = [
    const Expert(
      id: '1',
      walletAddress: 'Aa1b...C2d3',
      displayName: 'CryptoWhale',
      avatarUrl: 'assets/images/gmgn_avatar.png',
      rank: 1,
      solBalance: 1245.67,
      pnl: 89234.56,
      pnlPercentage: 234.5,
      followers: 1234,
      totalTrades: 156,
      winRate: 78.5,
      lastActivity: '2小时前',
      isFollowing: false,
      type: 'pump_smart',
    ),
    const Expert(
      id: '2',
      walletAddress: 'Bb2c...D3e4',
      displayName: 'SmartTrader',
      avatarUrl: 'assets/images/gmgn_avatar.png',
      rank: 2,
      solBalance: 987.43,
      pnl: 67890.12,
      pnlPercentage: 189.3,
      followers: 987,
      totalTrades: 134,
      winRate: 82.1,
      lastActivity: '1小时前',
      isFollowing: true,
      type: 'smart_money',
    ),
    const Expert(
      id: '3',
      walletAddress: 'Cc3d...E4f5',
      displayName: 'NewWallet',
      avatarUrl: 'assets/images/gmgn_avatar.png',
      rank: 3,
      solBalance: 654.32,
      pnl: 45678.90,
      pnlPercentage: 156.7,
      followers: 567,
      totalTrades: 89,
      winRate: 75.3,
      lastActivity: '30分钟前',
      isFollowing: false,
      type: 'new_wallet',
    ),
    const Expert(
      id: '4',
      walletAddress: 'Dd4e...F5g6',
      displayName: 'KOLInvestor',
      avatarUrl: 'assets/images/gmgn_avatar.png',
      rank: 4,
      solBalance: 432.10,
      pnl: 23456.78,
      pnlPercentage: 98.4,
      followers: 2345,
      totalTrades: 67,
      winRate: 71.2,
      lastActivity: '45分钟前',
      isFollowing: false,
      type: 'kol_vc',
    ),
    const Expert(
      id: '5',
      walletAddress: 'Ee5f...G6h7',
      displayName: 'PumpExpert',
      avatarUrl: 'assets/images/gmgn_avatar.png',
      rank: 5,
      solBalance: 321.98,
      pnl: 12345.67,
      pnlPercentage: 67.8,
      followers: 876,
      totalTrades: 45,
      winRate: 68.9,
      lastActivity: '1小时前',
      isFollowing: true,
      type: 'pump_smart',
    ),
  ];

  // Mock钱包跟单数据
  static final List<Expert> mockWalletFollows = [
    const Expert(
      id: '6',
      walletAddress: 'Ff6g...H7i8',
      displayName: 'AutoTrader1',
      avatarUrl: 'assets/images/gmgn_avatar.png',
      rank: 0, // 钱包跟单不显示排名
      solBalance: 0,
      pnl: 15678.90,
      pnlPercentage: 45.6,
      followers: 0,
      totalTrades: 234, // 总买入次数
      winRate: 156, // 总卖出次数
      lastActivity: '15分钟前',
      isFollowing: false,
      type: 'wallet_follow',
    ),
    const Expert(
      id: '7',
      walletAddress: 'Gg7h...I8j9',
      displayName: 'SmartCopy',
      avatarUrl: 'assets/images/gmgn_avatar.png',
      rank: 0,
      solBalance: 0,
      pnl: 23456.78,
      pnlPercentage: 78.9,
      followers: 0,
      totalTrades: 189,
      winRate: 134,
      lastActivity: '8分钟前',
      isFollowing: false,
      type: 'wallet_follow',
    ),
    const Expert(
      id: '8',
      walletAddress: 'Hh8i...J9k0',
      displayName: 'CopyMaster',
      avatarUrl: 'assets/images/gmgn_avatar.png',
      rank: 0,
      solBalance: 0,
      pnl: 34567.89,
      pnlPercentage: 123.4,
      followers: 0,
      totalTrades: 298,
      winRate: 201,
      lastActivity: '22分钟前',
      isFollowing: false,
      type: 'wallet_follow',
    ),
  ];

  // Mock资产数据
  static final List<Asset> mockAssets = [
    const Asset(
      id: '1',
      symbol: 'USDC',
      name: 'USD Coin',
      imageUrl: 'assets/images/gmgn_avatar.png',
      balance: 1000.0,
      value: 1000.0,
      price: 1.0,
      priceChange24h: 0.01,
      pnl: 50.0,
      pnlPercentage: 5.0,
    ),
    const Asset(
      id: '2',
      symbol: 'CASEY',
      name: 'Casey Token',
      imageUrl: 'assets/images/gmgn_avatar.png',
      balance: 5000.0,
      value: 750.0,
      price: 0.15,
      priceChange24h: -2.5,
      pnl: -125.0,
      pnlPercentage: -14.3,
    ),
    const Asset(
      id: '3',
      symbol: 'MEME',
      name: 'Meme Coin',
      imageUrl: 'assets/images/gmgn_avatar.png',
      balance: 10000.0,
      value: 500.0,
      price: 0.05,
      priceChange24h: 15.8,
      pnl: 200.0,
      pnlPercentage: 66.7,
    ),
  ];

  // Mock活动数据
  static final List<Activity> mockActivities = [
    Activity(
      id: '1',
      type: 'buy',
      tokenSymbol: 'TRUMP',
      tokenName: 'Trump Token',
      tokenImageUrl: 'assets/images/gmgn_avatar.png',
      amount: 1000.0,
      price: 9.12,
      value: 9120.0,
      pnl: 234.5,
      pnlPercentage: 2.6,
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    Activity(
      id: '2',
      type: 'sell',
      tokenSymbol: 'PEPE',
      tokenName: 'Pepe Token',
      tokenImageUrl: 'assets/images/gmgn_avatar.png',
      amount: 50000.0,
      price: 0.000012,
      value: 600.0,
      pnl: -45.6,
      pnlPercentage: -7.1,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Activity(
      id: '3',
      type: 'buy',
      tokenSymbol: 'DOGE',
      tokenName: 'Dogecoin',
      tokenImageUrl: 'assets/images/gmgn_avatar.png',
      amount: 5000.0,
      price: 0.08,
      value: 400.0,
      pnl: 67.8,
      pnlPercentage: 20.4,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Activity(
      id: '4',
      type: 'sell',
      tokenSymbol: 'SHIB',
      tokenName: 'Shiba Inu',
      tokenImageUrl: 'assets/images/gmgn_avatar.png',
      amount: 1000000.0,
      price: 0.000008,
      value: 8.0,
      pnl: -2.3,
      pnlPercentage: -22.3,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // 获取交易价格数据（用于K线图）
  static List<Map<String, double>> getTradePrices() {
    return [
      {
        'price': 9.19,
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 30))
            .millisecondsSinceEpoch
            .toDouble()
      },
      {
        'price': 9.15,
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 25))
            .millisecondsSinceEpoch
            .toDouble()
      },
      {
        'price': 9.18,
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 20))
            .millisecondsSinceEpoch
            .toDouble()
      },
      {
        'price': 9.12,
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 15))
            .millisecondsSinceEpoch
            .toDouble()
      },
      {
        'price': 9.16,
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 10))
            .millisecondsSinceEpoch
            .toDouble()
      },
      {
        'price': 9.14,
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 5))
            .millisecondsSinceEpoch
            .toDouble()
      },
      {
        'price': 9.17,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toDouble()
      },
    ];
  }

  // 获取实时价格列表（交易页面右侧）
  static List<double?> getRealTimePrices() {
    return [
      9.19,
      9.18,
      9.17,
      9.16,
      9.15,
      9.14,
      9.13,
      9.12,
      null, // "--" 空数据
      9.10,
      9.09,
      9.08,
      9.07,
    ];
  }
}

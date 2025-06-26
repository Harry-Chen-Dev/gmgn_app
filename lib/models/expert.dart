import 'package:equatable/equatable.dart';

class Expert extends Equatable {
  final String id;
  final String walletAddress;
  final String displayName;
  final String avatarUrl;
  final int rank;
  final double solBalance;
  final double pnl;
  final double pnlPercentage;
  final int followers;
  final int totalTrades;
  final double winRate;
  final String lastActivity;
  final bool isFollowing;
  final String type; // 'pump_smart', 'smart_money', 'new_wallet', 'kol_vc'

  const Expert({
    required this.id,
    required this.walletAddress,
    required this.displayName,
    required this.avatarUrl,
    required this.rank,
    required this.solBalance,
    required this.pnl,
    required this.pnlPercentage,
    required this.followers,
    required this.totalTrades,
    required this.winRate,
    required this.lastActivity,
    this.isFollowing = false,
    required this.type,
  });

  Expert copyWith({
    String? id,
    String? walletAddress,
    String? displayName,
    String? avatarUrl,
    int? rank,
    double? solBalance,
    double? pnl,
    double? pnlPercentage,
    int? followers,
    int? totalTrades,
    double? winRate,
    String? lastActivity,
    bool? isFollowing,
    String? type,
  }) {
    return Expert(
      id: id ?? this.id,
      walletAddress: walletAddress ?? this.walletAddress,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rank: rank ?? this.rank,
      solBalance: solBalance ?? this.solBalance,
      pnl: pnl ?? this.pnl,
      pnlPercentage: pnlPercentage ?? this.pnlPercentage,
      followers: followers ?? this.followers,
      totalTrades: totalTrades ?? this.totalTrades,
      winRate: winRate ?? this.winRate,
      lastActivity: lastActivity ?? this.lastActivity,
      isFollowing: isFollowing ?? this.isFollowing,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [
        id,
        walletAddress,
        displayName,
        avatarUrl,
        rank,
        solBalance,
        pnl,
        pnlPercentage,
        followers,
        totalTrades,
        winRate,
        lastActivity,
        isFollowing,
        type,
      ];
}

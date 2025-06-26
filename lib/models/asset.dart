import 'package:equatable/equatable.dart';

class Asset extends Equatable {
  final String id;
  final String symbol;
  final String name;
  final String imageUrl;
  final double balance;
  final double value;
  final double price;
  final double priceChange24h;
  final double pnl;
  final double pnlPercentage;

  const Asset({
    required this.id,
    required this.symbol,
    required this.name,
    required this.imageUrl,
    required this.balance,
    required this.value,
    required this.price,
    required this.priceChange24h,
    required this.pnl,
    required this.pnlPercentage,
  });

  Asset copyWith({
    String? id,
    String? symbol,
    String? name,
    String? imageUrl,
    double? balance,
    double? value,
    double? price,
    double? priceChange24h,
    double? pnl,
    double? pnlPercentage,
  }) {
    return Asset(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      balance: balance ?? this.balance,
      value: value ?? this.value,
      price: price ?? this.price,
      priceChange24h: priceChange24h ?? this.priceChange24h,
      pnl: pnl ?? this.pnl,
      pnlPercentage: pnlPercentage ?? this.pnlPercentage,
    );
  }

  @override
  List<Object?> get props => [
        id,
        symbol,
        name,
        imageUrl,
        balance,
        value,
        price,
        priceChange24h,
        pnl,
        pnlPercentage,
      ];
}

class Activity extends Equatable {
  final String id;
  final String type; // 'buy', 'sell'
  final String tokenSymbol;
  final String tokenName;
  final String tokenImageUrl;
  final double amount;
  final double price;
  final double value;
  final double pnl;
  final double pnlPercentage;
  final DateTime timestamp;

  const Activity({
    required this.id,
    required this.type,
    required this.tokenSymbol,
    required this.tokenName,
    required this.tokenImageUrl,
    required this.amount,
    required this.price,
    required this.value,
    required this.pnl,
    required this.pnlPercentage,
    required this.timestamp,
  });

  Activity copyWith({
    String? id,
    String? type,
    String? tokenSymbol,
    String? tokenName,
    String? tokenImageUrl,
    double? amount,
    double? price,
    double? value,
    double? pnl,
    double? pnlPercentage,
    DateTime? timestamp,
  }) {
    return Activity(
      id: id ?? this.id,
      type: type ?? this.type,
      tokenSymbol: tokenSymbol ?? this.tokenSymbol,
      tokenName: tokenName ?? this.tokenName,
      tokenImageUrl: tokenImageUrl ?? this.tokenImageUrl,
      amount: amount ?? this.amount,
      price: price ?? this.price,
      value: value ?? this.value,
      pnl: pnl ?? this.pnl,
      pnlPercentage: pnlPercentage ?? this.pnlPercentage,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        tokenSymbol,
        tokenName,
        tokenImageUrl,
        amount,
        price,
        value,
        pnl,
        pnlPercentage,
        timestamp,
      ];
}

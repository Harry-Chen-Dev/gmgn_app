import 'package:equatable/equatable.dart';

class Token extends Equatable {
  final String id;
  final String name;
  final String symbol;
  final String address;
  final String imageUrl;
  final double price;
  final double marketCap;
  final double volume24h;
  final double priceChange24h;
  final int holders;
  final String timeAgo;
  final List<double> priceChanges; // [1h, 6h, 24h]
  final int comments;
  final double devPercent;
  final bool isNew;

  const Token({
    required this.id,
    required this.name,
    required this.symbol,
    required this.address,
    required this.imageUrl,
    required this.price,
    required this.marketCap,
    required this.volume24h,
    required this.priceChange24h,
    required this.holders,
    required this.timeAgo,
    required this.priceChanges,
    required this.comments,
    required this.devPercent,
    this.isNew = false,
  });

  Token copyWith({
    String? id,
    String? name,
    String? symbol,
    String? address,
    String? imageUrl,
    double? price,
    double? marketCap,
    double? volume24h,
    double? priceChange24h,
    int? holders,
    String? timeAgo,
    List<double>? priceChanges,
    int? comments,
    double? devPercent,
    bool? isNew,
  }) {
    return Token(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      marketCap: marketCap ?? this.marketCap,
      volume24h: volume24h ?? this.volume24h,
      priceChange24h: priceChange24h ?? this.priceChange24h,
      holders: holders ?? this.holders,
      timeAgo: timeAgo ?? this.timeAgo,
      priceChanges: priceChanges ?? this.priceChanges,
      comments: comments ?? this.comments,
      devPercent: devPercent ?? this.devPercent,
      isNew: isNew ?? this.isNew,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        symbol,
        address,
        imageUrl,
        price,
        marketCap,
        volume24h,
        priceChange24h,
        holders,
        timeAgo,
        priceChanges,
        comments,
        devPercent,
        isNew,
      ];
}

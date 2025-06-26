import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/mock_data.dart';

// Events
abstract class TradeEvent extends Equatable {
  const TradeEvent();

  @override
  List<Object> get props => [];
}

class LoadTradeData extends TradeEvent {}

class UpdateRealTimePrices extends TradeEvent {}

class ToggleTradeType extends TradeEvent {
  final String tradeType; // 'buy' or 'sell'

  const ToggleTradeType(this.tradeType);

  @override
  List<Object> get props => [tradeType];
}

class ToggleTradeMode extends TradeEvent {
  final String tradeMode; // 'instant' or 'dip'

  const ToggleTradeMode(this.tradeMode);

  @override
  List<Object> get props => [tradeMode];
}

class UpdateTradeAmount extends TradeEvent {
  final double amount;

  const UpdateTradeAmount(this.amount);

  @override
  List<Object> get props => [amount];
}

// States
abstract class TradeState extends Equatable {
  const TradeState();

  @override
  List<Object> get props => [];
}

class TradeInitial extends TradeState {}

class TradeLoading extends TradeState {}

class TradeLoaded extends TradeState {
  final String tokenSymbol;
  final String tokenName;
  final double currentPrice;
  final double marketCap;
  final String tradeType; // 'buy' or 'sell'
  final String tradeMode; // 'instant' or 'dip'
  final double tradeAmount;
  final List<Map<String, double>> priceHistory;
  final List<double?> realTimePrices;
  final String selectedTimeframe; // '1s', '30s', '1m', '1h', 'more'

  const TradeLoaded({
    required this.tokenSymbol,
    required this.tokenName,
    required this.currentPrice,
    required this.marketCap,
    this.tradeType = 'buy',
    this.tradeMode = 'instant',
    this.tradeAmount = 0.0,
    required this.priceHistory,
    required this.realTimePrices,
    this.selectedTimeframe = '1m',
  });

  @override
  List<Object> get props => [
        tokenSymbol,
        tokenName,
        currentPrice,
        marketCap,
        tradeType,
        tradeMode,
        tradeAmount,
        priceHistory,
        realTimePrices,
        selectedTimeframe,
      ];

  TradeLoaded copyWith({
    String? tokenSymbol,
    String? tokenName,
    double? currentPrice,
    double? marketCap,
    String? tradeType,
    String? tradeMode,
    double? tradeAmount,
    List<Map<String, double>>? priceHistory,
    List<double?>? realTimePrices,
    String? selectedTimeframe,
  }) {
    return TradeLoaded(
      tokenSymbol: tokenSymbol ?? this.tokenSymbol,
      tokenName: tokenName ?? this.tokenName,
      currentPrice: currentPrice ?? this.currentPrice,
      marketCap: marketCap ?? this.marketCap,
      tradeType: tradeType ?? this.tradeType,
      tradeMode: tradeMode ?? this.tradeMode,
      tradeAmount: tradeAmount ?? this.tradeAmount,
      priceHistory: priceHistory ?? this.priceHistory,
      realTimePrices: realTimePrices ?? this.realTimePrices,
      selectedTimeframe: selectedTimeframe ?? this.selectedTimeframe,
    );
  }
}

class TradeError extends TradeState {
  final String message;

  const TradeError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class TradeBloc extends Bloc<TradeEvent, TradeState> {
  TradeBloc() : super(TradeInitial()) {
    on<LoadTradeData>(_onLoadTradeData);
    on<UpdateRealTimePrices>(_onUpdateRealTimePrices);
    on<ToggleTradeType>(_onToggleTradeType);
    on<ToggleTradeMode>(_onToggleTradeMode);
    on<UpdateTradeAmount>(_onUpdateTradeAmount);
  }

  Future<void> _onLoadTradeData(
    LoadTradeData event,
    Emitter<TradeState> emit,
  ) async {
    emit(TradeLoading());

    try {
      // 模拟网络延迟
      await Future.delayed(const Duration(milliseconds: 500));

      final priceHistory = MockData.getTradePrices();
      final realTimePrices = MockData.getRealTimePrices();

      emit(TradeLoaded(
        tokenSymbol: 'TRUMP',
        tokenName: 'Trump Token',
        currentPrice: 9.06,
        marketCap: 9060000000, // $9.06B
        priceHistory: priceHistory,
        realTimePrices: realTimePrices,
      ));
    } catch (e) {
      emit(TradeError('加载交易数据失败: $e'));
    }
  }

  Future<void> _onUpdateRealTimePrices(
    UpdateRealTimePrices event,
    Emitter<TradeState> emit,
  ) async {
    if (state is TradeLoaded) {
      final currentState = state as TradeLoaded;

      try {
        // 模拟实时价格更新
        final updatedPrices = MockData.getRealTimePrices();
        final newPrice = updatedPrices.first ?? currentState.currentPrice;

        emit(currentState.copyWith(
          currentPrice: newPrice,
          realTimePrices: updatedPrices,
        ));
      } catch (e) {
        emit(TradeError('更新实时价格失败: $e'));
      }
    }
  }

  Future<void> _onToggleTradeType(
    ToggleTradeType event,
    Emitter<TradeState> emit,
  ) async {
    if (state is TradeLoaded) {
      final currentState = state as TradeLoaded;
      emit(currentState.copyWith(tradeType: event.tradeType));
    }
  }

  Future<void> _onToggleTradeMode(
    ToggleTradeMode event,
    Emitter<TradeState> emit,
  ) async {
    if (state is TradeLoaded) {
      final currentState = state as TradeLoaded;
      emit(currentState.copyWith(tradeMode: event.tradeMode));
    }
  }

  Future<void> _onUpdateTradeAmount(
    UpdateTradeAmount event,
    Emitter<TradeState> emit,
  ) async {
    if (state is TradeLoaded) {
      final currentState = state as TradeLoaded;
      emit(currentState.copyWith(tradeAmount: event.amount));
    }
  }
}

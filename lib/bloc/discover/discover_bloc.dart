import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/mock_data.dart';
import '../../models/token.dart';
import 'discover_event.dart';
import 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  DiscoverBloc() : super(const DiscoverInitial()) {
    on<DiscoverLoadTokens>(_onLoadTokens);
    on<DiscoverRefreshTokens>(_onRefreshTokens);
    on<DiscoverFilterChanged>(_onFilterChanged);
    on<DiscoverTabChanged>(_onTabChanged);
  }

  Future<void> _onLoadTokens(
    DiscoverLoadTokens event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(const DiscoverLoading());

    try {
      // 模拟网络请求延迟
      await Future.delayed(const Duration(milliseconds: 500));

      // 获取Mock数据
      final tokens = MockData.mockTokens;
      emit(DiscoverLoaded(tokens: tokens));
    } catch (e) {
      emit(DiscoverError(message: '加载代币失败: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshTokens(
    DiscoverRefreshTokens event,
    Emitter<DiscoverState> emit,
  ) async {
    if (state is DiscoverLoaded) {
      final currentState = state as DiscoverLoaded;
      emit(currentState.copyWith(isRefreshing: true));

      try {
        // 模拟刷新延迟
        await Future.delayed(const Duration(seconds: 1));

        // 获取最新Mock数据
        final tokens = MockData.mockTokens;
        emit(currentState.copyWith(
          tokens: tokens,
          isRefreshing: false,
        ));
      } catch (e) {
        emit(DiscoverError(message: '刷新失败: ${e.toString()}'));
      }
    }
  }

  Future<void> _onFilterChanged(
    DiscoverFilterChanged event,
    Emitter<DiscoverState> emit,
  ) async {
    if (state is DiscoverLoaded) {
      final currentState = state as DiscoverLoaded;

      // 根据筛选条件过滤代币（这里简化为返回所有数据）
      final filteredTokens = _filterTokens(MockData.mockTokens, event.filter);

      emit(currentState.copyWith(
        tokens: filteredTokens,
        currentFilter: event.filter,
      ));
    }
  }

  Future<void> _onTabChanged(
    DiscoverTabChanged event,
    Emitter<DiscoverState> emit,
  ) async {
    if (state is DiscoverLoaded) {
      final currentState = state as DiscoverLoaded;

      // 根据标签过滤代币（这里简化为返回所有数据）
      final tabTokens = _filterTokensByTab(MockData.mockTokens, event.tab);

      emit(currentState.copyWith(
        tokens: tabTokens,
        currentTab: event.tab,
      ));
    }
  }

  List<Token> _filterTokens(List<Token> tokens, String filter) {
    // 这里可以实现真实的筛选逻辑
    switch (filter) {
      case 'new_created':
        return tokens.where((token) => token.isNew).toList();
      case 'nearly_full':
        return tokens.where((token) => token.marketCap > 4000).toList();
      case 'surge':
        return tokens.where((token) => token.priceChange24h > 10).toList();
      case 'listed':
        return tokens.where((token) => token.marketCap > 5000).toList();
      default:
        return tokens;
    }
  }

  List<Token> _filterTokensByTab(List<Token> tokens, String tab) {
    // 这里可以实现真实的标签筛选逻辑
    switch (tab) {
      case 'watchlist':
        return tokens;
      case 'records':
        return tokens.where((token) => token.priceChange24h != 0).toList();
      case 'new_coins':
        return tokens.where((token) => token.isNew).toList();
      case 'hot':
        return tokens.where((token) => token.volume24h > 1000).toList();
      case 'monitor':
        return tokens.where((token) => token.comments > 0).toList();
      default:
        return tokens;
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthTelegramLogin>(_onTelegramLogin);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onCheckRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final user = await AuthService.login(event.email, event.password);

      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthError(message: '邮箱或密码错误'));
      }
    } catch (e) {
      emit(AuthError(message: '登录失败: ${e.toString()}'));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final success = await AuthService.register(event.email, event.password);

      if (success) {
        // 注册成功后自动登录
        final user = await AuthService.login(event.email, event.password);
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(const AuthError(message: '注册成功但登录失败'));
        }
      } else {
        emit(const AuthError(message: '邮箱已存在'));
      }
    } catch (e) {
      emit(AuthError(message: '注册失败: ${e.toString()}'));
    }
  }

  Future<void> _onTelegramLogin(
    AuthTelegramLogin event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      // 模拟Telegram登录延迟
      await Future.delayed(const Duration(seconds: 2));

      // Telegram登录暂时不实现，显示提示
      emit(const AuthError(message: 'Telegram登录功能开发中...'));
    } catch (e) {
      emit(AuthError(message: 'Telegram登录失败: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await AuthService.logout();
    emit(const AuthUnauthenticated());
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = await AuthService.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }
}

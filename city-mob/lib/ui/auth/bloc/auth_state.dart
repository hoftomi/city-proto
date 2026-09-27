part of 'auth_bloc.dart';

enum AuthStatus { unknown, signedOut, signedIn }

class AuthState extends Equatable {
  const AuthState({this.status = AuthStatus.unknown, this.user, this.busyProvider, this.error});

  final AuthStatus status;
  final UserDto? user;

  /// Épp ezzel a szolgáltatóval lép be (a gombján pörög a jelző).
  final String? busyProvider;
  final String? error;

  bool get busy => busyProvider != null;
  bool get admin => user?.admin ?? false;

  AuthState copyWith({
    AuthStatus? status,
    UserDto? user,
    String? busyProvider,
    bool clearBusy = false,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      busyProvider: clearBusy ? null : busyProvider ?? this.busyProvider,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, user, busyProvider, error];
}

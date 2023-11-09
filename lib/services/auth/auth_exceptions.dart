class SignUpWithEmailAndPasswordFailure {
  final String message;

  const SignUpWithEmailAndPasswordFailure(
      [this.message = "Ocorreu um erro desconhecido."]);

  factory SignUpWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'week-password':
        return const SignUpWithEmailAndPasswordFailure(
            'Por favor utilize uma senha mais forte.');
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure('E-mail inválido.');
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
            'Já existe uma conta para este e-mail.');
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
            'Operação não permitida. Por favor contate o suporte.');
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
            'Este usuário foi desabilitado. Por favor contate o suporte para ajuda.');
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }
}

class EmailSignInModel {
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.isLoading = false,
    this.submitted = false,
  });

  final String email;
  final String password;
  final bool isLoading;
  final bool submitted;

  EmailSignInModel copyWith({
    String email,
    String password,
    bool isLoading,
    bool submitted
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}

class Account {
  final String email; // Sửa tên thuộc tính
  final String password; // Sửa tên thuộc tính

  const Account({
    required this.email,
    required this.password,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'email': String email, // Sửa lại tên khóa
        'password': String password, // Sửa lại tên khóa
      } =>
        Account(
          email: email,
          password: password,
        ),
      _ => throw const FormatException('Failed to load account.'),
    };
  }
}
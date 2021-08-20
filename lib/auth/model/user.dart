class UserModel {
  String fullName;
  String email;
  String phoneNo;
  String password;
  String confirmPassword;

  UserModel({
    this.fullName = '',
    this.email = '',
    this.phoneNo = '',
    this.password = '',
    this.confirmPassword = '',
  });

  @override
  String toString() {
    return 'UserModel(fullName: $fullName, email: $email, phoneNo: $phoneNo, password: $password, confirmPassword: $confirmPassword)';
  }
}

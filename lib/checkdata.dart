String _email;
String _pass;
String _name;
String _phone;
String error;

class CheckInput {
  checkEmail() {
    if (_email.length < 6 || _email.contains('@')) {
      error = 'Enter email';
    }
  }
}

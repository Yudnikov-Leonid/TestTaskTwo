abstract class UiValidator {
  String? isValid(String value);
}

class EmptyUiValidator implements UiValidator {
  final UiValidator? next;

  EmptyUiValidator({this.next});

  @override
  String? isValid(String value) {
    if (value.isEmpty) {
      return 'The field is empty';
    } else {
      return next?.isValid(value);
    }
  }
}

class EmailUiValidator implements UiValidator {
  @override
  String? isValid(String value) {
    final emailIsValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    return emailIsValid ? null : 'Email is incorrect';
  }
}

class LengthUiValidator implements UiValidator {
  final UiValidator? next;
  final int length;

  LengthUiValidator(this.length, {this.next});

  @override
  String? isValid(String value) {
    final isValid = value.length >= length;
    return isValid ? next?.isValid(value) : 'The length must not be less than $length symbols';
  }
}

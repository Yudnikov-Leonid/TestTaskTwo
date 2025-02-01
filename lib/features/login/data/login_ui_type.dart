abstract class LoginUiType {}

class LoginUiRegister extends LoginUiType {}

class LoginUiAuth extends LoginUiType {}

class LoginUiConfirm extends LoginUiType {}

class LoginUiRestore extends LoginUiType {}

/// fields:
/// 1. Email
/// 2. Password
/// 3. Name
/// 4. Confirm email code
///
/// states:
/// register: 1,2,3
/// auth: 1,2
/// confirm: 4
/// restore: 1

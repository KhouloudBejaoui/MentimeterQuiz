class QuizManager {
  static String _quizCode = '';
  static String _username = '';

  static String getQuizCode() {
    return _quizCode;
  }

  static String getUserName() {
    return _username;
  }

  static void setQuizCode(String code) {
    _quizCode = code;
  }

  static void setUserName(String username) {
    _username = username;
  }
}

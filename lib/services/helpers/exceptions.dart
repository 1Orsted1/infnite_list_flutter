///***************************************************************************
/// AppException
///***************************************************************************
class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

///***************************************************************************
/// FetchDataException
///***************************************************************************
class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super("",message);
}

///***************************************************************************
/// BadRequestException
///***************************************************************************
class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, "Invalid Request: ");
}

///***************************************************************************
/// BadRequestException
///***************************************************************************
class NotFoundException extends AppException {
  NotFoundException([String? message]) : super("", "404");
}


///***************************************************************************
/// BadRequestException
///***************************************************************************
class NotContentException extends AppException {
  NotContentException([String? message]) : super("", "204");
}

///***************************************************************************
/// UnauthorizedException
///***************************************************************************
class UnauthorizedException extends AppException {
  UnauthorizedException([String? message]) : super(message, "Unauthorized: ");
}

///***************************************************************************
/// InvalidInputException
///***************************************************************************
class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}
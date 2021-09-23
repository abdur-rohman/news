class AuthModel {
  final ApiModel api;
  final StatusModel status;
  final String data;

  AuthModel({
    required this.api,
    required this.status,
    required this.data,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      api: ApiModel.fromJson(json['api'] ?? {}),
      status: StatusModel.fromJson(json['status'] ?? {}),
      data: json['data'] ?? '',
    );
  }
}

class ApiModel {
  final String version, function;
  final double microtime;

  ApiModel({
    required this.version,
    required this.function,
    required this.microtime,
  });

  factory ApiModel.fromJson(Map<String, dynamic> json) {
    return ApiModel(
      version: json['version'] ?? '',
      function: json['function'] ?? '',
      microtime: json['microtime'] ?? 0.0,
    );
  }
}

class StatusModel {
  final int code;
  final bool error;
  final String message;

  StatusModel({
    required this.code,
    required this.error,
    required this.message,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    return StatusModel(
      code: json['code'] ?? 0,
      error: json['error'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

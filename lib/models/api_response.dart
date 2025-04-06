class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  ApiResponse({required this.success, required this.message, this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT, // `fromJsonT` can be null
  ) =>
      ApiResponse(
        success: json['success'] as bool? ?? false, // Default to false if null
        message: json['message']?.toString() ?? "Unknown error",
        data: json['data'] != null && fromJsonT != null
            ? fromJsonT(json['data']) // Only call `fromJsonT` if it exists
            : null, // Otherwise, return null
      );
}

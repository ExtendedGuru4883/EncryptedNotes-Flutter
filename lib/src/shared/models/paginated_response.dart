class PaginatedResponse<T> {
  final List<T> items;
  final int pageSize;
  final int totalCount;

  PaginatedResponse(this.items, this.pageSize, this.totalCount);

  PaginatedResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT)
    : items = (json['items'] as List<dynamic>).map((item) => fromJsonT(item as Map<String, dynamic>)).toList(),
      pageSize = json['pageSize'] as int,
      totalCount = json['totalCount'] as int;
}

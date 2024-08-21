class TheKirtanisModel {
  dynamic id;
  dynamic url;
  dynamic alt;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic sortOrder;

  TheKirtanisModel(
      {this.id,
      this.url,
      this.alt,
      this.createdAt,
      this.updatedAt,
      this.sortOrder});

  TheKirtanisModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    alt = json['alt'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    data['alt'] = alt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['sort_order'] = sortOrder;
    return data;
  }
}
import 'package:shabadguru/network_service/models/popular_raags_model.dart';

class PopularBannisModel {
  dynamic status;
  dynamic message;
  List<RaagData>? data;

  String? error;

  PopularBannisModel.withError(String errorMessage) {
    error = errorMessage;
  }

  PopularBannisModel({this.status, this.message, this.data});

  PopularBannisModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RaagData>[];
      json['data'].forEach((v) {
        data!.add(RaagData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Categories {
  dynamic id;
  dynamic name;
  dynamic banner;
  dynamic isShow;
  dynamic createdAt;
  dynamic updatedAt;

  Categories(
      {this.id,
      this.name,
      this.banner,
      this.isShow,
      this.createdAt,
      this.updatedAt});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    banner = json['banner'];
    isShow = json['is_show'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['banner'] = banner;
    data['is_show'] = isShow;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
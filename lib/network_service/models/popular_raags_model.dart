class PopularRaagsModel {
  dynamic status;
  dynamic message;
  List<RaagData>? data;
  List<RaagData>? preRaags;
  List<RaagData>? postRaags;

  String? error;

  PopularRaagsModel.withError(String errorMessage) {
    error = errorMessage;
  }

  PopularRaagsModel({this.status, this.message, this.data});

  PopularRaagsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RaagData>[];
      json['data'].forEach((v) {
        data!.add(RaagData.fromJson(v));
      });
    }
    if (json['preRaags'] != null) {
      preRaags = <RaagData>[];
      json['preRaags'].forEach((v) {
        preRaags!.add(RaagData.fromJson(v));
      });
    }
    if (json['postRaags'] != null) {
      postRaags = <RaagData>[];
      json['postRaags'].forEach((v) {
        postRaags!.add(RaagData.fromJson(v));
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
    if (preRaags != null) {
      data['data'] = preRaags!.map((v) => v.toJson()).toList();
    }
    if (postRaags != null) {
      data['data'] = postRaags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RaagData {
  dynamic id;
  dynamic parentId;
  dynamic name;
  dynamic englishTranslation;
  dynamic description;
  dynamic longDescription;
  dynamic banner;
  dynamic file;
  dynamic lyricsFile;
  dynamic author;
  dynamic categoriesIds;
  dynamic tags;
  dynamic duration;
  dynamic publishedDate;
  dynamic guru;
  dynamic isShow;
  dynamic jsonFolderPath;
  dynamic order;
  dynamic fileNameOnS3;
  dynamic punjabi;
  dynamic english;
  dynamic englishTrans;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  List<Categories>? categories;

  RaagData(
      {this.id,
      this.parentId,
      this.name,
      this.englishTranslation,
      this.description,
      this.longDescription,
      this.banner,
      this.file,
      this.lyricsFile,
      this.author,
      this.categoriesIds,
      this.tags,
      this.duration,
      this.publishedDate,
      this.guru,
      this.isShow,
      this.jsonFolderPath,
      this.order,
      this.fileNameOnS3,
      this.punjabi,
      this.english,
      this.englishTrans,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.categories});

  RaagData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    name = json['name'];
    englishTranslation = json['english_translation'];
    description = json['description'];
    longDescription = json['long_description'];
    banner = json['banner'];
    file = json['file'];
    lyricsFile = json['lyrics_file'];
    author = json['author'];
    categoriesIds = json['categories_ids'];
    tags = json['tags'];
    duration = json['duration'];
    publishedDate = json['published_date'];
    guru = json['guru'];
    isShow = json['is_show'];
    jsonFolderPath = json['json_folder_path'];
    order = json['order'];
    fileNameOnS3 = json['file_name_on_s3'];
    punjabi = json['punjabi'];
    english = json['english'];
    englishTrans = json['english_trans'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['name'] = name;
    data['english_translation'] = englishTranslation;
    data['description'] = description;
    data['long_description'] = longDescription;
    data['banner'] = banner;
    data['file'] = file;
    data['lyrics_file'] = lyricsFile;
    data['author'] = author;
    data['categories_ids'] = categoriesIds;
    data['tags'] = tags;
    data['duration'] = duration;
    data['published_date'] = publishedDate;
    data['guru'] = guru;
    data['is_show'] = isShow;
    data['json_folder_path'] = jsonFolderPath;
    data['order'] = order;
    data['file_name_on_s3'] = fileNameOnS3;
    data['punjabi'] = punjabi;
    data['english'] = english;
    data['english_trans'] = englishTrans;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
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

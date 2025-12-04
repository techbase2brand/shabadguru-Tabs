// Model class for Nitnem API response
// Model class for Nitnem API response - using NitnemData instead of RaagData for clarity
class NitnemModel {
  dynamic status; // API response status
  dynamic message; // API response message
  List<NitnemData>? data; // List of Nitnem data

  String? error; // Error message for failed requests

  // Constructor for error responses
  NitnemModel.withError(String errorMessage) {
    error = errorMessage;
  }

  // Default constructor
  NitnemModel({this.status, this.message, this.data});

  NitnemModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NitnemData>[];
      json['data'].forEach((v) {
        data!.add(NitnemData.fromJson(v));
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

// Model class for individual Nitnem data from API
class NitnemData {
  dynamic id;
  dynamic parentId;
  dynamic name;
  dynamic slug;
  dynamic englishTranslation;
  dynamic description;
  dynamic longDescription;
  dynamic banner;
  dynamic file; // Audio file URL
  dynamic lyricsFile; // Lyrics JSON URL
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
  dynamic spanish;
  dynamic hindi;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;

  NitnemData({
    this.id,
    this.parentId,
    this.name,
    this.slug,
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
    this.spanish,
    this.hindi,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  NitnemData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    name = json['name'];
    slug = json['slug'];
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
    spanish = json['spanish'];
    hindi = json['hindi'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['name'] = name;
    data['slug'] = slug;
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
    data['spanish'] = spanish;
    data['hindi'] = hindi;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

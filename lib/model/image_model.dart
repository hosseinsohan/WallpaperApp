class ImageModel {
  //int? totalHits;
  List<Data>? allData;
  //int? total;

  ImageModel({ this.allData,});

  ImageModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      allData = [];
      json['data'].forEach((v) {
        allData!.add(new Data.fromJson(v));
      });
    }
  }
}

class Data {
  String? id;
  String? url;
  String? shortUrl;
  int? views;
  int? favorites;
  String? source;
  String? purity;
  String? category;
  int? dimensionX;
  int? dimensionY;
  String? resolution;
  String? ratio;
  int? fileSize;
  String? fileType;
  String? createdAt;
  List<String>? colors;
  String? path;
  Thumbs? thumbs;
  String? user;
  String? userImageURL;

  Data(
      {this.id,
        this.url,
        this.shortUrl,
        this.views,
        this.favorites,
        this.source,
        this.purity,
        this.category,
        this.dimensionX,
        this.dimensionY,
        this.resolution,
        this.ratio,
        this.fileSize,
        this.fileType,
        this.createdAt,
        this.colors,
        this.path,
        this.user,
        this.userImageURL,
        this.thumbs});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    shortUrl = json['short_url'];
    views = json['views'];
    favorites = json['favorites'];
    source = json['source'];
    purity = json['purity'];
    category = json['category'];
    dimensionX = json['dimension_x'];
    dimensionY = json['dimension_y'];
    resolution = json['resolution'];
    ratio = json['ratio'];
    fileSize = json['file_size'];
    fileType = json['file_type'];
    createdAt = json['created_at'];
    colors = json['colors'].cast<String>();
    path = json['path'];
    user = "Slavan_Art";
    userImageURL = "https://cdn.pixabay.com/user/2019/04/24/15-25-59-78_250x250.jpg";
    thumbs =
    json['thumbs'] != null ? new Thumbs.fromJson(json['thumbs']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['short_url'] = this.shortUrl;
    data['views'] = this.views;
    data['favorites'] = this.favorites;
    data['source'] = this.source;
    data['purity'] = this.purity;
    data['category'] = this.category;
    data['dimension_x'] = this.dimensionX;
    data['dimension_y'] = this.dimensionY;
    data['resolution'] = this.resolution;
    data['ratio'] = this.ratio;
    data['file_size'] = this.fileSize;
    data['file_type'] = this.fileType;
    data['created_at'] = this.createdAt;
    data['colors'] = this.colors;
    data['path'] = this.path;
    if (this.thumbs != null) {
      data['thumbs'] = this.thumbs!.toJson();
    }
    return data;
  }
}

class Thumbs {
  String? large;
  String? original;
  String? small;

  Thumbs({this.large, this.original, this.small});

  Thumbs.fromJson(Map<String, dynamic> json) {
    large = json['large'];
    original = json['original'];
    small = json['small'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['large'] = this.large;
    data['original'] = this.original;
    data['small'] = this.small;
    return data;
  }
}
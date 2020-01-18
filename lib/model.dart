// To parse this JSON data, do
//
//     final userSharedCampaignsList = userSharedCampaignsListFromJson(jsonString);

import 'dart:convert';

List<UserSharedCampaignsList> userSharedCampaignsListFromJson(String str) =>
    List<UserSharedCampaignsList>.from(
        json.decode(str).map((x) => UserSharedCampaignsList.fromJson(x)));

String userSharedCampaignsListToJson(List<UserSharedCampaignsList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserSharedCampaignsList {
  Id id;
  String fileName;
  int status;
  String path;

  UserSharedCampaignsList({
    this.id,
    this.fileName,
    this.status,
    this.path,
  });

  factory UserSharedCampaignsList.fromJson(Map<String, dynamic> json) =>
      UserSharedCampaignsList(
        id: Id.fromJson(json["_id"]),
        fileName: json["file_name"],
        status: json["status"],
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id.toJson(),
        "file_name": fileName,
        "status": status,
        "path": path,
      };
}

class Id {
  String oid;

  Id({
    this.oid,
  });

  factory Id.fromJson(Map<String, dynamic> json) => Id(
        oid: json["\u0024oid"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024oid": oid,
      };
}

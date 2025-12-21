// To parse this JSON data, do
//
//     final playerEntry = playerEntryFromJson(jsonString);

import 'dart:convert';

List<PlayerEntry> playerEntryFromJson(String str) => List<PlayerEntry>.from(json.decode(str).map((x) => PlayerEntry.fromJson(x)));

String playerEntryToJson(List<PlayerEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlayerEntry {
    String id;
    String name;
    DateTime dateOfBirth;
    Country country;
    Bio bio;
    Category category;
    Status status;
    String? thumbnail;
    int? worldRank;
    String? partnerId;
    bool isFeatured;

    PlayerEntry({
        required this.id,
        required this.name,
        required this.dateOfBirth,
        required this.country,
        required this.bio,
        required this.category,
        required this.status,
        required this.thumbnail,
        required this.worldRank,
        required this.partnerId,
        required this.isFeatured,
    });

    factory PlayerEntry.fromJson(Map<String, dynamic> json) => PlayerEntry(
        id: json["id"],
        name: json["name"],
        dateOfBirth: DateTime.parse(json["date_of_birth"]),
        country: countryValues.map[json["country"]]!,
        bio: bioValues.map[json["bio"]]!,
        category: categoryValues.map[json["category"]]!,
        status: statusValues.map[json["status"]]!,
        thumbnail: json["thumbnail"],
        worldRank: json["world_rank"],
        partnerId: json["partner_id"],
        isFeatured: json["is_featured"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "date_of_birth": "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "country": countryValues.reverse[country],
        "bio": bioValues.reverse[bio],
        "category": categoryValues.reverse[category],
        "status": statusValues.reverse[status],
        "thumbnail": thumbnail,
        "world_rank": worldRank,
        "partner_id": partnerId,
        "is_featured": isFeatured,
    };
}

enum Bio {
    EMPTY,
    MINION,
    SADA
}

final bioValues = EnumValues({
    "": Bio.EMPTY,
    "minion": Bio.MINION,
    "sada": Bio.SADA
});

enum Category {
    MEN_S_DOUBLE,
    MEN_S_SINGLE,
    MIXED_DOUBLE,
    WOMEN_S_DOUBLE,
    WOMEN_S_SINGLE
}

final categoryValues = EnumValues({
    "men's double": Category.MEN_S_DOUBLE,
    "men's single": Category.MEN_S_SINGLE,
    "mixed double": Category.MIXED_DOUBLE,
    "women's double": Category.WOMEN_S_DOUBLE,
    "women's single": Category.WOMEN_S_SINGLE
});

enum Country {
    ID,
    IT
}

final countryValues = EnumValues({
    "ID": Country.ID,
    "IT": Country.IT
});

enum Status {
    ACTIVE,
    RETIRED
}

final statusValues = EnumValues({
    "active": Status.ACTIVE,
    "retired": Status.RETIRED
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}

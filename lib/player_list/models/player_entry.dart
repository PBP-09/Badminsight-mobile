import 'dart:convert';

List<PlayerEntry> playerEntryFromJson(String str) => List<PlayerEntry>.from(json.decode(str).map((x) => PlayerEntry.fromJson(x)));

String playerEntryToJson(List<PlayerEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlayerEntry {
    String id; 
    String name;
    DateTime dateOfBirth;
    String country; 
    String bio;    
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
        // handling null date safe
        dateOfBirth: json["date_of_birth"] != null 
            ? DateTime.parse(json["date_of_birth"]) 
            : DateTime(2000, 1, 1),
        country: json["country"] ?? "", 
        bio: json["bio"] ?? "",
        category: categoryValues.map[json["category"]] ?? Category.MEN_S_SINGLE,
        status: statusValues.map[json["status"]] ?? Status.ACTIVE,
        thumbnail: json["thumbnail"],
        
        worldRank: json["world_rank"] != null 
            ? int.tryParse(json["world_rank"].toString()) 
            : null,
        partnerId: json["partner"], 
        isFeatured: json["is_featured"] ?? false,
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "date_of_birth": "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "country": country,
        "bio": bio,
        "category": categoryValues.reverse[category],
        "status": statusValues.reverse[status],
        "thumbnail": thumbnail,
        "world_rank": worldRank,
        "partner": partnerId,
        "is_featured": isFeatured,
    };
}

enum Category {
    MEN_S_DOUBLE,
    MEN_S_SINGLE,
    WOMEN_S_DOUBLE,
    WOMEN_S_SINGLE,
    MIXED_DOUBLE
}

final categoryValues = EnumValues({
    "men's double": Category.MEN_S_DOUBLE,
    "men's single": Category.MEN_S_SINGLE,
    "women's double": Category.WOMEN_S_DOUBLE,
    "women's single": Category.WOMEN_S_SINGLE,
    "mixed double": Category.MIXED_DOUBLE
});

enum Status { ACTIVE, INACTIVE, INJURED, RETIRED }

final statusValues = EnumValues({
    "active": Status.ACTIVE,
    "inactive": Status.INACTIVE,
    "injured": Status.INJURED,
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
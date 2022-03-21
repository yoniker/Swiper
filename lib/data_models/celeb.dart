class Celeb {
  final String celebName;
  final String? name;
  final List<String?>? aliases;
  final String? birthday;
  final String? description;
  final String? country;
  List<String>? imagesUrls;

  Celeb({
    required this.celebName,
    this.imagesUrls,
    this.name,
    this.aliases,
    this.birthday,
    this.description,
    this.country,

  });

  factory Celeb.fromJson(Map<String, dynamic> json) {
    //
    return Celeb(
      celebName: json['celeb_name'] ?? null,
      name: json['name'],
      aliases: List<String>.from(json['aliases'].map((x) => x)),
      birthday: json['birthday'] ?? null,
      description: json['description'],
      country: json['country'],
      imagesUrls: List<String>.from(json['image_urls'].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'celeb_name': celebName,
      'name': name,
      'aliases': aliases,
      'birthday': birthday,
      'description': description,
      'country': country,
      'image_urls': imagesUrls ?? null,
    };
  }

  @override
  bool operator ==(Object other) {
    return (other is Celeb) && (other.celebName == celebName);
  }

  @override
  int get hashCode => celebName.hashCode;
}
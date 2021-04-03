class Celeb{
  final String celebName;
  final String name;
  final List<String> aliases;
  final String birthday;
  final String description;
  final String country;
  List<String> imagesUrls;

  Celeb({
    this.celebName,this.name,this.aliases,this.birthday,
    this.description,this.country
  }){imagesUrls = null;
  }

  @override
  bool operator ==(Object other) {
    return (other is Celeb) && (other.celebName == celebName);

  }

  @override
  int get hashCode => celebName.hashCode;
}
final List<Profile> demoProfiles = [
  new Profile(
    photos: [
      "assets/dor1.jpg",
      "assets/dor2.jpg",
      "assets/dor3.jpg",
      "assets/king.jpg",
    ],
    name: "Dor Bachars",
    bio: "King of the universe",
  ),
  new Profile(
    photos: [
      "assets/erez1.jpg",
      "assets/erez2.jpg",
      "assets/erez3.jpg",
    ],
    name: "Erez",
    bio: "I like to sleep",
  ),
  new Profile(
    photos: [
      "assets/yoni1.jpg",
      "assets/yoni2.jpg",
      "assets/yoni3.jpg",
    ],
    name: "Yoni",
    bio: "I want Dor",
  ),
  Profile(
    photos: [
      "assets/gigi1.jpg",
      "assets/gigi2.jpg",
      "assets/gigi3.jpg",],
        name:"Gigi",
        bio:"Want Dor"

  ),
  Profile(
      photos: [
        "assets/alessandra1.jpg",
        "assets/alessandra2.jpg",],
      name:"Alessandra",
      bio:"Want Dor!!!"

  ),

  Profile(
    photos: ['assets/cloe.jpg'],
    name:"Cloe",
    bio:"Want dor!!!"
  ),
  Profile(
      photos: ['assets/romanova.jpg'],
      name:"Romanova",
      bio:"Want dor!!!"
  ),
  Profile(
      photos: ['assets/daniela.jpg'],
      name:"Daniella",
      bio:"Want dor!!!"
  )

];



final List<Profile> moreDemoProfile=[

];

class Profile {
  final List<String> photos;
  final String name;
  final String bio;

  Profile({this.photos, this.name, this.bio});
}

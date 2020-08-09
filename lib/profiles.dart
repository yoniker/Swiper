final List<Profile> demoProfiles = [
   Profile(
    photos: [
      "assets/dor1.jpg",
      "assets/dor2.jpg",
      "assets/dor3.jpg",
      "assets/king.jpg",
    ],
    name: "דור בכר",
    bio: "מלך היקום",
  ),

   Profile(
    photos: [
      "assets/yoni1.jpg",
      "assets/yoni2.jpg",
      "assets/yoni3.jpg",
    ],
    name: "יוני קרן",
    bio: "אני מעוניין בכל אחת שתתפשר עליי במקום דור",
  ),
  Profile(
    photos: [
      "assets/gigi1.jpg",
      "assets/gigi2.jpg",
      "assets/gigi3.jpg",],
        name:"ג'יג'י",
        bio:"אני רוצה את דור"

  ),
  Profile(
      photos: [
        "assets/alessandra1.jpg",
        "assets/alessandra2.jpg",],
      name:"Alessandra",
      bio:"מוכנה לחכות עד השניה האחרונה של החיים,רק דור!"

  ),



];



final List<Profile> moreDemoProfile=[
  Profile(
      photos: ['assets/cloe.jpg'],
      name:"קלואי",
      bio:"אני אעשה הכל בשביל דור, מי שהוא לא דור בבקשה להפסיק להטריד"
  ),
  Profile(
      photos: ['assets/romanova.jpg'],
      name:"רומנובה",
      bio:"דור שם עליי זין,איזה כיף!!!"
  ),
  Profile(
      photos: ['assets/daniela.jpg'],
      name:"Daniella",
      bio:"Want dor!!!"
  )
];

class Profile {
  final List<String> photos;
  final String name;
  final String bio;

  Profile({this.photos, this.name, this.bio});
}

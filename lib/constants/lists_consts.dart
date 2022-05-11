cmToFeet(centimeters) {
  double height = centimeters / 2.54;
  double inch = height % 12;
  double feet = height / 12;
  return ("${feet.toInt()}' ${inch.toInt()}");
}

const List<String> kReligionsList = [
  'Select option',
  'Atheist',
  'Bahá’í',
  'Buddhist',
  'Christian',
  'Confucian',
  'Druze',
  'Gnostic',
  'Hindu',
  'Muslim',
  'Jain',
  'Jewish',
  'Rastafarian',
  'Shin',
  'Sikh',
  'Zoroastrian',
  'African',
  'Dias',
  'Indigenous',
  'Other'
];

const List<String> kZodiacsList = [
  'Select option',
  'Capricorn  ♑',
  'Aquarius  ♒',
  'Pisces  ♓',
  'Aries  ♈',
  'Taurus  ♉',
  'Gemini  ♊',
  'Cancer  ♋',
  'Leo  ♌',
  'Virgo  ♍',
  'Libra  ♎',
  'Scorpio  ♏',
  'Sagittarius  ♐'
];

const List<String> kEducationChoices = [
  'High School',
  'Undergraduate',
  'Postgraduate'
];
const List<String> kFitnessChoices = ['Active', 'Occasionally', 'Never'];

const List<String> kGenderChoices = ['Female', 'Male'];
String kFemaleGender = kGenderChoices.first;

const List<String> kIntoChoices = ['Men', 'Women', 'Everyone'];

const List<String> kSmokingChoices = ['Regularly', 'Socially', 'Never'];

const List<String> kChildrenChoice = [
  'Have & no more',
  'Have & want more',
  'Want someday',
  "Don't want",
  'Not sure',
];

const List<String> kRelationshipTypeChoices = [
  'Marriage',
  'Relationship',
  'Something casual',
  'Prefer not to say'
];

const List<String> kPromotesForPreferredGender = [
  'We will only show you men',
  'We will only show you women',
  'We will show you everyone'
];

const List<String> kHobbiesList = [
  'Dogs  🐕',
  'Cats  🐈',
  'Art  🎨',
  'Dancing  💃',
  'Make-up  💄',
  'Singing  🎤',
  'Photography  📷',
  'Cycling  🚲',
  'Swimming  🏊‍♀️',
  'Working-out  💪',
  'Sports  🏒',
  'Yoga  🧘',
  'Bars  🍻',
  'Coffee-shops  ☕',
  'Movies  🎦',
  'TV-shows  📺',
  'Festivals  🎇',
  'Cooking  🍳',
  'Gaming  🕹️',
  'Social games  🎲',
  'Reading  📚',
  'Music  🎵',
  'Sushi  🍣',
  'Pizza  🍕',
  'Barbeque  🍖',
  'Vegan  🥗',
  'Sweets  🍬',
  'Camping  ⛺',
  'Backpacking  🏕️',
  'Hiking  ⛰',
  'Travel  🛫',
  'Fishing  🎣',
  'Beach  🏖️',
  'Winter activities  🎿',
];

const List<String> kPetsList = [
  'Fish  🐟',
  'Dog  🐕',
  'Cat  🐈',
  'Reptile  🦎',
  'Bird  🐦',
  'Horse  🐎',
  'Rabbit  🐇',
  'Poultry  🐔',
  'Hamster  🐹',
  'Turtle  🐢',
  'Spider  🕷️',
  'Snake  🐍',
  'Ferret  🐭',
  'Frog  🐸',
  'Guinea pig  🐹',
  'Hedgehog  🦔',
  'Other  🐐',
  'No pets'
];

const List<String> kEmptyBubbles = [
  'Add here',
];

const List<String> kEmptyPets = ['No pets'];

// Here we generate a list of numbers and use them to create a list with 129 numbers which we want to use as cm, we tell the list to start at number 91
int startingCm = 91;
List<String> kHeightList = List.unmodifiable(List.generate(
    129,
    (index) =>
        (index + startingCm).toString() +
        ' cm (${cmToFeet(index + startingCm)} ft)'));

cmToFeet(centimeters) {
  double height = centimeters / 2.54;
  double inch = height % 12;
  double feet = height / 12;
  return ("${feet.toInt()}' ${inch.toInt()}");
}

List<String> kReligionsList = [
  'Atheism/Agnosticism',
  'Bahá’í',
  'Buddhism',
  'Christianity',
  'Confucianism',
  'Druze',
  'Gnosticism',
  'Hinduism',
  'Islam',
  'Jainism',
  'Judaism',
  'Rastafarianism',
  'Shinto',
  'Sikhism',
  'Zoroastrianism',
  'Traditional African Religions',
  'African Diaspora Religions',
  'Indigenous American Religions',
  'Other'
];

List<String> kZodiacsList = [
  'Capricorn',
  'Aquarius',
  'Pisces',
  'Aries',
  'Taurus',
  'Gemini',
  'Cancer',
  'Leo',
  'Virgo',
  'Libra',
  'Scorpio',
  'Sagittarius'
];

List<String> kHobbiesList = [
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

List<String> kPetsList = [
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
  'Other  🐐'
];

List<String> kEmptyBubbles = [
  'Spa  🛁',
  'Cycling  🚲',
  'Music  🎹',
];

List<String> kEmptyPets = ['No pets'];

// Here we generate a list of numbers and use them to create a list with 129 numbers which we want to use as cm, we tell the list to start at number 91
int startingCm = 91;
List<String> kHeightList = List.generate(
    129,
    (index) =>
        (index + startingCm).toString() +
        ' cm (${cmToFeet(index + startingCm)} ft)');

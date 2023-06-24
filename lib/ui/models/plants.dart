class Plant {
  final int plantId;
  final String size;
  final int humidity;
  final String temperature;
  final String category;
  final String plantName;
  final String imageURL;
  bool isFavorated;
  final String decription;
  bool isSelected;

  Plant(
      {required this.plantId,
       
        required this.category,
        required this.plantName,
        required this.size,
        required this.humidity,
        required this.temperature,
        required this.imageURL,
        required this.isFavorated,
        required this.decription,
        required this.isSelected});

  //List of Plants data
  static List<Plant> plantList = [
    Plant(
        plantId: 0,
        category: 'Outdoor',
        plantName: 'Alcea biennis',
        size: 'Medium',
     
        humidity: 34,
        temperature: '15 - 34',
        imageURL: 'assets/alcea_biennis.png',
        isFavorated: true,
        decription:
        'Alcea biennis, is a tall biennial plant native to Europe, Asia, and North Africa.'
        'It features a robust, fuzzy-haired stem and large oblong leaves arranged in a basal rosette during the first year. In the second year, a tall flowering stalk emerges, bearing sequential yellow flowers that attract pollinators. The plant produces small seeds in a capsule, aided by a downy covering for wind dispersal. Common mullein has a history of medicinal use and is cultivated for its ornamental value. It thrives in well-drained soils and full sunlight, often found in open fields, meadows, roadsides, and disturbed areas',
        isSelected: false),
    Plant(
        plantId: 1,
        category: 'Indoor',
        plantName: 'Alocasia zebrina',
        size: 'Large',
        humidity: 70,
        temperature: '18 - 29',
        imageURL: 'assets/alocasia-zebrina.png',
        isFavorated: false,
        decription:
        'Alocasia Zebrina, or Zebrina plant, is a tropical plant with large, arrow-shaped leaves. Its leaves have vibrant green coloration with prominent white veins resembling zebra stripes. This compact plant reaches a height of 2-3 feet and is popular for its unique foliage. It thrives in warm and humid environments, making it suitable as an indoor houseplant. Alocasia Zebrina requires well-draining soil, indirect light, and regular watering.',
        isSelected: false),
    Plant(
        plantId: 2,
        category: 'Outdoor',
        plantName: 'Anemone blanda',
        size: 'Small',
        humidity: 40,
        temperature: '10 - 21',
        imageURL: 'assets/anemona_blanda.PNG',
        isFavorated: false,
        decription:
          'Anemone blanda, or Grecian Windflower, is a perennial flowering plant native to southeastern Europe and southwestern Asia. It produces delicate, daisy-like flowers in shades of blue, pink, and white during early spring. This low-maintenance plant thrives in well-drained soil and partial shade, making it a popular choice for gardens and rock gardens. It adds a carpet of colorful blooms and attracts pollinators, enhancing the beauty of outdoor spaces.',        
        isSelected: false),
    Plant(
        plantId: 3,
        category: 'Indoor',
        plantName: 'Anthurium andraeanum',
        size: 'Medium',
        humidity: 75,
        temperature: '18 - 27',
        imageURL: 'assets/barbare_vulgaris.PNG',
        isFavorated: false,
        decription:
        'Anthurium andraeanum, commonly known as Flamingo Flower or Painter\'s Palette, is a popular tropical plant native to Colombia and Ecuador. It is characterized by its glossy, heart-shaped leaves and vibrant, waxy flowers. The flowers come in various colors, including shades of red, pink, and white, with a distinctive spadix and colorful spathe.',
        isSelected: false),
    Plant(
        plantId: 4,
        category: 'Outdoor',
        plantName: 'Barbara Vulgaris',
        size: 'Medium',
        humidity: 60,
        temperature: '10 - 21',
        imageURL: 'assets/barbare_vulgaris.PNG',
        isFavorated: true,
        decription:
        'Barbarea vulgaris, also known as Wintercress or Yellow Rocket, is a biennial or perennial herbaceous plant belonging to the mustard family, Brassicaceae. It is native to Europe and parts of Asia and has naturalized in other regions around the world.'
'This plant features clusters of bright yellow flowers and deeply lobed leaves. It typically grows to a height of about 1 to 2 feet (30 to 60 centimeters) and has a bushy growth habit. Barbarea vulgaris is known for its ability to tolerate cool temperatures and is often found in damp meadows, along streams, and in other moist habitats.Barbarea vulgaris has a slightly bitter taste and is sometimes used in culinary applications. ',        isSelected: false),
    Plant(
        plantId: 5,
        category: 'Outdoor',
        plantName: 'Calendula officinalis',
        size: 'Medium',
        humidity: 36,
        temperature: '10 - 21',
        imageURL: 'assets/calendula.png',
        isFavorated: false,
        decription:
        'Calendula officinalis, or Calendula, is a vibrant annual flowering plant native to the Mediterranean region. It is cultivated for its cheerful yellow and orange flowers and is valued for its medicinal properties. Calendula extracts have anti-inflammatory, antimicrobial, and antioxidant effects, making them popular in skincare products. This easy-to-grow plant prefers well-drained soil, moderate watering, and thrives in cool to moderate climates. Additionally, Calendula attracts pollinators and adds a splash of color to gardens.',
        isSelected: false),
    Plant(
        plantId: 6,
        category: 'Outdoor',
        plantName: 'Cirsium vulgare,',
        size: 'Medium',
        humidity: 46,
        temperature: '10 - 29',
        imageURL: 'assets/cirsium-vulgare.png',
        isFavorated: false,
        decription:
        'Cirsium vulgare, commonly known as Bull Thistle or Spear Thistle, is a biennial flowering plant that is native to Europe and Asia. It is recognized for its tall, spiky appearance and distinctive purple or pinkish flowers.'
'Bull Thistle is considered a weed in many regions but is also appreciated for its ecological importance. It provides food and habitat for various pollinators, including bees and butterflies. Despite its reputation as a weed, it has some medicinal uses as well.',
        isSelected: false),
    Plant(
        plantId: 7,
        category: 'Garden',
        plantName: 'Daucus Carota',
        size: 'Medium',
        humidity: 40,
        temperature: '15 - 24',
        imageURL: 'assets/daucus.png',
        isFavorated: false,
        decription:
        'Daucus carota, or Wild Carrot, is a biennial plant known for its white or yellowish taproot. It produces clusters of small white flowers in its second year and is commonly found in open fields and disturbed areas. While related to cultivated carrots, its wild variety is generally not cultivated for its edible root.',
        isSelected: false),
    Plant(
        plantId: 8,
        category: 'Indoor',
        plantName: 'Dendrobium',
        size: 'Medium',
        humidity: 60,
        temperature: '15 - 27',
        imageURL: 'assets/dendrobium.png',
        isFavorated: false,
        decription:
        'Dendrobium is a diverse genus of orchid plants known for their colorful and exotic flowers. They are epiphytic or lithophytic in nature, often growing on trees or rocks. Dendrobium orchids are prized for their beauty and are popular choices for indoor and outdoor cultivation.',
        isSelected: false),
    Plant(
        plantId: 9,
        category: 'Indoor',
        plantName: 'Sedum Burrito',
        size: 'Small',
        humidity: 55,
        temperature: '18 - 24',
        imageURL: 'assets/sedum.png',
        isFavorated: false,
        decription:'Sedum burrito, also known as Burro\'s Tail or Donkey\'s Tail, is a succulent plant characterized by its trailing stems and plump, cylindrical leaves. It is native to Mexico and is a popular choice for hanging baskets and containers.'
            'Sedum burrito prefers warm temperatures and can tolerate a wide range of humidity levels. It thrives in bright, indirect light but can also tolerate some direct sunlight. This low-maintenance plant requires well-draining soil and infrequent watering, allowing the soil to dry out between waterings.',
        isSelected: false),
  ];

  //Get the favorated items
  static List<Plant> getFavoritedPlants(){
    List<Plant> _travelList = Plant.plantList;
    return _travelList.where((element) => element.isFavorated == true).toList();
  }

 
}
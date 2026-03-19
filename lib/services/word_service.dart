import 'dart:math';

class WordService {
  static final Random _random = Random();

  // Base de datos de palabras españolas por categoría (200 palabras)
  static const Map<String, List<String>> _spanishWords = {
    '🍽️ Comidas y Bebidas': [
      'Paella',
      'Tortilla de patatas',
      'Jamón ibérico',
      'Gazpacho',
      'Croquetas',
      'Fabada asturiana',
      'Cocido madrileño',
      'Pulpo a la gallega',
      'Bocadillo de calamares',
      'Churros con chocolate',
      'Miguelitos',
      'Pisto',
      'Patatas bravas',
      'Ensaladilla rusa',
      'Torreznos',
      'Morcilla',
      'Callos',
      'Marmitako',
      'Butifarra',
      'Pan con tomate',
      'Gambas al ajillo',
      'Huevos rotos',
      'Pinchos de tortilla',
      'Tortilla de chorizo',
      'Albóndigas',
      'Huevos rellenos',
      'Arroz con leche',
      'Turrones',
      'Polvorones',
      'Mazapán',
      'Helado de turrón',
      'Cafetería',
      'Chocolatería',
      'Vino tinto',
      'Cerveza española',
    ],
    '🏙️ Ciudades y Pueblos': [
      'Madrid',
      'Barcelona',
      'Sevilla',
      'Granada',
      'Valencia',
      'Bilbao',
      'Salamanca',
      'Toledo',
      'Córdoba',
      'San Sebastián',
      'Málaga',
      'Zaragoza',
      'Palma de Mallorca',
      'Las Palmas de Gran Canaria',
      'Alicante',
      'Vigo',
      'Gijón',
      'Lleida',
      'Pamplona',
      'Santiago de Compostela',
      'Burgos',
      'Oviedo',
      'Santander',
      'Badajoz',
      'Cáceres',
      'Huelva',
      'Almería',
      'Girona',
      'Lugo',
      'Ávila',
    ],
    '🎉 Tradiciones y Festividades': [
      'La Tomatina',
      'San Fermín',
      'Fallas de Valencia',
      'Carnaval de Cádiz',
      'Feria de Abril',
      'Romería del Rocío',
      'Semana Santa',
      'Castells',
      'Correfocs',
      'Noche de San Juan',
      'Cabalgata de Reyes',
      'Moros y Cristianos',
      'Fiestas del Pilar',
      'Batalla de Flores',
      'Mercé',
      'San Juan',
      'Halloween en España',
      'Navidad',
      'Reyes Magos',
      'Día de la Constitución',
      'Primero de Mayo',
      'Fiesta de la Vendimia',
      'Ruta de la Tapa',
      'Fiesta del Agua',
      'Feria del Libro',
    ],
    '👥 Personajes y Famosos': [
      'Picasso',
      'Cervantes',
      'Dalí',
      'Gaudí',
      'Velázquez',
      'Goya',
      'El Cid',
      'Isabel la Católica',
      'Fernando el Católico',
      'Antonio Banderas',
      'Penélope Cruz',
      'Javier Bardem',
      'Pedro Almodóvar',
      'Unamuno',
      'Federico García Lorca',
      'Antonio Machado',
      'Rosalía',
      'Aitana',
      'Ana Mena',
      'Alejandro Sanz',
      'David Bisbal',
      'Pablo Alborán',
      'Rafael Nadal',
      'Carlos Alcaraz',
      'Fernando Alonso',
      'Marc Márquez',
      'La Casa de Papel',
      'Élite',
      'La que se avecina',
      'El Príncipe',
    ],
    '🏛️ Monumentos y Lugares': [
      'La Alhambra',
      'Sagrada Familia',
      'Camino de Santiago',
      'Plaza Mayor',
      'Puerta del Sol',
      'Museo del Prado',
      'Mezquita de Córdoba',
      'Catedral de Santiago',
      'Alcázar de Segovia',
      'Guggenheim Bilbao',
      'Templo de Debod',
      'Palacio Real',
      'Catedral de Burgos',
      'Monasterio de El Escorial',
      'Ciudad de las Artes',
      'Gran Vía',
      'Paseo de la Castellana',
      'Puerta de Alcalá',
      'Parque del Retiro',
      'Ciudad Lineal',
      'Barrio de Salamanca',
      'La Latina',
      'Malasaña',
      'Chueca',
      'Lavapiés',
    ],
    '⚽ Deportes y Eventos': [
      'Fútbol',
      'Baloncesto',
      'Tenis',
      'Fórmula 1',
      'MotoGP',
      'Ciclismo',
      'Vela',
      'Pádel',
      'Balonmano',
      'Waterpolo',
      'Atletismo',
      'Natación',
      'Equitación',
      'Gym',
      'CrossFit',
      'Maratón',
      'Triatlón',
      'Rugby',
      'Hockey hierba',
      'Surf',
    ],
    '📺 Televisión y Streaming': [
      'La Casa de Papel',
      'Élite',
      'La que se avecina',
      'El Príncipe',
      'MasterChef',
      'Operación Triunfo',
      'Pesadilla en el paraíso',
      'Allí abajo',
      'Telecinco',
      'Antena 3',
      'La Sexta',
      'TVE',
      'Netflix España',
      'HBO España',
      'Disney+',
      'Amazon Prime',
      'Movistar+',
      'Real Madrid TV',
      'Barça TV',
      'Atresmedia',
    ],
    '🐶 Animales': [
      'Toro bravo',
      'Caballo andaluz',
      'Lince ibérico',
      'Oso pardo',
      'Lobo',
      'Águila imperial',
      'Flamenco',
      'Pato real',
      'Cerdo ibérico',
      'Gato montés',
      'Zorro',
      'Jabalí',
      'Venado',
      'Cabra montés',
      'Cigüeña blanca',
    ],
  };

  /// Obtiene una palabra aleatoria de todas las categorías
  static WordPair getRandomWord() {
    final categories = _spanishWords.keys.toList();
    final randomCategory = categories[_random.nextInt(categories.length)];
    final wordsInCategory = _spanishWords[randomCategory]!;
    final randomWord = wordsInCategory[_random.nextInt(wordsInCategory.length)];

    return WordPair(category: randomCategory, word: randomWord);
  }

  /// Obtiene una palabra aleatoria de una categoría específica
  static WordPair getRandomWordFromCategory(String category) {
    final words = _spanishWords[category];
    if (words == null || words.isEmpty) {
      throw ArgumentError('Categoría no encontrada: $category');
    }
    final randomWord = words[_random.nextInt(words.length)];
    return WordPair(category: category, word: randomWord);
  }

  /// Obtiene todas las categorías disponibles
  static List<String> getCategories() {
    return _spanishWords.keys.toList()..sort();
  }

  /// Obtiene todas las palabras de una categoría
  static List<String> getWordsByCategory(String category) {
    return _spanishWords[category] ?? [];
  }

  /// Obtiene el número total de palabras en la base de datos
  static int get totalWords {
    return _spanishWords.values.fold<int>(0, (sum, list) => sum + list.length);
  }

  /// Obtiene una lista de categorías con su número de palabras
  static Map<String, int> getCategoriesStats() {
    final stats = <String, int>{};
    for (var entry in _spanishWords.entries) {
      stats[entry.key] = entry.value.length;
    }
    return stats;
  }
}

class WordPair {
  final String category;
  final String word;

  WordPair({
    required this.category,
    required this.word,
  });

  @override
  String toString() {
    return 'WordPair{category: $category, word: $word}';
  }
}

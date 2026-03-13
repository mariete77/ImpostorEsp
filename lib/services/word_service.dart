import 'dart:math';

class WordService {
  static final Random _random = Random();

  // Base de datos de palabras españolas por categoría
  static const Map<String, List<String>> _spanishWords = {
    'Comidas': [
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
    ],
    'Ciudades': [
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
    ],
    'Tradiciones': [
      'La Tomatina',
      'San Fermín',
      'Fallas de Valencia',
      'Carnaval de Cádiz',
      'Feria de Abril',
      'Romería del Rocío',
      'Semana Santa',
      'Castells',
      'Correfocs',
      'Merengada',
      'Noche de San Juan',
      'Mercado de Navidad',
      'Cabalgata de Reyes',
      'Els Nagol',
      'Bolo de la Encina',
      'Moros y Cristianos',
      'Fiestas del Pilar',
      'Batalla de Flores',
      'Ofrenda a la Virgen',
      'Entrada de Moros',
    ],
    'Personajes': [
      'Picasso',
      'Cervantes',
      'Dalí',
      'Gaudí',
      'Velázquez',
      'Goya',
      'El Cid',
      'Isabel la Católica',
      'Fernando el Católico',
      'Felipe II',
      'Carlos I',
      'Juan Carlos I',
      'Sara Montiel',
      'Antonio Banderas',
      'Penélope Cruz',
      'Javier Bardem',
      'Pedro Almodóvar',
      'Miguel de Unamuno',
      'Federico García Lorca',
      'Antonio Machado',
    ],
    'Monumentos': [
      'La Alhambra',
      'Sagrada Familia',
      'Camino de Santiago',
      'Plaza Mayor',
      'Puerta del Sol',
      'Museo del Prado',
      'Mezquita de Córdoba',
      'Cathedral of Santiago',
      'Alcázar de Segovia',
      'Guggenheim Bilbao',
      'Templo de Debod',
      'Palacio Real',
      'Campo de Cricket',
      'Catedral de Burgos',
      'Monasterio de El Escorial',
      'Ciudad de las Artes',
      'Gran Vía',
      'Paseo de la Castellana',
      'Puerta de Alcalá',
      'Arco del Triunfo',
    ],
    'Deportes': [
      'Fútbol',
      'Baloncesto',
      'Tenis',
      'Fórmula 1',
      'MotoGP',
      'Ciclismo',
      'Vela',
      'Hípica',
      'Balonmano',
      ' waterpolo',
      'Atletismo',
      'Natación',
      'Esgrima',
      'Gimnasia rítmica',
      'Pádel',
      'Pelota vasca',
      'Jai alai',
      'Rugby',
      'Hockey hierba',
      'Surf',
    ],
    'Animales': [
      'Toro bravo',
      'Caballo andaluz',
      'Iberian lynx',
      'Bear cantábrico',
      'Wolves',
      'Iberian imperial eagle',
      'Flamenco',
      'Pato real',
      'Iberian pig',
      'Churra sheep',
      'Gato montés',
      'Zorro',
      'Jabalí',
      'Venado',
      'Cabra montés',
      'Buitre leonado',
      'Águila real',
      'Búho real',
      'Martín pescador',
      'Cigüeña blanca',
    ],
    'Plantas/Flores': [
      'Encina',
      'Pino',
      'Almendro',
      'Olivar',
      'Viña',
      'Naranjo',
      'Limonero',
      'Rosal',
      'Geranio',
      'Orquídea',
      'Azucena',
      'Jazmín',
      'Lavanda',
      'Tomillo',
      'Romero',
      'Salvia',
      'Menta',
      'Albahaca',
      'Hierbabuena',
      'BIOdiversidad',
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

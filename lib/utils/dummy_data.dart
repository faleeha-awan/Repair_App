import '../models/models.dart';

class DummyData {
  // Dummy guides for testing
  static List<Guide> get dummyGuides => [
    Guide(
      id: '1',
      title: 'Fix iPhone Screen Replacement',
      thumbnailUrl: null, // Will use placeholder in UI
      lastOpened: DateTime.now().subtract(const Duration(hours: 2)),
      totalSteps: 8,
      completedSteps: 3,
      isBookmarked: true,
    ),
    Guide(
      id: '2',
      title: 'Laptop Battery Replacement',
      thumbnailUrl: null,
      lastOpened: DateTime.now().subtract(const Duration(days: 1)),
      totalSteps: 6,
      completedSteps: 6,
      isBookmarked: false,
    ),
    Guide(
      id: '3',
      title: 'TV Remote Control Repair',
      thumbnailUrl: null,
      lastOpened: DateTime.now().subtract(const Duration(days: 3)),
      totalSteps: 4,
      completedSteps: 1,
      isBookmarked: true,
    ),
    Guide(
      id: '4',
      title: 'Washing Machine Drain Cleaning',
      thumbnailUrl: null,
      lastOpened: DateTime.now().subtract(const Duration(days: 7)),
      totalSteps: 5,
      completedSteps: 0,
      isBookmarked: false,
    ),
    Guide(
      id: '5',
      title: 'Car Headlight Bulb Replacement',
      thumbnailUrl: null,
      lastOpened: DateTime.now().subtract(const Duration(days: 14)),
      totalSteps: 3,
      completedSteps: 2,
      isBookmarked: true,
    ),
  ];

  // Dummy chat messages for testing
  static List<ChatMessage> get dummyChatMessages => [
    ChatMessage(
      id: '1',
      content: 'Hi! Upload your product manual or ask me any repair question.',
      type: MessageType.bot,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    ChatMessage(
      id: '2',
      content: 'How do I replace the screen on my iPhone 12?',
      type: MessageType.user,
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    ChatMessage(
      id: '3',
      content: 'I can help you with iPhone 12 screen replacement! First, you\'ll need the right tools: a pentalobe screwdriver, suction cup, and plastic opening tools. Would you like me to walk you through the steps?',
      type: MessageType.bot,
      timestamp: DateTime.now().subtract(const Duration(minutes: 24)),
    ),
  ];

  // Get recent guides (first 3 from dummy data)
  static List<Guide> get recentGuides => dummyGuides.take(3).toList();

  // Get saved guides (bookmarked guides from dummy data)
  static List<Guide> get savedGuides => 
      dummyGuides.where((guide) => guide.isBookmarked).toList();

  // Categories for search screen
  static List<Map<String, dynamic>> get repairCategories => [
    {
      'name': 'Electronics',
      'icon': 'devices',
      'subcategories': [
        'Smartphones',
        'Laptops',
        'Tablets',
        'Gaming Consoles',
        'TVs & Monitors',
        'Audio Equipment',
      ],
    },
    {
      'name': 'Appliances',
      'icon': 'kitchen',
      'subcategories': [
        'Washing Machines',
        'Refrigerators',
        'Dishwashers',
        'Microwaves',
        'Air Conditioners',
        'Vacuum Cleaners',
      ],
    },
    {
      'name': 'Automotive',
      'icon': 'directions_car',
      'subcategories': [
        'Engine',
        'Brakes',
        'Electrical',
        'Transmission',
        'Suspension',
        'Body & Paint',
      ],
    },
    {
      'name': 'Home & Garden',
      'icon': 'home',
      'subcategories': [
        'Plumbing',
        'Electrical',
        'HVAC',
        'Doors & Windows',
        'Flooring',
        'Garden Tools',
      ],
    },
    {
      'name': 'Tools & Equipment',
      'icon': 'build',
      'subcategories': [
        'Power Tools',
        'Hand Tools',
        'Measuring Equipment',
        'Safety Equipment',
        'Workshop Equipment',
      ],
    },
  ];
}
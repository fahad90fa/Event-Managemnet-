import '../domain/rasala_entities.dart';

class MockRasalaService {
  Future<List<RasalaGuide>> getGuides() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      const RasalaGuide(
        id: '1',
        ceremonyName: 'Mehndi',
        ceremonyDate: 'Oct 24, 2026',
        venueName: 'Royal Palm Marquee',
        description:
            'The Mehndi is a vibrant, fun-filled night of music, dance, and traditional henna application.',
        traditions: [
          CeremonyTradition(
            title: 'Rasm-e-Hina',
            description:
                'The elders of the family apply oil and henna to the bride/groom\'s palms.',
            culturalSignificance:
                'Symbolizes the beginning of the wedding festivities and blessings from elders.',
          ),
          CeremonyTradition(
            title: 'Ladoo Distribution',
            description:
                'Distribution of sweets among guests after the henna ritual.',
          ),
        ],
        dos: [
          'Wear vibrant colors (Yellow, Green, Orange)',
          'Join the dance floor during the "Luddi"',
          'Try the traditional Gol-Gappay stall'
        ],
        donts: [
          'Don\'t wear overly formal black/white attire',
          'Avoid touching the henna until it is dry'
        ],
        premiumBackgroundUrl:
            'https://images.unsplash.com/photo-1598124838123-01824955fbd4?w=800',
      ),
      const RasalaGuide(
        id: '2',
        ceremonyName: 'Baraat',
        ceremonyDate: 'Oct 25, 2026',
        venueName: 'The PC Hall',
        description:
            'The main event where the groom arrives with his family and friends to take the bride.',
        traditions: [
          CeremonyTradition(
            title: 'Nikah',
            description: 'The formal signing of the marriage contract.',
            culturalSignificance:
                'The core religious and legal ceremony in Islam.',
          ),
          CeremonyTradition(
            title: 'Doodh Pilai',
            description:
                'The sisters of the bride bring milk for the groom, often involving humorous negotiations.',
          ),
        ],
        dos: [
          'Be punctual for the Nikah ceremony',
          'Have your QR code ready for check-in'
        ],
        donts: [
          'Don\'t block the photographers\' line of sight',
        ],
        premiumBackgroundUrl:
            'https://images.unsplash.com/photo-1545232979-8bf3cce824ca?w=800',
      ),
    ];
  }
}

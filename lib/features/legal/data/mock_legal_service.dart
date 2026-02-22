import '../domain/legal_entities.dart';

class MockLegalService {
  Future<List<OfficialDocument>> getDocuments() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      const OfficialDocument(
        id: 'doc-1',
        title: 'Nikahnama (Urdu)',
        description: 'The primary religious and legal marriage contract.',
        status: DocumentStatus.verified,
        fileUrl: 'https://example.com/nikah-sample.pdf',
      ),
      const OfficialDocument(
        id: 'doc-2',
        title: 'Marriage Registration Certificate (NADRA)',
        description: 'Official computerised certificate from NADRA.',
        status: DocumentStatus.pending,
        isRequired: true,
      ),
      const OfficialDocument(
        id: 'doc-3',
        title: 'Venue Rental Agreement',
        description: 'Contract signed with Royal Palm Marquee.',
        status: DocumentStatus.verified,
        fileUrl: 'https://example.com/venue-contract.pdf',
      ),
    ];
  }

  Future<List<LegalTask>> getLegalTasks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      const LegalTask(
        id: 'task-1',
        title: 'CNIC Marital Status Update',
        description:
            'Update your status to "Married" at any NADRA Executive center.',
        isCompleted: false,
        urgency: 'high',
        steps: [
          'Take original Nikahnama & its copy',
          'Take spouse\'s CNIC copy',
          'Visit NADRA Executive center (No appointment needed)',
          'Pay fee (approx PKR 1500-2500 for Executive)',
          'Biometrics & Photo'
        ],
      ),
      const LegalTask(
        id: 'task-2',
        title: 'Passport Name/Status Change',
        description: 'Required for International travel as a couple.',
        isCompleted: false,
        urgency: 'medium',
        steps: [
          'Update CNIC first (Required)',
          'Visit Regional Passport Office',
          'Submit application with updated CNIC'
        ],
      ),
      const LegalTask(
        id: 'task-3',
        title: 'Joint Bank Account Opening',
        description: 'Merge finances for easier household management.',
        isCompleted: true,
        urgency: 'low',
        steps: [
          'Visit Bank branch together',
          'Submit updated CNICs',
          'Sign joint account mandate'
        ],
      ),
    ];
  }
}

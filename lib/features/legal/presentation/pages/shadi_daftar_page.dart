import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wedding_app/features/legal/domain/legal_entities.dart';
import 'package:wedding_app/features/legal/data/mock_legal_service.dart';

class ShadiDaftarPage extends StatefulWidget {
  const ShadiDaftarPage({super.key});

  @override
  State<ShadiDaftarPage> createState() => _ShadiDaftarPageState();
}

class _ShadiDaftarPageState extends State<ShadiDaftarPage> {
  final MockLegalService _service = MockLegalService();
  List<OfficialDocument> _documents = [];
  List<LegalTask> _tasks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final docs = await _service.getDocuments();
    final tasks = await _service.getLegalTasks();
    setState(() {
      _documents = docs;
      _tasks = tasks;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: Text('Shadi-Daftar',
            style: GoogleFonts.playfairDisplay(
                fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.security, color: Colors.green),
            tooltip: 'Encrypted Vault',
            onPressed: () {},
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildVaultSummary(),
                const SizedBox(height: 32),
                _buildSectionHeader('Digital Vault', 'Secure document storage'),
                const SizedBox(height: 12),
                ..._documents.map((doc) => _buildDocumentTile(doc)),
                const SizedBox(height: 32),
                _buildSectionHeader(
                    'Official Procedures', 'Post-wedding legalities'),
                const SizedBox(height: 12),
                ..._tasks.map((task) => _buildTaskCard(task)),
                const SizedBox(height: 40),
              ],
            ),
    );
  }

  Widget _buildVaultSummary() {
    final verifiedCount =
        _documents.where((d) => d.status == DocumentStatus.verified).length;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          const Icon(Icons.folder_shared, size: 48, color: Colors.blueGrey),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Document Status',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                    '$verifiedCount Verified • ${_documents.length - verifiedCount} Pending',
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          CircularProgressIndicator(
            value: verifiedCount / _documents.length,
            strokeWidth: 8,
            backgroundColor: Colors.white,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style:
                GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(subtitle,
            style: GoogleFonts.inter(color: Colors.grey, fontSize: 13)),
      ],
    );
  }

  Widget _buildDocumentTile(OfficialDocument doc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(Icons.description,
            color: doc.status == DocumentStatus.verified
                ? Colors.blue
                : Colors.grey),
        title: Text(doc.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(doc.description, style: const TextStyle(fontSize: 12)),
        trailing: _buildStatusBadge(doc.status),
        onTap: doc.fileUrl != null ? () {} : null,
      ),
    ).animate().fadeIn(delay: 200.ms).slideX();
  }

  Widget _buildStatusBadge(DocumentStatus status) {
    Color color;
    String label;
    switch (status) {
      case DocumentStatus.verified:
        color = Colors.green;
        label = 'Verified';
        break;
      case DocumentStatus.pending:
        color = Colors.orange;
        label = 'Pending';
        break;
      case DocumentStatus.rejected:
        color = Colors.red;
        label = 'Rejected';
        break;
      case DocumentStatus.missing:
        color = Colors.grey;
        label = 'Missing';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTaskCard(LegalTask task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: task.isCompleted ? Colors.green[100]! : Colors.grey[200]!),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(task.title,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle:
              Text(task.description, style: const TextStyle(fontSize: 12)),
          leading: Icon(
              task.isCompleted ? Icons.check_circle : Icons.radio_button_off,
              color: task.isCompleted ? Colors.green : Colors.grey),
          trailing: _buildUrgencyIndicator(task.urgency),
          childrenPadding: const EdgeInsets.all(16),
          children: [
            const Divider(),
            ...task.steps.map((step) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.arrow_right,
                          size: 20, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                          child:
                              Text(step, style: const TextStyle(fontSize: 13))),
                    ],
                  ),
                )),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 400.ms).slideY();
  }

  Widget _buildUrgencyIndicator(String urgency) {
    Color color = urgency == 'high'
        ? Colors.red
        : (urgency == 'medium' ? Colors.orange : Colors.green);
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

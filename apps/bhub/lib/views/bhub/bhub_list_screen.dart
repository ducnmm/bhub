import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../models/bhub_model.dart';
import '../../services/bhub_service.dart';
import 'bhub_detail_screen.dart';

class BHubListScreen extends StatefulWidget {
  const BHubListScreen({super.key});

  @override
  State<BHubListScreen> createState() => _BHubListScreenState();
}

class _BHubListScreenState extends State<BHubListScreen> {
  final BHubService _bhubService = BHubService();
  List<BHubResponse> _bhubs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBHubs();
  }

  Future<void> _loadBHubs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final bhubs = await _bhubService.listBHubs();
      setState(() {
        _bhubs = bhubs;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load BHubs: ${e.toString()}')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToDetail(BHubResponse bhub) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BHubDetailScreen(bhubId: bhub.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity! < 0) {
              Navigator.pushNamed(context, '/profile');
            }
          },
          child: Column(
            children: [
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _bhubs.isEmpty
                        ? const Center(child: Text('No BHubs available'))
                        : RefreshIndicator(
                            onRefresh: _loadBHubs,
                            child: ListView.builder(
                              itemCount: _bhubs.length,
                              itemBuilder: (context, index) {
                                final bhub = _bhubs[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: InkWell(
                                    onTap: () => _navigateToDetail(bhub),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                bhub.location,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: bhub.status == 'open'
                                                      ? Colors.green
                                                      : Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  bhub.status.toUpperCase(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Date: ${DateFormat('MMM dd, yyyy').format(bhub.timeSlot)}',
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                            'Time: ${DateFormat('hh:mm a').format(bhub.timeSlot)}',
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Host: ${bhub.host}',
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                              Text(
                                                '\$${bhub.pricePerPerson.toStringAsFixed(2)} per person',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          LinearProgressIndicator(
                                            value: bhub.currentMembers /
                                                bhub.maxMembers,
                                            backgroundColor: Colors.grey[200],
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              bhub.currentMembers >=
                                                      bhub.maxMembers
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${bhub.currentMembers}/${bhub.maxMembers} members',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

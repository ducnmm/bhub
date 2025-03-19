import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/auth_controller.dart';
import '../../models/bhub_model.dart';
import '../../services/bhub_service.dart';
import '../payment/payment_screen.dart';

class BHubDetailScreen extends StatefulWidget {
  final String? bhubId;

  const BHubDetailScreen({super.key, this.bhubId});

  @override
  State<BHubDetailScreen> createState() => _BHubDetailScreenState();
}

class _BHubDetailScreenState extends State<BHubDetailScreen> {
  final BHubService _bhubService = BHubService();
  BHubResponse? _bhub;
  bool _isLoading = true;
  bool _isJoining = false;

  @override
  void initState() {
    super.initState();
    _loadBHub();
  }

  Future<void> _loadBHub() async {
    if (widget.bhubId == null) {
      Navigator.pop(context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final bhub = await _bhubService.getBHub(widget.bhubId!);
      setState(() {
        _bhub = bhub;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load BHub: ${e.toString()}')));
      Navigator.pop(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _joinBHub() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final userId = authController.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('You must be logged in to join a BHub')));
      return;
    }

    if (_bhub == null) return;

    setState(() {
      _isJoining = true;
    });

    try {
      final response = await _bhubService.joinBHub(widget.bhubId!, userId);

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.message)));

        // Navigate to payment screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              bhubId: widget.bhubId!,
              amount: response.totalPrice,
            ),
          ),
        ).then((_) => _loadBHub()); // Reload BHub after payment
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to join BHub: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isJoining = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authController = Provider.of<AuthController>(context);
    final userId = authController.currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BHub Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _bhub == null
              ? const Center(child: Text('BHub not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _bhub!.location,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _bhub!.status == 'open'
                                          ? Colors.green
                                          : Colors.red,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      _bhub!.status.toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Date: ${DateFormat('EEEE, MMM dd, yyyy').format(_bhub!.timeSlot)}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Time: ${DateFormat('hh:mm a').format(_bhub!.timeSlot)}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.person, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Host: ${_bhub!.host}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Price per person:',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '\$${_bhub!.pricePerPerson.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Card(
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Members',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              LinearProgressIndicator(
                                value:
                                    _bhub!.currentMembers / _bhub!.maxMembers,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _bhub!.currentMembers >= _bhub!.maxMembers
                                      ? Colors.red
                                      : Colors.green,
                                ),
                                minHeight: 10,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${_bhub!.currentMembers}/${_bhub!.maxMembers} members joined',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: (_bhub!.status != 'open' ||
                                  _bhub!.currentMembers >= _bhub!.maxMembers ||
                                  _isJoining)
                              ? null
                              : _joinBHub,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                          ),
                          child: _isJoining
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('Join BHub',
                                  style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

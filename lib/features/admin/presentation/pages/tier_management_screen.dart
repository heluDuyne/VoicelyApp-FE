import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../presentation/bloc/admin_bloc.dart';
import '../../presentation/bloc/admin_event.dart';
import '../../presentation/bloc/admin_state.dart';

class TierManagementScreen extends StatefulWidget {
  const TierManagementScreen({super.key});

  @override
  State<TierManagementScreen> createState() => _TierManagementScreenState();
}

class _TierManagementScreenState extends State<TierManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(LoadTiersEvent());
  }

  void _showTierDialog({Tier? tier}) {
    showDialog(context: context, builder: (context) => _TierDialog(tier: tier));
  }

  void _onDelete(int tierId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: const Color(0xFF1F2937),
            title: const Text(
              'Delete Tier',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Are you sure you want to delete this tier? This might affect users currently on this tier.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<AdminBloc>().add(DeleteTierEvent(tierId));
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101822),
      appBar: AppBar(
        title: const Text(
          'Tier Management',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF101822),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTierDialog(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is ActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is AdminError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TiersLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.tiers.length,
              separatorBuilder: (c, i) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final tier = state.tiers[index];
                return Card(
                  color: const Color(0xFF1F2937),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      tier.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          '\$${tier.pricePerMonth?.toStringAsFixed(2) ?? '0.00'} / month',
                          style: const TextStyle(color: Colors.blueAccent),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Storage: ${tier.maxStorageMb.toInt()} MB', // cast to int for display if needed or keep double
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        Text(
                          'AI Minutes: ${tier.maxAiMinutesPerMonth.toInt()} min',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white70),
                          onPressed: () => _showTierDialog(tier: tier),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => _onDelete(tier.tierId),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _TierDialog extends StatefulWidget {
  final Tier? tier;
  const _TierDialog({this.tier});

  @override
  State<_TierDialog> createState() => _TierDialogState();
}

class _TierDialogState extends State<_TierDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _price;
  late int _storage;
  late int _minutes;

  @override
  void initState() {
    super.initState();
    _name = widget.tier?.name ?? '';
    _price = widget.tier?.pricePerMonth ?? 0.0;
    _storage = widget.tier?.maxStorageMb.toInt() ?? 1000;
    _minutes = widget.tier?.maxAiMinutesPerMonth.toInt() ?? 60;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1F2937),
      title: Text(
        widget.tier == null ? 'Create Tier' : 'Edit Tier',
        style: const TextStyle(color: Colors.white),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _name,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
                validator:
                    (val) => val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => _name = val!,
              ),
              TextFormField(
                initialValue: _price.toString(),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Monthly Price',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
                keyboardType: TextInputType.number,
                validator:
                    (val) => val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => _price = double.parse(val!),
              ),
              TextFormField(
                initialValue: _storage.toString(),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Max Storage (MB)',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
                keyboardType: TextInputType.number,
                validator:
                    (val) => val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => _storage = int.parse(val!),
              ),
              TextFormField(
                initialValue: _minutes.toString(),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'AI Minutes/Month',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
                keyboardType: TextInputType.number,
                validator:
                    (val) => val == null || val.isEmpty ? 'Required' : null,
                onSaved: (val) => _minutes = int.parse(val!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              if (widget.tier == null) {
                context.read<AdminBloc>().add(
                  CreateTierEvent(
                    name: _name,
                    monthlyPrice: _price,
                    maxStorageMb: _storage,
                    maxAiMinutesMonthly: _minutes,
                  ),
                );
              } else {
                context.read<AdminBloc>().add(
                  UpdateTierEvent(
                    tierId: widget.tier!.tierId,
                    name: _name,
                    monthlyPrice: _price,
                    maxStorageMb: _storage,
                    maxAiMinutesMonthly: _minutes,
                  ),
                );
              }
              Navigator.pop(context);
            }
          },
          child: const Text('Save', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}

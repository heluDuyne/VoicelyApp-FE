import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/entities/user.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/admin_event.dart';

class EditUserDialog extends StatefulWidget {
  final User user;

  const EditUserDialog({super.key, required this.user});

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late int _tierId;
  late String _role;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _tierId = widget.user.tierId;
    _role = widget.user.role.value.toLowerCase();
    _isActive = widget.user.isActive;
  }

  @override
  Widget build(BuildContext context) {
    // 0xFF1F2937 is the standard dialog/card background in the app
    // 0xFF282E39 is the standard input field background
    // 0xFF3B82F6 is the primary action color

    return Dialog(
      backgroundColor: const Color(0xFF1F2937),
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    const Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Edit User Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 36.0),
                  child: Text(
                    widget.user.email,
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                ),
                const SizedBox(height: 32),

                // Tier Field
                _buildLabel('Subscription Tier'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF282E39),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _tierId,
                      dropdownColor: const Color(0xFF282E39),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white70,
                      ),
                      isExpanded: true,
                      items:
                          {0, 1, 2, 3, _tierId}.map((id) {
                            return DropdownMenuItem(
                              value: id,
                              child: Text(
                                id == 0
                                    ? 'Free Plan (Tier 0)'
                                    : 'Premium Tier $id',
                              ),
                            );
                          }).toList(),
                      onChanged: (val) => setState(() => _tierId = val!),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Role Field
                _buildLabel('User Role'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF282E39),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _role,
                      dropdownColor: const Color(0xFF282E39),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white70,
                      ),
                      isExpanded: true,
                      items:
                          {'user', 'admin', _role}.map((role) {
                            return DropdownMenuItem(
                              value: role,
                              child: Text(
                                role.toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: (val) => setState(() => _role = val!),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Active Status
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF282E39),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    title: const Text(
                      'Account Active',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      _isActive ? 'User can log in' : 'User access suspended',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                    value: _isActive,
                    onChanged: (val) => setState(() => _isActive = val),
                    activeColor: const Color(0xFF3B82F6),
                    tileColor: Colors.transparent,
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[400],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _onSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey[300],
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }

  void _onSave() {
    context.read<AdminBloc>().add(
      UpdateUserEvent(
        userId: widget.user.id,
        tierId: _tierId,
        role: _role.toUpperCase(),
        isActive: _isActive,
      ),
    );
    Navigator.pop(context);
  }
}

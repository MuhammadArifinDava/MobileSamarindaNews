import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddNewsDialog extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController imageController;

  const AddNewsDialog({
    Key? key,
    required this.titleController,
    required this.descriptionController,
    required this.imageController,
  }) : super(key: key);

  @override
  _AddNewsDialogState createState() => _AddNewsDialogState();
}

class _AddNewsDialogState extends State<AddNewsDialog> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDateTime;
  final _contentController = TextEditingController();
  final List<String> _categories = [
    'Politik',
    'Ekonomi',
    'Teknologi',
    'Sosial',
    'Umum',
  ];
  String? _selectedCategory;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color.fromARGB(255, 15, 34, 64),
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Publish Berita',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'Judul Berita',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: widget.titleController,
                    label: 'Masukkan judul',
                    validatorMsg: 'Judul tidak boleh kosong',
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Deskripsi Berita',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: widget.descriptionController,
                    label: 'Deskripsi',
                    validatorMsg: 'Deskripsi tidak boleh kosong',
                    maxLines: 5,
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Waktu Berita',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'News Time',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      selectedDateTime != null
                          ? selectedDateTime!.toLocal().toString()
                          : 'Belum dipilih',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                    onTap: _pickDateTime,
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'URL Gambar',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: widget.imageController,
                    label: 'Masukkan URL gambar',
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Kategori Berita',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    dropdownColor: const Color.fromARGB(255, 15, 34, 64),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Pilih kategori',
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items:
                        _categories
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kategori tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'Isi Konten Berita',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _contentController,
                    label: 'Konten Berita',
                    maxLines: 5,
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: _saveNews,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            0,
                            97,
                            241,
                          ),
                          minimumSize: const Size(120, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Publish',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
      ),
    );
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _saveNews() async {
    if (_formKey.currentState!.validate()) {
      if (selectedDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan pilih tanggal dan waktu')),
        );
        return;
      }

      final newsData = {
        'title': widget.titleController.text,
        'description': widget.descriptionController.text,
        'time': selectedDateTime!.toUtc().toIso8601String(),
        'image': widget.imageController.text,
        'categories': _selectedCategory ?? 'Uncategorized',
        'content':
            _contentController.text.trim().isEmpty
                ? 'Default content'
                : _contentController.text.trim(),
      };

      try {
        await Supabase.instance.client.from('news').insert(newsData);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Berita berhasil dipublish')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
        }
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? validatorMsg,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      maxLines: maxLines,
      validator:
          validatorMsg != null
              ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return validatorMsg;
                }
                return null;
              }
              : null,
    );
  }
}

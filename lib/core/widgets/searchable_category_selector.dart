import 'package:flutter/material.dart';
import 'package:kauri/core/constants/category_labels.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SearchableCategorySelector extends StatefulWidget {
  final String label;
  final String? initialValue;
  final List<String> categories;
  final ValueChanged<String> onCategorySelected;
  final String? Function(String?)? validator;

  const SearchableCategorySelector({
    super.key,
    required this.label,
    this.initialValue,
    required this.categories,
    required this.onCategorySelected,
    this.validator,
  });

  @override
  State<SearchableCategorySelector> createState() =>
      _SearchableCategorySelectorState();
}

class _SearchableCategorySelectorState
    extends State<SearchableCategorySelector> {
  late TextEditingController _displayController;

  @override
  void initState() {
    super.initState();
    _displayController = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(SearchableCategorySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _displayController.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _displayController.dispose();
    super.dispose();
  }

  void _showCategoryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _CategoryPickerModal(
          categories: widget.categories,
          onSelected: (category) {
            setState(() {
              _displayController.text = category;
            });
            widget.onCategorySelected(category);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _displayController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.category_outlined),
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
      onTap: () => _showCategoryPicker(context),
      validator: widget.validator,
    );
  }
}

class _CategoryPickerModal extends StatefulWidget {
  final List<String> categories;
  final ValueChanged<String> onSelected;

  const _CategoryPickerModal({
    required this.categories,
    required this.onSelected,
  });

  @override
  State<_CategoryPickerModal> createState() => _CategoryPickerModalState();
}

class _CategoryPickerModalState extends State<_CategoryPickerModal> {
  late TextEditingController _searchController;
  List<String> _filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredCategories = widget.categories;
    _searchController.addListener(_filterCategories);
  }

  void _filterCategories() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCategories = widget.categories;
      } else {
        _filteredCategories = widget.categories
            .where((c) => c.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mq = MediaQuery.of(context);

    return Container(
      height: mq.size.height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.backgroundDark
            : AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[700]
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _searchController,
            autofocus: true,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
            decoration: InputDecoration(
              hintText: l10n.search,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.surfaceDark
                  : Colors.grey[100],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount:
                  _filteredCategories.length +
                  (_searchController.text.isNotEmpty ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _filteredCategories.length) {
                  final category = _filteredCategories[index];
                  return ListTile(
                    title: Text(CategoryLabels.display(context, category)),
                    onTap: () => widget.onSelected(category),
                  );
                } else if (_searchController.text.isNotEmpty) {
                  return ListTile(
                    leading: const Icon(Icons.add, color: AppColors.primary),
                    title: Text(
                      "${l10n.addCustomCategory} \"${_searchController.text}\"",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () => widget.onSelected(_searchController.text),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

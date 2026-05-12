import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:school_assgn/widget/text_widget.dart';

class FilterBar extends StatefulWidget {
  const FilterBar({
    super.key,
    this.fitsYourDeviceOnly = true,
    this.onFitsYourDeviceChanged,
  });

  final bool fitsYourDeviceOnly;
  final ValueChanged<bool>? onFitsYourDeviceChanged;

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  late bool isSwitched;

  @override
  void initState() {
    super.initState();
    isSwitched = widget.fitsYourDeviceOnly;
  }

  @override
  void didUpdateWidget(covariant FilterBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fitsYourDeviceOnly != widget.fitsYourDeviceOnly) {
      isSwitched = widget.fitsYourDeviceOnly;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Apply Any Filter',
            variant: AppTextVariant.body,
            fontSize: 14,
            color: AppColor.kTextSecondary,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _buildFilterChip("Newest"),
                      const SizedBox(width: 8),
                      _buildFilterChip("Price"),
                      const SizedBox(width: 8),
                      _buildFilterChip("Condition"),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
          
              // Laptop Icon
              SvgPicture.asset(
                'assets/icons/laptop-minimal.svg',
                colorFilter: ColorFilter.mode(AppColor.kGoogleBlue, BlendMode.srcIn),
              ),
              const SizedBox(width: 6),
          
              // Custom Switch
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSwitched = !isSwitched;
                  });
                  widget.onFitsYourDeviceChanged?.call(isSwitched);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 46,
                  height: 28,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: isSwitched ? Colors.blue.shade600 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 160),
                    curve: Curves.easeOut,
                    alignment: isSwitched
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: AppColor.kTextSecondary,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black54),
        ],
      ),
    );
  }
}

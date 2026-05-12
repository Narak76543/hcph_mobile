import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:school_assgn/themes/app_color.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationPickerField extends StatefulWidget {
  final String? initialGoogleMapsUrl;
  final double? initialLat;
  final double? initialLng;
  final void Function(double lat, double lng, String mapsUrl)
  onLocationSelected;

  const LocationPickerField({
    super.key,
    this.initialGoogleMapsUrl,
    this.initialLat,
    this.initialLng,
    required this.onLocationSelected,
  });

  @override
  State<LocationPickerField> createState() => _LocationPickerFieldState();
}

class _LocationPickerFieldState extends State<LocationPickerField> {
  static const LatLng _phnomPenh = LatLng(11.5564, 104.9282);

  final TextEditingController _urlController = TextEditingController();
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  bool _showMap = false;
  bool _isLocating = false;
  bool _isUpdatingText = false;

  @override
  void initState() {
    super.initState();
    _urlController.text = widget.initialGoogleMapsUrl ?? '';
    _urlController.addListener(_handleUrlChanged);

    if (widget.initialLat != null && widget.initialLng != null) {
      _selectedLocation = LatLng(widget.initialLat!, widget.initialLng!);
      if (_urlController.text.trim().isEmpty) {
        _setText(_buildMapsUrl(_selectedLocation!));
      }
    } else if (_urlController.text.trim().isNotEmpty) {
      _selectedLocation = _parseLatLng(_urlController.text.trim());
    }
  }

  @override
  void didUpdateWidget(covariant LocationPickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextUrl = widget.initialGoogleMapsUrl ?? '';
    if (nextUrl != oldWidget.initialGoogleMapsUrl &&
        nextUrl != _urlController.text) {
      _setText(nextUrl);
      final parsed = _parseLatLng(nextUrl);
      if (parsed != null) {
        _selectLocation(parsed, notify: false);
      }
    }
  }

  @override
  void dispose() {
    _urlController.removeListener(_handleUrlChanged);
    _urlController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _handleUrlChanged() {
    if (_isUpdatingText) return;
    final parsed = _parseLatLng(_urlController.text.trim());
    if (parsed == null) return;
    _selectLocation(parsed);
  }

  Future<void> _requestCurrentLocation() async {
    try {
      setState(() => _isLocating = true);

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationError('Location services are disabled.');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationError('Location permission denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationError(
          'Location permission permanently denied. Please enable it in settings.',
        );
        await Geolocator.openAppSettings();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      _selectLocation(LatLng(position.latitude, position.longitude));
    } catch (e) {
      _showLocationError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  void _selectLocation(LatLng location, {bool notify = true}) {
    final mapsUrl = _buildMapsUrl(location);
    setState(() {
      _selectedLocation = location;
      _showMap = true;
    });
    _setText(mapsUrl);
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(location, 16));

    if (notify) {
      widget.onLocationSelected(location.latitude, location.longitude, mapsUrl);
    }
  }

  void _setText(String value) {
    _isUpdatingText = true;
    _urlController.text = value;
    _urlController.selection = TextSelection.collapsed(offset: value.length);
    _isUpdatingText = false;
  }

  Future<void> _openMaps() async {
    final url = _selectedLocation == null
        ? _urlController.text.trim()
        : _buildMapsUrl(_selectedLocation!);
    if (url.isEmpty) return;

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showLocationError(String message) {
    Get.snackbar(
      'Location Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColor.kError.withValues(alpha: 0.9),
      colorText: AppColor.kAccent,
      margin: const EdgeInsets.all(20),
      borderRadius: 16,
    );
  }

  String _buildMapsUrl(LatLng location) {
    return 'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}';
  }

  LatLng? _parseLatLng(String value) {
    if (value.isEmpty) return null;

    final patterns = [
      RegExp(r'@(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?)'),
      RegExp(r'[?&](?:q|query|ll)=(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?)'),
      RegExp(r'!3d(-?\d+(?:\.\d+)?)!4d(-?\d+(?:\.\d+)?)'),
      RegExp(r'(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?)'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(value);
      if (match == null) continue;

      final lat = double.tryParse(match.group(1) ?? '');
      final lng = double.tryParse(match.group(2) ?? '');
      if (lat == null || lng == null) continue;
      if (lat < -90 || lat > 90 || lng < -180 || lng > 180) continue;

      return LatLng(lat, lng);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final selectedLocation = _selectedLocation;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Google Maps URL',
          style: TextStyle(
            color: AppColor.kTextSecondary,
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildUrlField(selectedLocation != null)),
            const SizedBox(width: 10),
            _buildGpsButton(),
          ],
        ),
        const SizedBox(height: 6),
        TextButton(
          onPressed: () => setState(() => _showMap = !_showMap),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 32),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: AppColor.kLink,
          ),
          child: Text(
            _showMap ? 'Hide map' : 'Show map',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (_showMap) ...[
          const SizedBox(height: 8),
          _buildMap(selectedLocation),
          if (selectedLocation != null) ...[
            const SizedBox(height: 10),
            _buildSelectedDetails(selectedLocation),
          ],
        ],
      ],
    );
  }

  Widget _buildUrlField(bool hasLocation) {
    return Container(
      height: 49,
      decoration: BoxDecoration(
        color: AppColor.kInputBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColor.kInputBorder),
      ),
      child: TextField(
        controller: _urlController,
        keyboardType: TextInputType.url,
        style: TextStyle(
          color: AppColor.kTextPrimary,
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Paste Google Maps URL',
          hintStyle: TextStyle(
            color: AppColor.kTextSecondary.withValues(alpha: 0.55),
            fontFamily: 'Poppins',
            fontSize: 12,
          ),
          prefixIcon: Icon(
            Icons.link_rounded,
            color: AppColor.kTextSecondary,
            size: 19,
          ),
          suffixIcon: hasLocation
              ? IconButton(
                  onPressed: _openMaps,
                  icon: Icon(
                    Icons.open_in_new_rounded,
                    color: AppColor.kGoogleBlue,
                    size: 19,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildGpsButton() {
    return InkWell(
      onTap: _isLocating ? null : _requestCurrentLocation,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColor.kGoogleBlue,
          borderRadius: BorderRadius.circular(24),
        ),
        child: _isLocating
            ? Padding(
                padding: const EdgeInsets.all(12),
                child: CircularProgressIndicator(
                  color: AppColor.kAccent,
                  strokeWidth: 2,
                ),
              )
            : Icon(
                Icons.my_location_rounded,
                color: AppColor.kAccent,
                size: 20,
              ),
      ),
    );
  }

  Widget _buildMap(LatLng? selectedLocation) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 220,
        width: double.infinity,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: selectedLocation ?? _phnomPenh,
                zoom: selectedLocation == null ? 13 : 16,
              ),
              markers: selectedLocation == null
                  ? <Marker>{}
                  : {
                      Marker(
                        markerId: const MarkerId('shop-location'),
                        position: selectedLocation,
                      ),
                    },
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              onMapCreated: (mapController) {
                _mapController = mapController;
              },
              onTap: _selectLocation,
              gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
            ),
            if (selectedLocation == null)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.kSurface.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColor.kBorder),
                  ),
                  child: Text(
                    '\u{1F4CD} Tap on the map to set location',
                    style: TextStyle(
                      color: AppColor.kTextPrimary,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDetails(LatLng location) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}',
            style: TextStyle(
              color: AppColor.kTextSecondary,
              fontFamily: 'Poppins',
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextButton.icon(
          onPressed: _openMaps,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(0, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: AppColor.kGoogleBlue,
          ),
          icon: Icon(
            Icons.open_in_new_rounded,
            color: AppColor.kGoogleBlue,
            size: 15,
          ),
          label: const Text(
            'Open in Maps',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

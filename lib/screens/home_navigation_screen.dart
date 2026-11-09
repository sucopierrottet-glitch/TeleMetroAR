import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../calculators/telemetro_calculator.dart';
import '../l10n/app_strings.dart';
import '../models/measurement_record.dart';
import '../services/sensor_service.dart';
import '../theme/app_theme.dart';
import 'clinometer_level_screen.dart';
import 'rangefinder_screen.dart';
import 'saved_measurements_screen.dart';
import 'settings_screen.dart';

class HomeNavigationScreen extends StatefulWidget {
  final AppStrings strings;
  final ValueChanged<String> onSelectLanguage;
  final SensorService sensorService;

  const HomeNavigationScreen({
    super.key,
    required this.strings,
    required this.onSelectLanguage,
    required this.sensorService,
  });

  @override
  State<HomeNavigationScreen> createState() => _HomeNavigationScreenState();
}

class _HomeNavigationScreenState extends State<HomeNavigationScreen> {
  static const _kEyeHeightKey = 'telemetro_eye_height_m';
  static const _kRecordsKey = 'telemetro_records_v1';

  int _selectedIndex = 0;
  double _eyeHeightMeters = 1.65;
  SensorSnapshot _snapshot = const SensorSnapshot();
  List<MeasurementRecord> _records = [];
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _loadPersistedData();
    _refreshSensor();
    _pollTimer = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => _refreshSensor(),
    );
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadPersistedData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEye = prefs.getDouble(_kEyeHeightKey);
    final rawRecords = prefs.getString(_kRecordsKey);

    List<MeasurementRecord> loaded = [];
    if (rawRecords != null && rawRecords.isNotEmpty) {
      loaded = MeasurementRecord.decodeList(rawRecords);
    }
    if (loaded.isEmpty) {
      final demoCalc = TelemetroCalculator.computeAll(
        eyeHeightMeters: 1.65,
        baseAngleDeg: -18.5,
        topAngleDeg: 28.0,
      );
      loaded = [
        MeasurementRecord(
          id: 'INIT01',
          title: 'TORRE-NORTE-01',
          timestampIso: DateTime.now().toIso8601String(),
          eyeHeightMeters: demoCalc.eyeHeightMeters,
          baseAngleDeg: demoCalc.baseAngleDeg,
          topAngleDeg: demoCalc.topAngleDeg,
          horizontalDistanceMeters: demoCalc.horizontalDistanceMeters,
          targetHeightMeters: demoCalc.targetHeightMeters,
          slopePercent: demoCalc.slopePercent,
          roofPitchRisePer12: demoCalc.roofPitchRisePer12,
          azimuthDeg: 142.0,
          pressureHpa: 1013.25,
        ),
      ];
    }

    if (!mounted) return;
    setState(() {
      if (savedEye != null) {
        _eyeHeightMeters = savedEye.clamp(0.5, 3.0);
      }
      _records = loaded;
    });
  }

  Future<void> _refreshSensor() async {
    final snap = await widget.sensorService.getSensorSnapshot();
    if (!mounted) return;
    setState(() {
      _snapshot = snap;
    });
  }

  Future<void> _updateEyeHeight(double newVal) async {
    final clamped = double.parse(newVal.clamp(0.5, 3.0).toStringAsFixed(2));
    setState(() {
      _eyeHeightMeters = clamped;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kEyeHeightKey, clamped);
  }

  Future<void> _addRecord(MeasurementRecord record) async {
    setState(() {
      _records = [record, ..._records];
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kRecordsKey, MeasurementRecord.encodeList(_records));
  }

  Future<void> _deleteRecord(String id) async {
    setState(() {
      _records = _records.where((r) => r.id != id).toList();
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kRecordsKey, MeasurementRecord.encodeList(_records));
  }

  Future<void> _clearRecords() async {
    setState(() {
      _records = [];
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kRecordsKey);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.strings;

    final pages = [
      RangefinderScreen(
        strings: s,
        sensorService: widget.sensorService,
        currentSnapshot: _snapshot,
        eyeHeightMeters: _eyeHeightMeters,
        onEyeHeightChanged: _updateEyeHeight,
        onSaveMeasurement: _addRecord,
        onRefreshSensor: _refreshSensor,
      ),
      ClinometerLevelScreen(
        strings: s,
        sensorService: widget.sensorService,
        currentSnapshot: _snapshot,
        onRefreshSensor: _refreshSensor,
      ),
      SavedMeasurementsScreen(
        strings: s,
        records: _records,
        onAddRecord: _addRecord,
        onDeleteRecord: _deleteRecord,
        onClearAll: _clearRecords,
      ),
      SettingsScreen(
        strings: s,
        onSelectLanguage: widget.onSelectLanguage,
        eyeHeightMeters: _eyeHeightMeters,
        onEyeHeightChanged: _updateEyeHeight,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.gps_fixed_rounded,
              color: AppTheme.accentGreen,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.appTitle,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    s.proUnlockedBadge,
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.accentGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceSlate,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.borderColor),
                ),
                child: Text(
                  s.code.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.accentCyan,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        key: const Key('bottomNavBar'),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _selectedIndex = idx;
          });
        },
        destinations: [
          NavigationDestination(
            key: const Key('navTabRangefinder'),
            icon: const Icon(Icons.radar_outlined),
            selectedIcon: const Icon(Icons.radar_rounded),
            label: s.navRangefinder,
          ),
          NavigationDestination(
            key: const Key('navTabClinometer'),
            icon: const Icon(Icons.explore_outlined),
            selectedIcon: const Icon(Icons.explore_rounded),
            label: s.navClinometer,
          ),
          NavigationDestination(
            key: const Key('navTabLogbook'),
            icon: const Icon(Icons.picture_as_pdf_outlined),
            selectedIcon: const Icon(Icons.picture_as_pdf_rounded),
            label: s.navLogbook,
          ),
          NavigationDestination(
            key: const Key('navTabSettings'),
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings_rounded),
            label: s.navSettings,
          ),
        ],
      ),
    );
  }
}

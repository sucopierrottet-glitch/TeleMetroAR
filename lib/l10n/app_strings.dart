class AppStrings {
  final String code;

  const AppStrings(this.code);

  static const supportedCodes = ['es', 'en', 'pt'];

  String get appTitle => _t(
        es: 'TeleMetro AR Pro',
        en: 'TeleMetro AR Pro',
        pt: 'TeleMetro AR Pro',
      );

  String get appSubtitle => _t(
        es: 'Telémetro Óptico Trigonométrico & Nivel Clínico 360°',
        en: 'Trigonometric Optical Rangefinder & 360° Clinometer Level',
        pt: 'Telêmetro Óptico Trigonométrico & Nível Clínico 360°',
      );

  String get proUnlockedBadge => _t(
        es: 'EDICIÓN PRO 100% DESBLOQUEADA • 100% OFFLINE',
        en: '100% PRO UNLOCKED EDITION • 100% OFFLINE',
        pt: 'EDIÇÃO PRO 100% DESBLOQUEADA • 100% OFFLINE',
      );

  String get welcomeHeadline => _t(
        es: 'Medición Óptica de Precisión Trigonométrica',
        en: 'Precision Trigonometric Optical Measurement',
        pt: 'Medição Óptica de Precisão Trigonométrica',
      );

  String get welcomeDescription => _t(
        es: 'Calcula distancias horizontales, alturas de estructuras, pendientes y niveles 360° utilizando telemetría de sensores inerciales y trigonometría en tiempo real.',
        en: 'Calculate horizontal distances, structure heights, slopes, and 360° levels using real-time inertial sensor telemetry and trigonometry.',
        pt: 'Calcule distâncias horizontais, alturas de estruturas, inclinações e níveis 360° usando telemetria de sensores inerciais e trigonometria em tempo real.',
      );

  String get feature1Title => _t(
        es: 'Telémetro Trigonométrico HUD',
        en: 'HUD Trigonometric Rangefinder',
        pt: 'Telêmetro Trigonométrico HUD',
      );

  String get feature1Desc => _t(
        es: 'Fija el ángulo a la base y a la cima para obtener distancia D y altura total H al instante.',
        en: 'Lock base and top angles to compute horizontal distance D and total height H instantly.',
        pt: 'Fixe o ângulo da base e do topo para obter distância D e altura total H instantaneamente.',
      );

  String get feature2Title => _t(
        es: 'Nivel de Burbuja 360° y Clinómetro',
        en: '360° Bubble Level & Clinometer',
        pt: 'Nível de Bolha 360° e Clinômetro',
      );

  String get feature2Desc => _t(
        es: 'Doble eje Pitch/Roll, pendiente en %, pitch de techo (X:12), rumbo magnético y barómetro.',
        en: 'Dual-axis Pitch/Roll, slope %, roof pitch (X:12), magnetic heading, and barometer.',
        pt: 'Duplo eixo Pitch/Roll, inclinação em %, inclinação de telhado (X:12), bússola e barômetro.',
      );

  String get feature3Title => _t(
        es: 'Informes Técnicos PDF con Firma',
        en: 'Signed Technical PDF Reports',
        pt: 'Relatórios Técnicos PDF Assinados',
      );

  String get feature3Desc => _t(
        es: 'Guarda levantamientos en bitácora local y exporta certificados PDF listos para imprimir o compartir.',
        en: 'Save field surveys in local logbook and export signed PDF certificates ready to print or share.',
        pt: 'Salve levantamentos no registro local e exporte certificados PDF assinados prontos para imprimir.',
      );

  String get enterAppButton => _t(
        es: 'INICIAR INSTRUMENTO ÓPTICO',
        en: 'LAUNCH OPTICAL INSTRUMENT',
        pt: 'INICIAR INSTRUMENTO ÓPTICO',
      );

  String get navRangefinder => _t(
        es: 'Telémetro',
        en: 'Rangefinder',
        pt: 'Telêmetro',
      );

  String get navClinometer => _t(
        es: 'Nivel 360°',
        en: '360° Level',
        pt: 'Nível 360°',
      );

  String get navLogbook => _t(
        es: 'Bitácora PDF',
        en: 'PDF Logbook',
        pt: 'Registro PDF',
      );

  String get navSettings => _t(
        es: 'Ajustes',
        en: 'Settings',
        pt: 'Ajustes',
      );

  String get eyeHeightLabel => _t(
        es: 'Altura del Lente (h_eye)',
        en: 'Lens Eye Height (h_eye)',
        pt: 'Altura da Lente (h_eye)',
      );

  String get baseAngleLabel => _t(
        es: 'Ángulo Base (θ_base)',
        en: 'Base Angle (θ_base)',
        pt: 'Ângulo Base (θ_base)',
      );

  String get topAngleLabel => _t(
        es: 'Ángulo Cima (θ_top)',
        en: 'Top Angle (θ_top)',
        pt: 'Ângulo Topo (θ_top)',
      );

  String get lockBaseButton => _t(
        es: 'FIJAR BASE',
        en: 'LOCK BASE',
        pt: 'FIXAR BASE',
      );

  String get lockTopButton => _t(
        es: 'FIJAR CIMA',
        en: 'LOCK TOP',
        pt: 'FIXAR TOPO',
      );

  String get resetLocksButton => _t(
        es: 'REINICIAR',
        en: 'RESET',
        pt: 'REINICIAR',
      );

  String get saveMeasurementButton => _t(
        es: 'GUARDAR MEDICIÓN',
        en: 'SAVE MEASUREMENT',
        pt: 'SALVAR MEDIÇÃO',
      );

  String get distanceResultLabel => _t(
        es: 'Distancia Horizontal (D)',
        en: 'Horizontal Distance (D)',
        pt: 'Distância Horizontal (D)',
      );

  String get heightResultLabel => _t(
        es: 'Altura del Objetivo (H)',
        en: 'Target Height (H)',
        pt: 'Altura do Alvo (H)',
      );

  String get lineOfSightLabel => _t(
        es: 'Línea Visual (LOS)',
        en: 'Line of Sight (LOS)',
        pt: 'Linha de Visada (LOS)',
      );

  String get slopePercentLabel => _t(
        es: 'Pendiente (%)',
        en: 'Slope (%)',
        pt: 'Inclinação (%)',
      );

  String get roofPitchLabel => _t(
        es: 'Techo (X:12)',
        en: 'Roof Pitch (X:12)',
        pt: 'Telhado (X:12)',
      );

  String get livePitchLabel => _t(
        es: 'Inclinación Vertical (Pitch)',
        en: 'Vertical Tilt (Pitch)',
        pt: 'Inclinação Vertical (Pitch)',
      );

  String get simulationModeTitle => _t(
        es: 'Control Manual / Simulador de Ángulo',
        en: 'Manual Control / Angle Simulator',
        pt: 'Controle Manual / Simulador de Ângulo',
      );

  String get hardwareSensorActive => _t(
        es: 'SENSORES HARDWARE ACTIVOS',
        en: 'HARDWARE SENSORS ACTIVE',
        pt: 'SENSORES HARDWARE ATIVOS',
      );

  String get simulationModeActive => _t(
        es: 'MODO SIMULACIÓN MANUAL',
        en: 'MANUAL SIMULATION MODE',
        pt: 'MODO SIMULAÇÃO MANUAL',
      );

  String get zeroCalibrateButton => _t(
        es: 'TARAR CERO (0.0°)',
        en: 'TARE ZERO (0.0°)',
        pt: 'ZERAR (0.0°)',
      );

  String get clearTareButton => _t(
        es: 'QUITAR TARA',
        en: 'CLEAR TARE',
        pt: 'LIMPAR TARA',
      );

  String get rollAxisLabel => _t(
        es: 'Eje Lateral (Roll)',
        en: 'Lateral Axis (Roll)',
        pt: 'Eixo Lateral (Roll)',
      );

  String get azimuthLabel => _t(
        es: 'Acimut Magnético',
        en: 'Magnetic Azimuth',
        pt: 'Azimute Magnético',
      );

  String get barometerLabel => _t(
        es: 'Presión Barométrica',
        en: 'Barometric Pressure',
        pt: 'Pressão Barométrica',
      );

  String get ambientLightLabel => _t(
        es: 'Luz Ambiental',
        en: 'Ambient Light',
        pt: 'Luz Ambiente',
      );

  String get levelLockedLabel => _t(
        es: 'NIVELADO DE PRECISIÓN (< 0.5°)',
        en: 'PRECISION LEVEL LOCKED (< 0.5°)',
        pt: 'NIVELADO DE PRECISÃO (< 0.5°)',
      );

  String get levelTiltedLabel => _t(
        es: 'DESNIVEL DETECTADO',
        en: 'TILT DETECTED',
        pt: 'DESNÍVEL DETECTADO',
      );

  String get savedMeasurementsTitle => _t(
        es: 'Bitácora de Levantamientos',
        en: 'Field Survey Logbook',
        pt: 'Registro de Levantamentos',
      );

  String get exportPdfButton => _t(
        es: 'FIRMAR Y EXPORTAR PDF',
        en: 'SIGN & EXPORT PDF',
        pt: 'ASSINAR E EXPORTAR PDF',
      );

  String get addDemoMeasurementButton => _t(
        es: 'NUEVA MEDICIÓN',
        en: 'NEW MEASUREMENT',
        pt: 'NOVA MEDIÇÃO',
      );

  String get signatureDialogTitle => _t(
        es: 'Firma del Operador / Ingeniero',
        en: 'Operator / Engineer Signature',
        pt: 'Assinatura do Operador / Engenheiro',
      );

  String get operatorNameLabel => _t(
        es: 'Nombre del Responsable Técnico',
        en: 'Technical Operator Name',
        pt: 'Nome do Responsável Técnico',
      );

  String get clearSignatureButton => _t(
        es: 'LIMPIAR FIRMA',
        en: 'CLEAR SIGNATURE',
        pt: 'LIMPAR ASSINATURA',
      );

  String get generatePdfButton => _t(
        es: 'GENERAR INFORME PDF',
        en: 'GENERATE PDF REPORT',
        pt: 'GERAR RELATÓRIO PDF',
      );

  String get cancelButton => _t(
        es: 'CANCELAR',
        en: 'CANCEL',
        pt: 'CANCELAR',
      );

  String get measurementSavedSnack => _t(
        es: 'Medición guardada en la bitácora técnica.',
        en: 'Measurement saved to technical logbook.',
        pt: 'Medição salva no registro técnico.',
      );

  String get languageSectionTitle => _t(
        es: 'Idioma de la Interfaz (1-Tap)',
        en: 'Interface Language (1-Tap)',
        pt: 'Idioma da Interface (1-Toque)',
      );

  String get unitsSectionTitle => _t(
        es: 'Calibración Óptica Predeterminada',
        en: 'Default Optical Calibration',
        pt: 'Calibração Óptica Padrão',
      );

  String get aboutSectionTitle => _t(
        es: 'Información del Instrumento',
        en: 'Instrument Information',
        pt: 'Informações do Instrumento',
      );

  String get privacyPolicySummary => _t(
        es: '100% Offline-First. Los datos de sensores y mediciones permanecen exclusivamente en tu dispositivo.',
        en: '100% Offline-First. Sensor telemetry and measurements remain exclusively on your device.',
        pt: '100% Offline-First. Os dados dos sensores e medições permanecem exclusivamente no seu dispositivo.',
      );

  String get formulaReferenceTitle => _t(
        es: 'Fórmulas Trigonométricas Verificadas',
        en: 'Verified Trigonometric Formulas',
        pt: 'Fórmulas Trigonométricas Verificadas',
      );

  String get deleteAllButton => _t(
        es: 'BORRAR HISTORIAL',
        en: 'CLEAR LOGBOOK',
        pt: 'LIMPAR HISTÓRICO',
      );

  String get emptyLogbookMessage => _t(
        es: 'No hay mediciones registradas. Usa el Telémetro HUD para guardar levantamientos.',
        en: 'No measurements recorded yet. Use the Rangefinder HUD to save field surveys.',
        pt: 'Nenhuma medição registrada. Use o Telêmetro HUD para salvar levantamentos.',
      );

  String _t({
    required String es,
    required String en,
    required String pt,
  }) {
    switch (code) {
      case 'en':
        return en;
      case 'pt':
        return pt;
      case 'es':
      default:
        return es;
    }
  }
}

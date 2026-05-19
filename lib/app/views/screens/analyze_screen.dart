import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import 'analysis_results_screen.dart';
import '../widgets/custom_button.dart';

class AnalyzeScreen extends StatefulWidget {
  const AnalyzeScreen({super.key});

  @override
  State<AnalyzeScreen> createState() => _AnalyzeScreenState();
}

class _AnalyzeScreenState extends State<AnalyzeScreen> {
  final TextEditingController _inputController = TextEditingController();

  final String _covidSequence =
      'MFVFLVLLPLVSSQCVNLTTRTQLPPAYTNSFTRGVYYPDKVFRSSVLHSTQDLFLPFFSNVTWFHAIHVSGTNGTKRFDNPVLPFNDGVYFASTEKSNIIRGWIFGTTLDSKTQSLLIVNNATNVVIKVCEFQFCNDPFLGVYYHKNNKSWMESEFRVYSSANNCTFEYVSQPFLMDLEGKQGNFKNLREFVFKNIDGYFKIYSKHTPINLVRDLPQGFSALEPLVDLPIGINITRFQTLLALHRSYLTPGDSSSGWTAGAAAYYVGYLQPRTFLLKYNENGTITDAVDCALDPLSETKCTLKSFTVEKGIYQTSNFRVQPTESIVRFPNITNLCPFGEVFNATRFASVYAWNRKRISNCVADYSVLYNSASFSTFKCYGVSPTKLNDLCFTNVYADSFVIRGDEVRQIAPGQTGKIADYNYKLPDDFTGCVIAWNSNNLDSKVGGNYNYLYRLFRKSNLKPFERDISTEIYQAGSTPCNGVEGFNCYFPLQSYGFQPTNGVGYQPYRVVVLSFELLHAPATVCGPKKSTNLVKNKCVNFNFNGLTGTGVLTESNKKFLPFQQFGRDIADTTDAVRDPQTLEILDITPCSFGGVSVITPGTNTSNQVAVLYQDVNCTEVPVAIHADQLTPTWRVYSTGSNVFQTRAGCLIGAEHVNNSYECDIPIGAGICASYQTQTNSPRRARSVASQSIIAYTMSLGAENSVAYSNNSIAIPTNFTISVTTEILPVSMTKTSVDCTMYICGDSTECSNLLLQYGSFCTQLNRALTGIAVEQDKNTQEVFAQVKQIYKTPPIKDFGGFNFSQILPDPSKPSKRSFIEDLLFNKVTLADAGFIKQYGDCLGDIAARDLICAQKFNGLTVLPPLLTDEMIAQYTSALLAGTITSGWTFGAGAALQIPFAMQMAYRFNGIGVTQNVLYENQKLIANQFNSAIGKIQDSLSSTASALGKLQDVVNQNAQALNTLVKQLSSNFGAISSVLNDILSRLDKVEAEVQIDRLITGRLQSLQTYVTQQLIRAAEIRASANLAATKMSECVLGQSKRVDFCGKGYHLMSFPQSAPHGVVFLHVTYVPAQEKNFTTAPAICHDGKAHFPREGVFVSNGTHWFVTQRNFYEPQIITTDNTFVSGNCDVVIGIVNNTVYDPLQPELDSFKEELDKYFKNHTSPDVDLGDISGINASVVNIQKEIDRLNEVAKNLNESLIDLQELGKYEQYIKWPWYIWLGFIAGLIAIVMVTIMLCCMTSCCSCLKGCCSCGSCCKFDEDDSEPVLKGVKLHYT';
  final String _h5n1Sequence =
      'MEKIVLLFAIVSLVKSDQICIGYHANNSTEQVDTIMEKNVTVTHAQDILEKKHNGKLCDLDGVKPLILRDCSVAGWLLGNPMCDEFINVPEWSYIVEKANPVNDLCYPGDFNDYEELKHLLSRINHFEKIQIIPKSSWSSHEASLGVSSACPYQGKSSFFRNVVWLIKKNSTYPTIKRSYNNTNQEDLLVLWGIHHPNDAAEQTKLYQNPTTYISVGTSTLNQRLVPRIATRSKVNGQSGRMEFFWTILKPNDAINFESNGNFIAPEYAYKIVKKGDSTIMKSELEYGNCNTKCQTPMGAINSSMPFHNIHPLTIGECPKYVKSNRLVLATGLRNSPQRERRRKKRGLFGAIAGFIEGGWQGMVDGWYGYHHSNEQGSGYAADKESTQKAIDGVTNKVNSIIDKMNTQFEAVGREFNNLERRIENLNKKMEDGFLDVWTYNAELLVLMENERTLDFHDSNVKNLYDKVRLQLRDNAKELGNGCFEFYHKCDNECMESVRNGTYDYPQYSEEARLKREEISGVKLESIGTYQILSIYSTVASSLALAIMVAGLSLWMCSNGSLQCRICI';

  @override
  void initState() {
    super.initState();
    _inputController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _loadPreset(String seq) {
    _inputController.text = seq;
  }

  void _analyze() {
    if (_inputController.text.isEmpty) return;
    Get.to(() => AnalysisResultsScreen(sequence: _inputController.text));
  }

  int _getAminoAcidCount() {
    final text = _inputController.text;
    if (text.isEmpty) return 0;
    final lines = text.split('\n');
    final sequenceLines = lines.where((line) => !line.trim().startsWith('>'));
    final sequence = sequenceLines.join().replaceAll(RegExp(r'\s+'), '');
    return sequence.length;
  }

  String _getFormattedAminoAcidCount() {
    final count = _getAminoAcidCount();
    return NumberFormat('#,###').format(count);
  }

  Widget _buildValidityBadge(double w) {
    final count = _getAminoAcidCount();
    if (_inputController.text.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.025,
          vertical: w * 0.008,
        ),
        decoration: BoxDecoration(
          color: AppTheme.primaryText.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.background.withValues(alpha: 0.1)),
        ),
        child: Text(
          'Paste sequence',
          style: GoogleFonts.outfit(
            color: AppTheme.infoBlue,
            fontWeight: FontWeight.w600,
            fontSize: w * 0.028,
          ),
        ),
      );
    }

    if (count >= 200) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.025,
          vertical: w * 0.008,
        ),
        decoration: BoxDecoration(
          color: AppTheme.safeGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.safeGreen.withValues(alpha: 0.4)),
        ),
        child: Text(
          'Valid ✓',
          style: GoogleFonts.outfit(
            color: AppTheme.safeGreen,
            fontWeight: FontWeight.bold,
            fontSize: w * 0.028,
          ),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.025,
          vertical: w * 0.008,
        ),
        decoration: BoxDecoration(
          color: AppTheme.warningAmber.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.warningAmber.withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          'Min 200 AA',
          style: GoogleFonts.outfit(
            color: AppTheme.warningAmber,
            fontWeight: FontWeight.bold,
            fontSize: w * 0.028,
          ),
        ),
      );
    }
  }

  Widget _buildPresetChip(String label, String sequence, double w) {
    return InkWell(
      onTap: () => _loadPreset(sequence),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.01),
        decoration: BoxDecoration(
          color: AppTheme.cardSurface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600,
            fontSize: w * 0.03,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: InkWell(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: w * 0.04,
            right: w * 0.04,
            top: w * 0.02,
            bottom: w * 0.1,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sequence Analyzer',
                style: GoogleFonts.outfit(
                  color: AppTheme.primaryText,
                  fontSize: w * 0.05,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              Text(
                'Paste a viral protein sequence · minimum 200 amino acids',
                style: GoogleFonts.outfit(
                  color: AppTheme.secondaryText,
                  fontSize: w * 0.03,
                ),
              ),
              SizedBox(height: w * 0.02),

              // Card Input
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04,
                  vertical: w * 0.02,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.cardSurface,
                  borderRadius: BorderRadius.circular(w * 0.03),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _inputController,
                      maxLines: 6,
                      style: GoogleFonts.outfit(
                        color: AppTheme.primaryText,
                        fontSize: w * 0.035,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            'Paste FASTA sequence here...\nExample:\n>Unknown_Virus_Spike\nMFVFLVLLPLVSSQCVNLTTRTQLPPAYTNSFTRGVYYPDKV...',
                        hintStyle: GoogleFonts.outfit(
                          color: AppTheme.mutedText,
                          fontSize: w * 0.035,
                        ),
                        border: .none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    SizedBox(height: w * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_getFormattedAminoAcidCount()} amino acids',
                          style: GoogleFonts.outfit(
                            color: AppTheme.mutedText,
                            fontSize: w * 0.032,
                          ),
                        ),
                        _buildValidityBadge(w),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: w * 0.04),

              // Presets Wrap
              Wrap(
                spacing: w * 0.02,
                runSpacing: w * 0.02,
                children: [
                  _buildPresetChip('COVID-19 spike', _covidSequence, w),
                  _buildPresetChip('H5N1', _h5n1Sequence, w),
                  _buildPresetChip(
                    'Safe CoV',
                    'MDSKGSSQKGSRLLLLLVVSNLLLCQGVVGT...',
                    w,
                  ),
                  _buildPresetChip('Novel', 'MKLLLLLLVVLL...', w),
                ],
              ),
              SizedBox(height: w * 0.06),

              // Analyze Button
              CustomButton(
                text: 'Analyze sequence',
                onPressed: _getAminoAcidCount() > 0 ? _analyze : null,
                color: AppTheme.infoBlue,
                textColor: _getAminoAcidCount() > 0
                    ? Colors.white
                    : AppTheme.mutedText,
                icon: Icons.biotech,
                width: double.infinity,
                height: w * 0.125,
                borderRadius: w * 0.06,
                fontSize: w * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

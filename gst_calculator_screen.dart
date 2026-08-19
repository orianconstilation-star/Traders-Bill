import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';

class GstCalculatorScreen extends StatefulWidget {
  @override
  _GstCalculatorScreenState createState() => _GstCalculatorScreenState();
}

class _GstCalculatorScreenState extends State<GstCalculatorScreen> {
  final _amountController = TextEditingController();
  final _gstRateController = TextEditingController(text: "18");
  double _amount = 0;
  double _gstRate = 18;

  void _calculate() {
    setState(() {
      _amount = double.tryParse(_amountController.text) ?? 0;
      _gstRate = double.tryParse(_gstRateController.text) ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    double totalGst = (_amount * _gstRate) / 100;
    double cgst = totalGst / 2;
    double sgst = totalGst / 2;
    double totalAmount = _amount + totalGst;

    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('gst_calculator'))),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: loc.translate('total') + " Amount"),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            TextField(
              controller: _gstRateController,
              decoration: InputDecoration(labelText: loc.translate('gst_rate')),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculate(),
            ),
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _ResultRow(label: loc.translate('cgst'), value: cgst),
                    _ResultRow(label: loc.translate('sgst'), value: sgst),
                    _ResultRow(label: "Total GST", value: totalGst),
                    Divider(),
                    _ResultRow(label: loc.translate('grand_total'), value: totalAmount, isBold: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isBold;

  _ResultRow({required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 18, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value.toStringAsFixed(2), style: TextStyle(fontSize: 18, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

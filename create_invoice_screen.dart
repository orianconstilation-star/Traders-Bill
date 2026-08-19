import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../localization/app_localizations.dart';
import '../database/database_helper.dart';
import '../models/customer_model.dart';
import '../models/product_model.dart';
import '../models/invoice_model.dart';
import '../models/invoice_item_model.dart';

class CreateInvoiceScreen extends StatefulWidget {
  @override
  _CreateInvoiceScreenState createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  Customer? _selectedCustomer;
  List<Customer> _customers = [];
  List<Product> _products = [];
  List<InvoiceItem> _items = [];
  double _gstRate = 18.0;

  final _qtyController = TextEditingController();
  Product? _selectedProduct;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final c = await DatabaseHelper.instance.getAllCustomers();
    final p = await DatabaseHelper.instance.getAllProducts();
    setState(() {
      _customers = c;
      _products = p;
    });
  }

  void _addItem() {
    if (_selectedProduct != null && _qtyController.text.isNotEmpty) {
      final qty = int.parse(_qtyController.text);
      final total = _selectedProduct!.price * qty;
      setState(() {
        _items.add(InvoiceItem(
          productName: _selectedProduct!.name,
          price: _selectedProduct!.price,
          quantity: qty,
          total: total,
        ));
      });
      _qtyController.clear();
    }
  }

  double get _totalAmount => _items.fold(0, (sum, item) => sum + item.total);
  double get _cgst => (_totalAmount * (_gstRate / 100)) / 2;
  double get _sgst => _cgst;
  double get _grandTotal => _totalAmount + _cgst + _sgst;

  void _saveInvoice() async {
    if (_selectedCustomer == null || _items.isEmpty) return;

    final invoice = Invoice(
      customerName: _selectedCustomer!.name,
      date: DateFormat('dd/MM/yy').format(DateTime.now()),
      totalAmount: _totalAmount,
      gstRate: _gstRate,
      cgst: _cgst,
      sgst: _sgst,
      grandTotal: _grandTotal,
    );

    await DatabaseHelper.instance.insertInvoice(invoice, _items);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('create_invoice'))),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<Customer>(
              value: _selectedCustomer,
              hint: Text(loc.translate('select_customer')),
              items: _customers.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
              onChanged: (val) => setState(() => _selectedCustomer = val),
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<Product>(
                    value: _selectedProduct,
                    hint: Text(loc.translate('select_product')),
                    items: _products.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
                    onChanged: (val) => setState(() => _selectedProduct = val),
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _qtyController,
                    decoration: InputDecoration(labelText: loc.translate('quantity')),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(icon: Icon(Icons.add_circle), onPressed: _addItem),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  title: Text(item.productName),
                  subtitle: Text("${item.quantity} x ${item.price}"),
                  trailing: Text(item.total.toStringAsFixed(2)),
                );
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: loc.translate('gst_rate')),
              keyboardType: TextInputType.number,
              onChanged: (val) => setState(() => _gstRate = double.tryParse(val) ?? 0),
            ),
            Divider(),
            SummaryRow(label: loc.translate('total'), value: _totalAmount),
            SummaryRow(label: loc.translate('cgst'), value: _cgst),
            SummaryRow(label: loc.translate('sgst'), value: _sgst),
            SummaryRow(label: loc.translate('grand_total'), value: _grandTotal, isBold: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveInvoice, child: Text(loc.translate('save'))),
          ],
        ),
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isBold;

  SummaryRow({required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value.toStringAsFixed(2), style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

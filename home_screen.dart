import 'package:flutter/material.dart';
import '../localization/app_localizations.dart';
import '../database/database_helper.dart';
import '../models/invoice_model.dart';
import 'add_customer_screen.dart';
import 'add_product_screen.dart';
import 'create_invoice_screen.dart';
import 'gst_calculator_screen.dart';
import 'settings_screen.dart';
import '../services/pdf_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Invoice> _invoices = [];

  @override
  void initState() {
    super.initState();
    _refreshInvoices();
  }

  void _refreshInvoices() async {
    final data = await DatabaseHelper.instance.getAllInvoices();
    setState(() {
      _invoices = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('app_title')),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen())).then((_) => setState(() {})),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(loc.translate('app_title'), style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text(loc.translate('add_customer')),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddCustomerScreen())),
            ),
            ListTile(
              leading: Icon(Icons.add_shopping_cart),
              title: Text(loc.translate('add_product')),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddProductScreen())),
            ),
            ListTile(
              leading: Icon(Icons.calculate),
              title: Text(loc.translate('gst_calculator')),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GstCalculatorScreen())),
            ),
          ],
        ),
      ),
      body: _invoices.isEmpty
          ? Center(child: Text("No Invoices Yet"))
          : ListView.builder(
              itemCount: _invoices.length,
              itemBuilder: (context, index) {
                final inv = _invoices[index];
                return ListTile(
                  title: Text(inv.customerName),
                  subtitle: Text("${inv.date} - Total: ₹${inv.grandTotal.toStringAsFixed(2)}"),
                  trailing: IconButton(
                    icon: Icon(Icons.picture_as_pdf),
                    onPressed: () async {
                      final items = await DatabaseHelper.instance.getInvoiceItems(inv.id!);
                      PdfService.generateInvoicePdf(inv, items);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CreateInvoiceScreen())).then((_) => _refreshInvoices()),
        child: Icon(Icons.add),
        tooltip: loc.translate('create_invoice'),
      ),
    );
  }
}

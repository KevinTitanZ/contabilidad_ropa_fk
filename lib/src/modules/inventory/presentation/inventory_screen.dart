import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final Color primary = const Color(0xFF0F7AA8); // azul similar
  final TextEditingController _searchCtrl = TextEditingController();

  // Mock de Inventario para diseño
  final List<ProductItem> _allProducts = [
    ProductItem(
      code: 'COD-EXPL',
      name: 'EXHIBIDOR PLASTLIT',
      price: 0.0097,
      stock: 0,
      pack: 1,
    ),
    ProductItem(
      code: 'COD-EXB',
      name: 'EXHIBIDOR BOPP',
      price: 0.0011,
      stock: 0,
      pack: 1,
    ),
    ProductItem(
      code: 'COD-CCPP',
      name: 'CINTA CORTADA PARA PLATANO X 59 CM',
      price: 0.3864,
      stock: 352.0,
      pack: 150,
    ),
    ProductItem(
      code: 'COD-EC805',
      name: 'ESPUMA DE CARNAVAL 805GR',
      price: 1.8358,
      stock: 0,
      pack: 24,
    ),
    // agrega más para ver el scroll
  ];

  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _allProducts
        .where(
          (p) =>
              p.name.toLowerCase().contains(_query.toLowerCase()) ||
              p.code.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text('Inventario'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Buscador
          Container(
            color: primary,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _query = v),
                decoration: const InputDecoration(
                  hintText: 'Búsqueda Inteligente',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          // Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.78, // ajusta para parecerse a la captura
                ),
                itemCount: filtered.length,
                itemBuilder: (_, i) => ProductCard(
                  product: filtered[i],
                  primary: primary,
                  onPreview: () {
                    // por ahora solo muestra un snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ver: ${filtered[i].name}')),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductItem {
  final String code;
  final String name;
  final double price;
  final double stock; // puede ser decimal
  final int pack;

  ProductItem({
    required this.code,
    required this.name,
    required this.price,
    required this.stock,
    required this.pack,
  });
}

class ProductCard extends StatelessWidget {
  final ProductItem product;
  final Color primary;
  final VoidCallback onPreview;

  const ProductCard({
    Key? key,
    required this.product,
    required this.primary,
    required this.onPreview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.white,
      elevation: 1.5,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen placeholder + botón ojo
            Stack(
              children: [
                Container(
                  height: 92,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F2F6),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.black38,
                      size: 36,
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: InkWell(
                    onTap: onPreview,
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.black12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.remove_red_eye_rounded,
                        color: primary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Código y precio en chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  _chip(
                    text: product.code,
                    bg: const Color(0xE6EAF3FB),
                    fg: primary,
                  ),
                  const Spacer(),
                  _chip(
                    text: '\$ ${product.price.toStringAsFixed(4)}',
                    bg: const Color(0xFFE9F7F1),
                    fg: const Color(0xFF1A936F),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Nombre
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  height: 1.15,
                ),
              ),
            ),
            const SizedBox(height: 6),

            // Stock
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _kvRow(
                dotColor: product.stock > 0
                    ? const Color(0xFF2E8BC0)
                    : const Color(0xFFD64545),
                label: 'Stock:',
                value: product.stock.toStringAsFixed(
                  product.stock % 1 == 0 ? 0 : 4,
                ),
                valueColor: product.stock > 0
                    ? primary
                    : const Color(0xFFD64545),
                boldValue: true,
              ),
            ),
            const SizedBox(height: 4),

            // Empaque
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _kvRow(
                dotColor: const Color(0xFF8BBBD9),
                label: 'Empaque:',
                value: product.pack.toString(),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _chip({required String text, required Color bg, required Color fg}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }

  Widget _kvRow({
    required Color dotColor,
    required String label,
    required String value,
    Color valueColor = Colors.black87,
    bool boldValue = false,
  }) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.black87)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: valueColor,
              fontWeight: boldValue ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class ProductOrderItem extends StatelessWidget {
  // ... existing fields ...

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // ... other properties ...
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              if (quantity > 1) {
                quantity--;
                onQuantityChanged();
              }
            },
          ),
          Text(quantity.toString()),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              quantity++;
              onQuantityChanged();
            },
          ),
        ],
      ),
    );
  }
}

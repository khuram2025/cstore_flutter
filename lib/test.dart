MediaQuery.of(context).size.width < someThresholdWidth
? SingleChildScrollView(
scrollDirection: Axis.horizontal,
child: DataTable(
// ... other properties ...
columnSpacing: 5.0,
// ... other properties ...
),
)
    : Container(
child: DataTable(
// ... other properties ...
columnSpacing: 5.0,
// ... other properties ...
),
);
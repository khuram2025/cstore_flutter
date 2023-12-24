// ... Other parts of the code ...

if (imagePath != null)
ImagePreviewWidget(key: UniqueKey(), imagePath: imagePath),

// ImagePreviewWidget definition
class ImagePreviewWidget extends StatelessWidget {
final String? imagePath;

const ImagePreviewWidget({Key? key, required this.imagePath}) : super(key: key);

@override
Widget build(BuildContext context) {
print("ImagePreviewWidget build: $imagePath"); // Debug print

final file = File(imagePath!);
print("File exists: ${file.existsSync()}"); // Check if file exists

if (!file.existsSync()) {
return Text("Error loading image");
}

return Container(
margin: EdgeInsets.symmetric(vertical: 10),
width: double.infinity,
height: 200,
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(8),
image: DecorationImage(
image: FileImage(file),
fit: BoxFit.cover,
),
),
);
}
}

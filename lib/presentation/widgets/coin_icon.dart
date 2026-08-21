import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoinIcon extends StatelessWidget {
  final String url;
  final double size;

  const CoinIcon({super.key, required this.url, required this.size});

  bool get _isSvg {
    final normalized = url.toLowerCase();
    if (normalized.startsWith('data:image/svg+xml')) {
      return true;
    }
    final path = Uri.tryParse(url)?.path.toLowerCase() ?? normalized;
    return path.endsWith('.svg');
  }

  bool get _isPng {
    final normalized = url.toLowerCase();
    if (normalized.startsWith('data:image/png')) {
      return true;
    }
    final path = Uri.tryParse(url)?.path.toLowerCase() ?? normalized;
    return path.endsWith('.png');
  }

  Widget _svgWidget() {
    if (url.startsWith('data:image/svg+xml')) {
      final uri = Uri.tryParse(url);
      final svgData = uri?.data;
      if (svgData != null) {
        final svgMarkup = svgData.contentText;
        return SizedBox(
          width: size,
          height: size,
          child: SvgPicture.string(
            svgMarkup,
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        );
      }
    }

    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.contain,
        placeholderBuilder: (context) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _pngWidget() {
    final normalized = url.toLowerCase();
    if (normalized.startsWith('data:image/png')) {
      final uri = Uri.tryParse(url);
      final imageData = uri?.data;
      if (imageData != null) {
        return SizedBox(
          width: size,
          height: size,
          child: Image.memory(
            imageData.contentAsBytes(),
            width: size,
            height: size,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.image_not_supported_outlined,
                size: size * 0.75,
                color: Colors.grey,
              );
            },
          ),
        );
      }
    }

    return SizedBox(
      width: size,
      height: size,
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.image_not_supported_outlined,
            size: size * 0.75,
            color: Colors.grey,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (url.trim().isEmpty) {
      return SizedBox(
        width: size,
        height: size,
        child: Icon(
          Icons.monetization_on_outlined,
          size: size * 0.75,
          color: Colors.grey,
        ),
      );
    }

    if (_isSvg) {
      return _svgWidget();
    }

    if (_isPng) {
      return _pngWidget();
    }

    return SizedBox(
      width: size,
      height: size,
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.image_not_supported_outlined,
            size: size * 0.75,
            color: Colors.grey,
          );
        },
      ),
    );
  }
}

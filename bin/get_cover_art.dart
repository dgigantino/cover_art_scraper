import 'package:args/args.dart';
import 'package:get_cover_art/apple_downloader.dart';
import 'package:get_cover_art/deromanizer.dart';
import 'package:get_cover_art/normalizer.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('artist', abbr: 'a', help: 'The artist name')
    ..addOption('album', abbr: 'l', help: 'The album name')
    ..addOption('title', abbr: 't', help: 'The song title (if not searching by album)')
    ..addOption('output', abbr: 'o', help: 'Output file path (if saving the image)')
    ..addOption('size', abbr: 's', defaultsTo: '500', help: 'Image size (e.g., 500 for 500x500)')
    ..addOption('quality', abbr: 'q', defaultsTo: '0', help: 'Image quality (0 for default, or 1-100 for JPEG quality)')
    ..addFlag('url', abbr: 'u', negatable: false, help: 'Only print the URL of the found image')
    ..addFlag('verbose', abbr: 'v', negatable: false, help: 'Enable verbose output')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show usage information');

  final results = parser.parse(arguments);

  if (results['help']) {
    print('Usage: get_cover_art [options]\n');
    print(parser.usage);
    return;
  }

  final artist = results['artist'];
  final album = results['album'];
  final title = results['title'];
  final output = results['output'];
  final size = int.parse(results['size']);
  final quality = int.parse(results['quality']);
  final printUrlOnly = results['url'];
  final verbose = results['verbose'];

  if ((artist == null) || (album == null && title == null)) {
    print('Error: You must provide --artist and either --album or --title');
    print(parser.usage);
    return;
  }

  final downloader = AppleDownloader(
    verbose: verbose,
    throttle: 3.0,
    artSize: size,
    artQuality: quality,
    artistNormalizer: ArtistNormalizer(),
    albumNormalizer: AlbumNormalizer(),
    deromanizer: DeRomanizer(),
  );

  try {
    final imageUrl = await downloader.search(artist, album, title);

    if (imageUrl != null) {
      if (printUrlOnly) {
        print(imageUrl);
      } else {
        String destPath = output ??
            '${artist.replaceAll(' ', '_')}-${(album ?? title).replaceAll(' ', '_')}.jpg';

        await downloader.download(imageUrl, destPath);
        print('Downloaded cover art to: $destPath');
      }
    } else {
      print('No cover art found.');
    }
  } catch (e) {
    print('An error occurred: $e');
  }
}

A command-line application to scrape music art covers from iTunes with an entry point in `bin/`, library code in `lib/`.

## To compile:

```bash
dart compile exe bin/get_cover_art.dart
```

## Usage:

```bash
get_cover_art [options]
```

- `-a`, `--artist`  
  The artist name
- `-l`, `--album`  
  The album name
- `-t`, `--title`  
  The song title (if not searching by album)
- `-o`, `--output`  
  Output file path (if saving the image)
- `-s`, `--size`  
  Image size (e.g., 500 for 500x500)  
  (defaults to "500")
- `-q`, `--quality`  
  Image quality (0 for default, or 1-100 for JPEG quality)  
  (defaults to "0")
- `-u`, `--url`  
  Only print the URL of the found image
- `-v`, `--verbose`  
  Enable verbose output
- `-h`, `--help`  
  Show usage information
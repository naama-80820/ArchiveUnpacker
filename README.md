# Basic Bash Proficiency - Archive Unpacker

Welcome to the **Develeap Bash Proficiency Exam Project**!

This project is a Bash script (`unpack.sh`) designed to demonstrate basic to intermediate skills in Linux command-line usage and Bash scripting.  
The script automatically unpacks compressed archives based on their actual compression type (detected via the `file` command), without relying on file extensions.

## Features

- ✅ Supports unpacking of `.gz`, `.bz2`, `.zip`, `.Z` compressed files.
- ✅ Recursive unpacking with the `-r` flag.
- ✅ Verbose mode with the `-v` flag for detailed output.
- ✅ Automatically overwrites existing files.
- ✅ Counts successfully unpacked archives and reports failures.
- ✅ Ignores uncompressed files without error.

## Usage

```bash
./unpack.sh [-r] [-v] file1 [file2 ...]

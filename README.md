# ConnectionProvider

## Overview
The `ConnectionProvider` class is a Dart utility designed to interact with various media store APIs, facilitating authentication, file management, and metadata retrieval functionalities.

## Features
- **Authentication**: Authenticate with the media store API using OAuth 2.0.
- **File Listing**: List files or items in the media store with support for pagination.
- **File Upload**: Upload files to the media store, supporting large file uploads.
- **File Download**: Download files from the media store to local storage.
- **File Metadata Retrieval**: Retrieve metadata or details of a file/item from the media store.

## Usage
1. Initialize a `ConnectionProvider` instance with the client ID, client secret, and base URL of the media store API.
2. Authenticate using the `authenticate()` method.
3. Utilize methods such as `index()` for listing files, `upload()` for uploading files, `download()` for downloading files, and `read()` for retrieving file metadata.

## Requirements
- Dart SDK
- Internet connection for API communication

## Installation
1. Add the `http` package to your Dart project dependencies.
   ```yaml
   dependencies:
     http: ^0.13.3

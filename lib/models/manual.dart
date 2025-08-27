enum ManualType {
  image,
  pdf,
  camera,
}

class Manual {
  final String id;
  final String name;
  final String filePath;
  final ManualType type;
  final DateTime uploadedAt;
  final int? fileSize; // in bytes
  final String? thumbnailPath;

  Manual({
    required this.id,
    required this.name,
    required this.filePath,
    required this.type,
    required this.uploadedAt,
    this.fileSize,
    this.thumbnailPath,
  });

  // Convert Manual to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'filePath': filePath,
      'type': type.name,
      'uploadedAt': uploadedAt.toIso8601String(),
      'fileSize': fileSize,
      'thumbnailPath': thumbnailPath,
    };
  }

  // Create Manual from JSON
  factory Manual.fromJson(Map<String, dynamic> json) {
    return Manual(
      id: json['id'],
      name: json['name'],
      filePath: json['filePath'],
      type: ManualType.values.firstWhere((e) => e.name == json['type']),
      uploadedAt: DateTime.parse(json['uploadedAt']),
      fileSize: json['fileSize'],
      thumbnailPath: json['thumbnailPath'],
    );
  }

  // Create a copy with updated fields
  Manual copyWith({
    String? id,
    String? name,
    String? filePath,
    ManualType? type,
    DateTime? uploadedAt,
    int? fileSize,
    String? thumbnailPath,
  }) {
    return Manual(
      id: id ?? this.id,
      name: name ?? this.name,
      filePath: filePath ?? this.filePath,
      type: type ?? this.type,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      fileSize: fileSize ?? this.fileSize,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
    );
  }

  // Get file size in human readable format
  String get formattedFileSize {
    if (fileSize == null) return 'Unknown size';
    
    if (fileSize! < 1024) {
      return '${fileSize!} B';
    } else if (fileSize! < 1024 * 1024) {
      return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  // Get appropriate icon for manual type
  String get typeIcon {
    switch (type) {
      case ManualType.image:
        return '📷';
      case ManualType.pdf:
        return '📄';
      case ManualType.camera:
        return '📸';
    }
  }
}
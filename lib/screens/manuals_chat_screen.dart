import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/chat_message.dart';
import '../models/manual.dart';
import '../services/local_storage_service.dart';

class ManualsChatScreen extends StatefulWidget {
  const ManualsChatScreen({super.key});

  @override
  State<ManualsChatScreen> createState() => _ManualsChatScreenState();
}

class _ManualsChatScreenState extends State<ManualsChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _imagePicker = ImagePicker();
  
  List<ChatMessage> _messages = [];
  List<Manual> _uploadedManuals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChatData();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadChatData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load chat history and uploaded manuals
      final chatHistory = await LocalStorageService.getChatHistory();
      final uploadedManuals = await LocalStorageService.getUploadedManuals();

      setState(() {
        _messages = chatHistory;
        _uploadedManuals = uploadedManuals;
        _isLoading = false;
      });

      // Add welcome message if no messages exist
      if (_messages.isEmpty) {
        await _addWelcomeMessage();
      }

      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      await _addWelcomeMessage();
    }
  }

  Future<void> _addWelcomeMessage() async {
    final welcomeMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: "Hi! Upload your product manual or ask me any repair question.",
      type: MessageType.bot,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(welcomeMessage);
    });

    await LocalStorageService.addChatMessage(welcomeMessage);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    // Clear input
    _messageController.clear();

    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: messageText,
      type: MessageType.user,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
    });

    await LocalStorageService.addChatMessage(userMessage);

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Add placeholder bot response
    await Future.delayed(const Duration(milliseconds: 500));
    await _addBotResponse(messageText);
  }

  Future<void> _addBotResponse(String userMessage) async {
    // Placeholder bot response logic
    String botResponse = "I understand you're asking about: \"$userMessage\". This is a placeholder response. In the future, I'll be able to help you with repair questions and analyze your uploaded manuals.";

    final botMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: botResponse,
      type: MessageType.bot,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(botMessage);
    });

    await LocalStorageService.addChatMessage(botMessage);

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileName = result.files.single.name;
        final fileSize = result.files.single.size;

        // Determine manual type
        ManualType type = ManualType.pdf;
        if (fileName.toLowerCase().endsWith('.jpg') || 
            fileName.toLowerCase().endsWith('.jpeg') || 
            fileName.toLowerCase().endsWith('.png')) {
          type = ManualType.image;
        }

        await _addManual(fileName, file.path, type, fileSize);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick file: ${e.toString()}');
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        final file = File(image.path);
        final fileSize = await file.length();
        final fileName = 'Camera_${DateTime.now().millisecondsSinceEpoch}.jpg';

        await _addManual(fileName, image.path, ManualType.camera, fileSize);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to take photo: ${e.toString()}');
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        final file = File(image.path);
        final fileSize = await file.length();
        final fileName = 'Gallery_${DateTime.now().millisecondsSinceEpoch}.jpg';

        await _addManual(fileName, image.path, ManualType.image, fileSize);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: ${e.toString()}');
    }
  }

  Future<void> _addManual(String name, String filePath, ManualType type, int fileSize) async {
    final manual = Manual(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      filePath: filePath,
      type: type,
      uploadedAt: DateTime.now(),
      fileSize: fileSize,
    );

    setState(() {
      _uploadedManuals.add(manual);
    });

    await LocalStorageService.addUploadedManual(manual);

    // Add manual message to chat
    final manualMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: "Manual uploaded: $name",
      type: MessageType.manual,
      timestamp: DateTime.now(),
      attachmentUrl: filePath,
    );

    setState(() {
      _messages.add(manualMessage);
    });

    await LocalStorageService.addChatMessage(manualMessage);

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Manual "$name" uploaded successfully'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text('Choose PDF'),
                onTap: () {
                  Navigator.pop(context);
                  _pickFile();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manuals & Chat'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            onPressed: _showUploadOptions,
            icon: const Icon(Icons.attach_file),
            tooltip: 'Upload Manual',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Uploaded manuals section
                if (_uploadedManuals.isNotEmpty) _buildManualsSection(),
                // Chat messages
                Expanded(child: _buildChatArea()),
                // Message input
                _buildMessageInput(),
              ],
            ),
    );
  }

  Widget _buildManualsSection() {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Uploaded Manuals',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _uploadedManuals.length,
              itemBuilder: (context, index) {
                return _buildManualCard(_uploadedManuals[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualCard(Manual manual) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 8.0),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    manual.typeIcon,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      manual.name,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                manual.formattedFileSize,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildActionButton('Translate', Icons.translate, () {
                    _showPlaceholderDialog('Translate to Text', 'This feature will use OCR to extract and translate text from your manual.');
                  }),
                  const SizedBox(width: 4),
                  _buildActionButton('Audio', Icons.volume_up, () {
                    _showPlaceholderDialog('Play as Audio', 'This feature will convert the manual text to speech.');
                  }),
                  const SizedBox(width: 4),
                  _buildActionButton('Ask', Icons.chat, () {
                    _showPlaceholderDialog('Ask about Manual', 'This feature will let you ask questions about this specific manual.');
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 12,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 8,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatArea() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16.0),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        return _buildMessageBubble(_messages[index]);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.type == MessageType.user;
    final isManual = message.type == MessageType.manual;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(12.0),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primary
              : isManual
                  ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2)
                  : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: !isUser
              ? Border.all(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isManual)
              Row(
                children: [
                  Icon(
                    Icons.attach_file,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Manual Uploaded',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            if (isManual) const SizedBox(height: 4),
            Text(
              message.content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isUser
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(message.timestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isUser
                    ? Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7)
                    : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _showUploadOptions,
            icon: Icon(
              Icons.attach_file,
              color: Theme.of(context).colorScheme.primary,
            ),
            tooltip: 'Upload Manual',
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ask me any repair question...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _sendMessage,
            icon: Icon(
              Icons.send,
              color: Theme.of(context).colorScheme.primary,
            ),
            tooltip: 'Send Message',
          ),
        ],
      ),
    );
  }

  void _showPlaceholderDialog(String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
import 'package:flutter/material.dart';
import '../models/guide.dart';
import '../models/steps.dart';

class GuideStepsScreen extends StatelessWidget {
  final Guide guide;
  final List<StepModel> steps;

  const GuideStepsScreen({
    Key? key,
    required this.guide,
    required this.steps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(

      appBar: AppBar( title: Text (guide.title) ),
      body: steps.isNotEmpty
        ? ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: steps.length,
          itemBuilder: (conext,index){
            final step = steps [index];
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: step.imageUrl != null
                  ? Image.network(step.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
                  : const Icon (Icons.list_alt),
                title: Text(step.title),
                subtitle: Text("Step ${index + 1}"),
              ),
            );
          },
        )
        
        :const Center(child: Text("No steps found for this guide")),
    );
  }
}

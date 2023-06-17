import 'dart:developer';

import 'package:chatgpt/models/prompts/prompt_types_interfaces.dart';

class PromptItem implements BasePromptType {
  @override
  List<PromptQuery> queries;

  @override
  String generate() {
    // String tempPrompt = prompt;
    String tempPrompt =
        '''Write a product description for [product details] that targets [target audience]. The description should highlight the product's key features, such as [features], and explain the benefits of using the product, such as [benefits].''';
    for (var element in queries) {
      tempPrompt = element.generateQuery(tempPrompt);
    }
    return tempPrompt;
    // return BasePromptType.getQueryString(queries);
  }

  @override
  String name;
  PromptItem({required this.queries, required this.name, required this.prompt});

  void fromMap(MapEntry<String, List<String>> mapEntry) {
    name = mapEntry.key;
    queries = mapEntry.value.map((e) => TextPromptType(e)).toList();
  }

  factory PromptItem.fromMap(Map<String, dynamic> map) {
    log(map.toString());
    return PromptItem(
      queries:
          List<PromptQuery>.from(map['fields'].map((x) => TextPromptType(x))),
      name: map['name'],
      prompt: map['prompt'],
    );
  }

  @override
  String prompt;
}

// final promptsMap = {
//   {
//     'name': 'News article ',
//     'fields': [
//       'Topic',
//       'Covers',
//       'length',
//       'level of detail',
//       'sources to cite'
//     ],
//     'prompt': '''
// I'm looking for a comprehensive article on [topic] 
// that covers [covers]. 
// The article should be [length] in length and 
// provide a [level of detail] overview of the topic.
// Please include [sources to cite] sources to support the article.
// Additionally, please provide [examples/case studies/real-life scenarios] 
// to illustrate the topic if possible.'''
//   },
//   {
//     'name': 'Blog post ',
//     'fields': [
//       'Topic',
//       'word count',
//       'target audience',
//       'call to action',
//     ],
//     'prompt': ''
//   },
//   {
//     'name': 'Social media post ',
//     'fields': ['Platform', 'persona', 'tone', 'type of content', 'hashtags'],
//     'prompt': ''
//   },
//   {
//     'name': 'Email newsletter ',
//     'fields': [
//       'Recipient demographics',
//       'frequency',
//       'sections to include',
//     ],
//     'prompt': ''
//   },
//   {
//     'name': 'Product description ',
//     'fields': ['Product details', 'target audience', 'features', 'benefits'],
//     'prompt': ''
//   },
//   {
//     'name': 'Job description ',
//     'fields': [
//       'Job title',
//       'responsibilities',
//       'required skills',
//       'qualifications'
//     ],
//     'prompt': ''
//   },
//   {
//     'name': 'Report ',
//     'fields': [
//       'Type',
//       'intended audience',
//       'recommendations',
//       'length',
//       'formatting'
//     ],
//     'prompt': ''
//   },
//   {
//     'name': 'White paper ',
//     'fields': [
//       'Topic',
//       'target audience',
//       'purpose',
//       'recommended length',
//     ],
//     'prompt': ''
//   },
//   {
//     'name': 'Press release ',
//     'fields': [
//       'News',
//       'organization details',
//       'spokesperson quotes',
//       'contact'
//     ],
//     'prompt': ''
//   },
//   {
//     'name': 'Case study ',
//     'fields': [
//       'Company',
//       'solution',
//       'benefits',
//       'customer highlights',
//       'testimonials'
//     ],
//     'prompt': ''
//   },
//   {
//     'name': 'Infographic ',
//     'fields': ['Topic', 'data points', 'visual elements', 'intended viewers'],
//     'prompt': ''
//   },
//   {
//     'name': 'Research paper ',
//     'fields': [
//       'Topic',
//       'hypothesis',
//       'methodology',
//       'analysis',
//       'literature review'
//     ],
//     'prompt': ''
//   },
//   {
//     'name': 'Manual ',
//     'fields': [
//       'Product',
//       'intended users',
//       'functions',
//       'procedures',
//       'troubleshooting'
//     ],
//     'prompt': ''
//   },
//   {
//     'name': 'Ebook ',
//     'fields': ['Topic', 'word count', 'chapters', 'target readers', 'goals'],
//     'prompt': ''
//   },
//   {
//     'name': 'Book ',
//     'fields': [
//       'Genre',
//       'plot',
//       'characters',
//       'setting',
//       'word count',
//     ],
//     'prompt': ''
//   },
//   {
//     'name': 'Summary ',
//     'fields': [
//       'Source text',
//       'intended readers',
//       'key points',
//       'recommended length'
//     ],
//     'prompt': ''
//   },
//   {
//     'name': 'Social media strategy ',
//     'fields': [
//       'Goals',
//       'target audience',
//       'content calendar',
//       'tone',
//       'hashtags'
//     ],
//     'prompt': ''
//   },
//   {
//     'name': 'Marketing plan ',
//     'fields': ['Objectives', 'target market', 'budget', 'tactics', 'timeline'],
//     'prompt': ''
//   },
//   {
//     'name': 'Business plan ',
//     'fields': [
//       'Industry',
//       'products/services',
//       'goals',
//       'strategy',
//       'finances'
//     ],
//     'prompt': ''
//   },
//   {
//     'name': 'Meeting minutes ',
//     'fields': [
//       'Attendees',
//       'agenda items',
//       'discussion points',
//       'action items'
//     ],
//     'prompt': ''
//   },
//   {
//     'name': 'Speech ',
//     'fields': [
//       'Audience',
//       'length',
//       'main points',
//       'supporting facts',
//       'conclusion'
//     ],
//     'prompt': ''
//   },
//   {
//     'name': 'Recipe ',
//     'fields': [
//       'Ingredients',
//       'equipment',
//       'preparations steps',
//       'cooking instructions',
//       'photos'
//     ],
//     'prompt': ''
//   },
//   {
//     'name': 'Itinerary ',
//     'fields': ['Locations', 'transport details', 'schedule', 'sights to see'],
//     'prompt': ''
//   },
//   {
//     'name': 'Invoice ',
//     'fields': [
//       'Purchased items/services',
//       'customer information',
//       'payment details'
//     ],
//     'prompt': ''
//   },
//   {
//     'name': 'Survey ',
//     'fields': [
//       'Questions',
//       'response options',
//       'distribution method',
//       ' recipients'
//     ],
//     'prompt': ''
//   },
// };

/*
I'm looking for a comprehensive article on [topic] 
that covers [covers]. 
The article should be [brief/medium/long] in length and 
provide a [level of detail] overview of the topic.
Please include [sources to cite] sources to support the article.
Additionally, please provide [examples/case studies/real-life scenarios] 
to illustrate the topic if possible.
 */
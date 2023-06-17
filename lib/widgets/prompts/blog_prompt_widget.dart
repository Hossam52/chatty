// import 'package:chatgpt/models/prompts/all_promts.dart';
// import 'package:chatgpt/models/prompts/prompt_types_interfaces.dart';
// import 'package:chatgpt/widgets/prompts/all_prompts_widgets.dart';

// class NewsArticlePromptWidget extends NewsArticlePrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(
//       promptName: ' Topic',
//     ),
//     TextpromptWidget(
//       promptName: ' length',
//     ),
//     TextpromptWidget(
//       promptName: ' level of detail',
//     ),
//     TextpromptWidget(promptName: ' sources to cite'),
//   ];
// }

// class BlogPromptWidget extends BlogPrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(promptName: 'Topic'),
//     TextpromptWidget(promptName: 'Word count'),
//     TextpromptWidget(promptName: 'Target audience'),
//     TextpromptWidget(promptName: 'Call to action'),
//   ];
// }

// class SocialMediaPostPromptWidget extends SocialMediaPostPrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(promptName: ' Platform'),
//     TextpromptWidget(promptName: ' persona'),
//     TextpromptWidget(promptName: ' tone'),
//     TextpromptWidget(promptName: ' type of content'),
//     TextpromptWidget(promptName: ' hashtags')
//   ];
// }

// class EmailNewsLetterPromptWidget extends EmailNewsLetterPrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(
//       promptName: ' Recipient demographics',
//     ),
//     TextpromptWidget(
//       promptName: ' frequency',
//     ),
//     TextpromptWidget(promptName: ' sections to include'),
//   ];
// }

// class ProductPromptWidget extends ProductPrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(promptName: 'Product details'),
//     TextpromptWidget(promptName: 'target audience'),
//     TextpromptWidget(promptName: 'features'),
//     TextpromptWidget(promptName: 'benefits'),
//   ];
// }

// class JobPromptWidget extends JobPrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(promptName: 'Job title'),
//     TextpromptWidget(promptName: 'responsibilities'),
//     TextpromptWidget(promptName: 'required skills'),
//     TextpromptWidget(promptName: 'qualifications'),
//   ];
// }

// class ReportPromptWidget extends ReportPrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(promptName: 'Type'),
//     TextpromptWidget(promptName: 'intended audience'),
//     TextpromptWidget(promptName: 'recommendations'),
//     TextpromptWidget(promptName: 'length'),
//     TextpromptWidget(promptName: 'formatting'),
//   ];
// }

// class WhitePaperPromptWidget extends WhitePaperPrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(promptName: 'Topic'),
//     TextpromptWidget(promptName: 'Target audience'),
//     TextpromptWidget(promptName: 'Purpose'),
//     TextpromptWidget(promptName: 'Recommended length'),
//   ];
// }

// class PressReleasePromptWidget extends PressReleasePrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(promptName: 'News'),
//     TextpromptWidget(promptName: 'Organization details'),
//     TextpromptWidget(promptName: 'spoken person quotes'),
//     TextpromptWidget(promptName: 'contacts'),
//   ];
// }

// class CaseStudyPromptWidget extends CaseStudyPrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(promptName: 'Company'),
//     TextpromptWidget(promptName: 'Solution'),
//     TextpromptWidget(promptName: 'Benfits'),
//     TextpromptWidget(promptName: 'Customer highlights'),
//     TextpromptWidget(promptName: 'testimonials'),
//   ];
// }

// class InfographicPromptWidget extends InfographicPrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(promptName: 'Topic'),
//     TextpromptWidget(promptName: 'Data points'),
//     TextpromptWidget(promptName: 'visual elements'),
//     TextpromptWidget(promptName: 'Intended viewers'),
//   ];
// }

// class ResearchPromptWidget extends ResearchPrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(promptName: 'Topic'),
//     TextpromptWidget(promptName: ''),
//     TextpromptWidget(promptName: ''),
//   ];
// }

// class EbookPromptWidget extends EbookPrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(promptName: ''),
//     TextpromptWidget(promptName: ''),
//     TextpromptWidget(promptName: ''),
//   ];
// }

// class BookPromptWidget extends BookPrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(promptName: ''),
//     TextpromptWidget(promptName: ''),
//     TextpromptWidget(promptName: ''),
//   ];
// }

// class SummaryPromptWidget extends SummaryPrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(promptName: ''),
//     TextpromptWidget(promptName: ''),
//     TextpromptWidget(promptName: ''),
//   ];
// }

// class SocialMediaStrategyPromptWidget extends SocialMediaStrategyPrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(promptName: ''),
//     TextpromptWidget(promptName: ''),
//     TextpromptWidget(promptName: ''),
//   ];
// }

// class MarketingPlanPromptWidget extends MarketingPlanPrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(promptName: ''),
//     TextpromptWidget(promptName: ''),
//     TextpromptWidget(promptName: ''),
//   ];
// }

// class MeetingMinutesPromptWidget extends MeetingMinutesPrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(promptName: ''),
//     TextpromptWidget(promptName: ''),
//     TextpromptWidget(promptName: ''),
//   ];
// }

// class SpeechPromptWidget extends SpeechPrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(promptName: ''),
//     TextpromptWidget(promptName: ''),
//     TextpromptWidget(promptName: ''),
//   ];
// }

// class RecipePromptWidget extends RecipePrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(promptName: ''),
//     TextpromptWidget(promptName: ''),
//     TextpromptWidget(promptName: ''),
//   ];
// }

// class IteneraryPromptWidget extends IteneraryPrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(promptName: ''),
//     TextpromptWidget(promptName: ''),
//     TextpromptWidget(promptName: ''),
//   ];
// }

// class SurveyPromptWidget extends SurveyPrompt {
//   @override
//   List<PromptQuery> queries = [
//     TextpromptWidget(promptName: ''),
//     TextpromptWidget(promptName: ''),
//     TextpromptWidget(promptName: ''),
//   ];
// }

// final m = {
//   'Press release ': [
//     ' News',
//     ' organization details',
//     ' spokesperson quotes',
//     ' contact'
//   ],
//   'Case study ': [
//     ' Company',
//     ' solution',
//     ' benefits',
//     ' customer highlights',
//     ' testimonials'
//   ],
//   'Infographic ': [
//     ' Topic',
//     ' data points',
//     ' visual elements',
//     ' intended viewers'
//   ],
//   'Research paper ': [
//     ' Topic',
//     ' hypothesis',
//     ' methodology',
//     ' analysis',
//     ' literature review'
//   ],
//   'Manual ': [
//     ' Product',
//     ' intended users',
//     ' functions',
//     ' procedures',
//     ' troubleshooting'
//   ],
//   'Ebook ': [' Topic', ' word count', ' chapters', ' target readers', ' goals'],
//   'Book ': [' Genre', ' plot', ' characters', ' setting', ' word count'],
//   'Summary ': [
//     ' Source text',
//     ' intended readers',
//     ' key points',
//     ' recommended length'
//   ],
//   'Social media strategy ': [
//     ' Goals',
//     ' target audience',
//     ' content calendar',
//     ' tone',
//     ' hashtags'
//   ],
//   'Marketing plan ': [
//     ' Objectives',
//     ' target market',
//     ' budget',
//     ' tactics',
//     ' timeline'
//   ],
//   'Business plan ': [
//     ' Industry',
//     ' products/services',
//     ' goals',
//     ' strategy',
//     ' finances'
//   ],
//   'Meeting minutes ': [
//     ' Attendees',
//     ' agenda items',
//     ' discussion points',
//     ' action items'
//   ],
//   'Speech ': [
//     ' Audience',
//     ' length',
//     ' main points',
//     ' supporting facts',
//     ' conclusion'
//   ],
//   'Recipe ': [
//     ' Ingredients',
//     ' equipment',
//     ' preparations steps',
//     ' cooking instructions',
//     ' photos'
//   ],
//   'Itinerary ': [
//     ' Locations',
//     ' transport details',
//     ' schedule',
//     ' sights to see'
//   ],
//   'Invoice ': [
//     'Purchased items/services',
//     ' customer information',
//     ' payment details'
//   ],
//   'Survey ': [
//     ' Questions',
//     ' response options',
//     ' distribution method',
//     ' recipients'
//   ],
// };

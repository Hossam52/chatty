import 'persona_question.dart';
import 'system_role_model.dart';

class ProgrammerPersona extends SystemRoleModel {
  ProgrammerPersona()
      : super('Software egineer', 'experienced developer and a programmer', [
          PersonaQuestion(label: 'Prefered programming language'),
          PersonaQuestion(label: 'Your experience'),
          PersonaQuestion(label: 'Your main expertise'),
          PersonaQuestion(label: 'What your search'),
        ]);
}

class AccountantPerona extends SystemRoleModel {
  AccountantPerona()
      : super('Accountant', 'experienced accountant for the questions', []);
}

class HumanResoursePersona extends SystemRoleModel {
  HumanResoursePersona()
      : super(
            'HR',
            'very talented hr seeking for people in company called Algoriza and want you ask the candidate questions until you are definitely sure for this candidate but question one at a time max 4 questions',
            [
              PersonaQuestion(label: 'Job'),
              PersonaQuestion(label: 'Company description'),
              PersonaQuestion(label: 'Company field'),
              PersonaQuestion(label: 'Expected person age'),
              PersonaQuestion(label: 'Experience needed'),
            ]);
}

class CreativeWriterPersona extends SystemRoleModel {
  CreativeWriterPersona() : super('Creative Writer', '', []);
}

class ContentGeneratorPersona extends SystemRoleModel {
  ContentGeneratorPersona() : super('Content Generator', '', []);
}

class CopywriterPersona extends SystemRoleModel {
  CopywriterPersona() : super('Copywriter', '', []);
}

class VirtualAssistantPersona extends SystemRoleModel {
  VirtualAssistantPersona() : super('Virtual Assistant', '', []);
}

class TutorPersona extends SystemRoleModel {
  TutorPersona() : super('Tutor', '', []);
}

class TranslatorPersona extends SystemRoleModel {
  TranslatorPersona() : super('Translator', '', []);
}

class ResearchAssistantPersona extends SystemRoleModel {
  ResearchAssistantPersona() : super('Research Assistant', '', []);
}

class TechnicalWriterPersona extends SystemRoleModel {
  TechnicalWriterPersona() : super('Technical Writer', '', []);
}

class ProofreaderPersona extends SystemRoleModel {
  ProofreaderPersona() : super('Proofreader', '', []);
}

class ConversationPartnerPersona extends SystemRoleModel {
  ConversationPartnerPersona() : super(' Conversation Partner', '', []);
}

class StorytellerPersona extends SystemRoleModel {
  StorytellerPersona() : super(' Storyteller', '', []);
}

class BloggerPersona extends SystemRoleModel {
  BloggerPersona() : super(' Blogger', '', []);
}

class PoetPersona extends SystemRoleModel {
  PoetPersona() : super(' Poet', '', []);
}

class ComedianPersona extends SystemRoleModel {
  ComedianPersona() : super(' Comedian (for generating jokes) ', '', []);
}

class GameMasterPersona extends SystemRoleModel {
  GameMasterPersona() : super(' Game Master (for text-based games)', '', []);
}

class PersonalizedrecommenderPersona extends SystemRoleModel {
  PersonalizedrecommenderPersona() : super(' Personalized recommender', '', []);
}

class TextQuestionAnsweringPersona extends SystemRoleModel {
  TextQuestionAnsweringPersona()
      : super(' Text-based question answering question answering', '', []);
}

class TextsummarizerPersona extends SystemRoleModel {
  TextsummarizerPersona() : super(' Text summarizer', '', []);
}

class EducationalresourcePersona extends SystemRoleModel {
  EducationalresourcePersona() : super(' Educational resource', '', []);
}

class LanguagelearningpartnerPersona extends SystemRoleModel {
  LanguagelearningpartnerPersona()
      : super(' Language learning partner', '', []);
}

class SocialMediaManagerPersona extends SystemRoleModel {
  SocialMediaManagerPersona() : super(' Social Media Manager', '', []);
}

class ScriptwriterPersona extends SystemRoleModel {
  ScriptwriterPersona() : super(' Scriptwriter', '', []);
}

class InterviewerPersona extends SystemRoleModel {
  InterviewerPersona() : super(' Interviewer', '', []);
}

class TranscriptionistPersona extends SystemRoleModel {
  TranscriptionistPersona() : super(' Transcriptionist', '', []);
}

class TourGuidePersona extends SystemRoleModel {
  TourGuidePersona() : super(' Tour Guide', '', []);
}

class CustomerSupportAgentPersona extends SystemRoleModel {
  CustomerSupportAgentPersona() : super(' Customer Support Agent', '', []);
}

class SpeechWriterPersona extends SystemRoleModel {
  SpeechWriterPersona() : super(' Speech Writer', '', []);
}

class ResumeCVWriterPersona extends SystemRoleModel {
  ResumeCVWriterPersona() : super(' Resume/CV Writer/CV Writer', '', []);
}

class SongLyricistPersona extends SystemRoleModel {
  SongLyricistPersona() : super(' Song Lyricist', '', []);
}

class ProductDescriptionWriterPersona extends SystemRoleModel {
  ProductDescriptionWriterPersona()
      : super(' Product Description Writer', '', []);
}

class GrantProposalWriterPersona extends SystemRoleModel {
  GrantProposalWriterPersona() : super(' Grant Proposal Writer', '', []);
}

class EssayWriterPersona extends SystemRoleModel {
  EssayWriterPersona() : super(' Essay Writer', '', []);
}

class NewsletterWriterPersona extends SystemRoleModel {
  NewsletterWriterPersona() : super(' Newsletter Writer', '', []);
}

class EventPlannerPersona extends SystemRoleModel {
  EventPlannerPersona() : super(' Event Planner', '', []);
}

class FinancialAdvisorPersona extends SystemRoleModel {
  FinancialAdvisorPersona() : super(' Financial Advisor', '', []);
}

class LegalConsultantPersona extends SystemRoleModel {
  LegalConsultantPersona() : super(' Legal Consultant', '', []);
}

class MedicalAdvisorPersona extends SystemRoleModel {
  MedicalAdvisorPersona() : super(' Medical Advisor (non-diagnostic)', '', []);
}

class HistoricalAdvisorPersona extends SystemRoleModel {
  HistoricalAdvisorPersona() : super(' Historical Advisor', '', []);
}

class NewsReporterPersona extends SystemRoleModel {
  NewsReporterPersona() : super(' News Reporter', '', []);
}

class RecipeCreatorPersona extends SystemRoleModel {
  RecipeCreatorPersona() : super(' Recipe Creator', '', []);
}

class LanguageModelTrainerPersona extends SystemRoleModel {
  LanguageModelTrainerPersona() : super(' Language Model Trainer', '', []);
}

class SEOSpecialistPersona extends SystemRoleModel {
  SEOSpecialistPersona() : super(' SEO Specialist', '', []);
}

class FictionalCharacterCreatorPersona extends SystemRoleModel {
  FictionalCharacterCreatorPersona()
      : super(' Fictional Character Creator', '', []);
}

class PersonalAssistantPersona extends SystemRoleModel {
  PersonalAssistantPersona() : super(' Personal Assistant', '', []);
}

class DialogueGenerationforChatbotsPersona extends SystemRoleModel {
  DialogueGenerationforChatbotsPersona()
      : super(' Dialogue Generation for Chatbots', '', []);
}

class OpinionPollingPersona extends SystemRoleModel {
  OpinionPollingPersona() : super(' Opinion Polling', '', []);
}

class FactCheckerPersona extends SystemRoleModel {
  FactCheckerPersona() : super(' Fact Checker', '', []);
}

class BookReviewerPersona extends SystemRoleModel {
  BookReviewerPersona() : super(' Book Reviewer', '', []);
}

class SpeechCoachPersona extends SystemRoleModel {
  SpeechCoachPersona() : super(' Speech Coach', '', []);
}

final supproterRoles = [
  CreativeWriterPersona(),
  ContentGeneratorPersona(),
  CopywriterPersona(),
  VirtualAssistantPersona(),
  TutorPersona(),
  TranslatorPersona(),
  ResearchAssistantPersona(),
  TechnicalWriterPersona(),
  ProofreaderPersona(),
  ConversationPartnerPersona(),
  StorytellerPersona(),
  BloggerPersona(),
  PoetPersona(),
  ComedianPersona(),
  GameMasterPersona(),
  PersonalizedrecommenderPersona(),
  TextQuestionAnsweringPersona(),
  TextsummarizerPersona(),
  EducationalresourcePersona(),
  LanguagelearningpartnerPersona(),
  SocialMediaManagerPersona(),
  ScriptwriterPersona(),
  InterviewerPersona(),
  TranscriptionistPersona(),
  TourGuidePersona(),
  CustomerSupportAgentPersona(),
  SpeechWriterPersona(),
  ResumeCVWriterPersona(),
  SongLyricistPersona(),
  ProductDescriptionWriterPersona(),
  GrantProposalWriterPersona(),
  EssayWriterPersona(),
  NewsletterWriterPersona(),
  EventPlannerPersona(),
  FinancialAdvisorPersona(),
  LegalConsultantPersona(),
  MedicalAdvisorPersona(),
  HistoricalAdvisorPersona(),
  NewsReporterPersona(),
  RecipeCreatorPersona(),
  LanguageModelTrainerPersona(),
  SEOSpecialistPersona(),
  FictionalCharacterCreatorPersona(),
  PersonalAssistantPersona(),
  DialogueGenerationforChatbotsPersona(),
  OpinionPollingPersona(),
  FactCheckerPersona(),
  BookReviewerPersona(),
  SpeechCoachPersona(),
];

import 'package:flutter/material.dart';
import 'dart:math';

enum QuestionType {
  audioToLetter,
  imageToFirstLetter,
  imageToWord,
  wordToImage,
  completeWord,
  countLetters,
}

class TestQuestion {
  final String id;
  final QuestionType type;
  final String question;
  final String? imagePath;
  final String? audioPath;
  final List<String> options;
  final String correctAnswer;
  final int level;
  final String? word;

  TestQuestion({
    required this.id,
    required this.type,
    required this.question,
    this.imagePath,
    this.audioPath,
    required this.options,
    required this.correctAnswer,
    required this.level,
    this.word,
  });

  TestQuestion shuffleOptions() {
    final random = Random();
    final shuffledOptions = List<String>.from(options)..shuffle(random);

    return TestQuestion(
      id: id,
      type: type,
      question: question,
      imagePath: imagePath,
      audioPath: audioPath,
      options: shuffledOptions,
      correctAnswer: correctAnswer,
      level: level,
      word: word,
    );
  }
}

class PlacementTestData {
  // بنك الأسئلة - المستوى 1: التعرف على الحروف (30 سؤالاً - كلها audioToLetter)
  static final List<TestQuestion> level1AudioQuestions = [
    TestQuestion(
        id: 'L1_Q1',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/أ - ألف.mp3',
        options: ['أ', 'ب', 'ت', 'ث'],
        correctAnswer: 'أ',
        level: 1),
    TestQuestion(
        id: 'L1_Q2',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ب - باء.mp3',
        options: ['أ', 'ب', 'ت', 'ث'],
        correctAnswer: 'ب',
        level: 1),
    TestQuestion(
        id: 'L1_Q3',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ت - تاء.mp3',
        options: ['ب', 'ت', 'ث', 'ن'],
        correctAnswer: 'ت',
        level: 1),
    TestQuestion(
        id: 'L1_Q4',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ث - ثاء.mp3',
        options: ['ت', 'ث', 'ن', 'ب'],
        correctAnswer: 'ث',
        level: 1),
    TestQuestion(
        id: 'L1_Q5',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ج - جيم.mp3',
        options: ['ج', 'ح', 'خ', 'ه'],
        correctAnswer: 'ج',
        level: 1),
    TestQuestion(
        id: 'L1_Q6',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ح - حاء.mp3',
        options: ['ج', 'ح', 'خ', 'ع'],
        correctAnswer: 'ح',
        level: 1),
    TestQuestion(
        id: 'L1_Q7',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/خ - خاء.mp3',
        options: ['ح', 'خ', 'ج', 'غ'],
        correctAnswer: 'خ',
        level: 1),
    TestQuestion(
        id: 'L1_Q8',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/د - دال.mp3',
        options: ['د', 'ذ', 'ر', 'ز'],
        correctAnswer: 'د',
        level: 1),
    TestQuestion(
        id: 'L1_Q9',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ذ - ذال.mp3',
        options: ['د', 'ذ', 'ز', 'ر'],
        correctAnswer: 'ذ',
        level: 1),
    TestQuestion(
        id: 'L1_Q10',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ر - راء.mp3',
        options: ['ر', 'ز', 'د', 'ذ'],
        correctAnswer: 'ر',
        level: 1),
    TestQuestion(
        id: 'L1_Q11',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ز - زاي.mp3',
        options: ['ر', 'ز', 'س', 'ص'],
        correctAnswer: 'ز',
        level: 1),
    TestQuestion(
        id: 'L1_Q12',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/س - سين.mp3',
        options: ['س', 'ش', 'ص', 'ض'],
        correctAnswer: 'س',
        level: 1),
    TestQuestion(
        id: 'L1_Q13',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ش - شين.mp3',
        options: ['س', 'ش', 'ص', 'ج'],
        correctAnswer: 'ش',
        level: 1),
    TestQuestion(
        id: 'L1_Q14',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ص - صاد.mp3',
        options: ['س', 'ص', 'ض', 'ط'],
        correctAnswer: 'ص',
        level: 1),
    TestQuestion(
        id: 'L1_Q15',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ض - ضاد.mp3',
        options: ['ص', 'ض', 'ط', 'ظ'],
        correctAnswer: 'ض',
        level: 1),
    TestQuestion(
        id: 'L1_Q16',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ط - طاء.mp3',
        options: ['ط', 'ظ', 'ت', 'ث'],
        correctAnswer: 'ط',
        level: 1),
    TestQuestion(
        id: 'L1_Q17',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ظ - ظاء.mp3',
        options: ['ط', 'ظ', 'ض', 'ذ'],
        correctAnswer: 'ظ',
        level: 1),
    TestQuestion(
        id: 'L1_Q18',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ع - عين.mp3',
        options: ['ع', 'غ', 'ح', 'خ'],
        correctAnswer: 'ع',
        level: 1),
    TestQuestion(
        id: 'L1_Q19',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/غ - غين.mp3',
        options: ['ع', 'غ', 'خ', 'ق'],
        correctAnswer: 'غ',
        level: 1),
    TestQuestion(
        id: 'L1_Q20',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ف - فاء.mp3',
        options: ['ف', 'ق', 'ك', 'ل'],
        correctAnswer: 'ف',
        level: 1),
    TestQuestion(
        id: 'L1_Q21',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ق - قاف.mp3',
        options: ['ف', 'ق', 'ك', 'غ'],
        correctAnswer: 'ق',
        level: 1),
    TestQuestion(
        id: 'L1_Q22',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ك - كاف.mp3',
        options: ['ق', 'ك', 'ل', 'م'],
        correctAnswer: 'ك',
        level: 1),
    TestQuestion(
        id: 'L1_Q23',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ل - لام.mp3',
        options: ['ك', 'ل', 'م', 'ن'],
        correctAnswer: 'ل',
        level: 1),
    TestQuestion(
        id: 'L1_Q24',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/م - ميم.mp3',
        options: ['ل', 'م', 'ن', 'ه'],
        correctAnswer: 'م',
        level: 1),
    TestQuestion(
        id: 'L1_Q25',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ن - نون.mp3',
        options: ['م', 'ن', 'ه', 'و'],
        correctAnswer: 'ن',
        level: 1),
    TestQuestion(
        id: 'L1_Q26',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ه - هاء.mp3',
        options: ['ن', 'ه', 'و', 'ي'],
        correctAnswer: 'ه',
        level: 1),
    TestQuestion(
        id: 'L1_Q27',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/و - واو.mp3',
        options: ['ه', 'و', 'ي', 'ء'],
        correctAnswer: 'و',
        level: 1),
    TestQuestion(
        id: 'L1_Q28',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ي - ياء.mp3',
        options: ['و', 'ي', 'ن', 'ت'],
        correctAnswer: 'ي',
        level: 1),
    TestQuestion(
        id: 'L1_Q29',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/أ - ألف.mp3',
        options: ['أ', 'ع', 'ه', 'و'],
        correctAnswer: 'أ',
        level: 1),
    TestQuestion(
        id: 'L1_Q30',
        type: QuestionType.audioToLetter,
        question: 'استمع واختر الحرف الصحيح',
        audioPath: 'audio/letters/ب - باء.mp3',
        options: ['ب', 'ت', 'ن', 'ي'],
        correctAnswer: 'ب',
        level: 1),
  ];

  // المستوى 2: imageToFirstLetter (15 سؤالاً)
  static final List<TestQuestion> level2FirstLetterQuestions = [
    TestQuestion(
        id: 'L2_FL1',
        type: QuestionType.imageToFirstLetter,
        question: 'ما هو الحرف الأول؟',
        imagePath: 'images/animals/أسد.jpg',
        options: ['أ', 'س', 'د', 'ل'],
        correctAnswer: 'أ',
        level: 2,
        word: 'أسد'),
    TestQuestion(
        id: 'L2_FL2',
        type: QuestionType.imageToFirstLetter,
        question: 'ما هو الحرف الأول؟',
        imagePath: 'images/animals/بقرة.jpg',
        options: ['ب', 'ق', 'ر', 'ه'],
        correctAnswer: 'ب',
        level: 2,
        word: 'بقرة'),
    TestQuestion(
        id: 'L2_FL3',
        type: QuestionType.imageToFirstLetter,
        question: 'ما هو الحرف الأول؟',
        imagePath: 'images/animals/جمل.jpg',
        options: ['ج', 'م', 'ل', 'ح'],
        correctAnswer: 'ج',
        level: 2,
        word: 'جمل'),
    TestQuestion(
        id: 'L2_FL4',
        type: QuestionType.imageToFirstLetter,
        question: 'ما هو الحرف الأول؟',
        imagePath: 'images/animals/دجاجة.jpg',
        options: ['د', 'ج', 'ح', 'خ'],
        correctAnswer: 'د',
        level: 2,
        word: 'دجاجة'),
    TestQuestion(
        id: 'L2_FL5',
        type: QuestionType.imageToFirstLetter,
        question: 'ما هو الحرف الأول؟',
        imagePath: 'images/animals/ذئب.jpg',
        options: ['ذ', 'ز', 'د', 'ر'],
        correctAnswer: 'ذ',
        level: 2,
        word: 'ذئب'),
    TestQuestion(
        id: 'L2_FL6',
        type: QuestionType.imageToFirstLetter,
        question: 'ما هو الحرف الأول؟',
        imagePath: 'images/animals/زرافة.jpg',
        options: ['ز', 'ر', 'س', 'ص'],
        correctAnswer: 'ز',
        level: 2,
        word: 'زرافة'),
    TestQuestion(
        id: 'L2_FL7',
        type: QuestionType.imageToFirstLetter,
        question: 'ما هو الحرف الأول؟',
        imagePath: 'images/animals/فيل.jpg',
        options: ['ف', 'ق', 'ل', 'ي'],
        correctAnswer: 'ف',
        level: 2,
        word: 'فيل'),
    TestQuestion(
        id: 'L2_FL8',
        type: QuestionType.imageToFirstLetter,
        question: 'ما هو الحرف الأول؟',
        imagePath: 'images/animals/قطة.jpg',
        options: ['ق', 'ك', 'ط', 'ت'],
        correctAnswer: 'ق',
        level: 2,
        word: 'قطة'),
    TestQuestion(
        id: 'L2_FL9',
        type: QuestionType.imageToFirstLetter,
        question: 'ما هو الحرف الأول؟',
        imagePath: 'images/animals/كلب.jpg',
        options: ['ك', 'ق', 'ل', 'ب'],
        correctAnswer: 'ك',
        level: 2,
        word: 'كلب'),
    TestQuestion(
        id: 'L2_FL10',
        type: QuestionType.imageToFirstLetter,
        question: 'ما هو الحرف الأول؟',
        imagePath: 'images/animals/نمر.jpg',
        options: ['ن', 'م', 'ر', 'ل'],
        correctAnswer: 'ن',
        level: 2,
        word: 'نمر'),
    TestQuestion(
        id: 'L2_FL11',
        type: QuestionType.imageToFirstLetter,
        question: 'ما هو الحرف الأول؟',
        imagePath: 'images/animals/حمار.jpg',
        options: ['ح', 'خ', 'م', 'ر'],
        correctAnswer: 'ح',
        level: 2,
        word: 'حمار'),
    TestQuestion(
        id: 'L2_FL12',
        type: QuestionType.imageToFirstLetter,
        question: 'ما هو الحرف الأول؟',
        imagePath: 'images/animals/خروف.jpg',
        options: ['خ', 'ح', 'ر', 'ف'],
        correctAnswer: 'خ',
        level: 2,
        word: 'خروف'),
    TestQuestion(
        id: 'L2_FL13',
        type: QuestionType.imageToFirstLetter,
        question: 'ما هو الحرف الأول؟',
        imagePath: 'images/animals/صقر.jpg',
        options: ['ص', 'س', 'ق', 'ر'],
        correctAnswer: 'ص',
        level: 2,
        word: 'صقر'),
    TestQuestion(
        id: 'L2_FL14',
        type: QuestionType.imageToFirstLetter,
        question: 'ما هو الحرف الأول؟',
        imagePath: 'images/animals/ضفدع.jpg',
        options: ['ض', 'ص', 'ف', 'د'],
        correctAnswer: 'ض',
        level: 2,
        word: 'ضفدع'),
    TestQuestion(
        id: 'L2_FL15',
        type: QuestionType.imageToFirstLetter,
        question: 'ما هو الحرف الأول؟',
        imagePath: 'images/animals/أرنب.jpg',
        options: ['أ', 'ر', 'ن', 'ب'],
        correctAnswer: 'أ',
        level: 2,
        word: 'أرنب'),
  ];

  // المستوى 2: countLetters (15 سؤالاً)
  static final List<TestQuestion> level2CountQuestions = [
    TestQuestion(
        id: 'L2_C1',
        type: QuestionType.countLetters,
        question: 'كم حرفاً في كلمة "نمر"؟',
        imagePath: 'images/animals/نمر.jpg',
        options: ['2', '3', '4', '5'],
        correctAnswer: '3',
        level: 2,
        word: 'نمر'),
    TestQuestion(
        id: 'L2_C2',
        type: QuestionType.countLetters,
        question: 'كم حرفاً في كلمة "جمل"؟',
        imagePath: 'images/animals/جمل.jpg',
        options: ['2', '3', '4', '5'],
        correctAnswer: '3',
        level: 2,
        word: 'جمل'),
    TestQuestion(
        id: 'L2_C3',
        type: QuestionType.countLetters,
        question: 'كم حرفاً في كلمة "أسد"؟',
        imagePath: 'images/animals/أسد.jpg',
        options: ['2', '3', '4', '5'],
        correctAnswer: '3',
        level: 2,
        word: 'أسد'),
    TestQuestion(
        id: 'L2_C4',
        type: QuestionType.countLetters,
        question: 'كم حرفاً في كلمة "فيل"؟',
        imagePath: 'images/animals/فيل.jpg',
        options: ['2', '3', '4', '5'],
        correctAnswer: '3',
        level: 2,
        word: 'فيل'),
    TestQuestion(
        id: 'L2_C5',
        type: QuestionType.countLetters,
        question: 'كم حرفاً في كلمة "قطة"؟',
        imagePath: 'images/animals/قطة.jpg',
        options: ['2', '3', '4', '5'],
        correctAnswer: '3',
        level: 2,
        word: 'قطة'),
    TestQuestion(
        id: 'L2_C6',
        type: QuestionType.countLetters,
        question: 'كم حرفاً في كلمة "كلب"؟',
        imagePath: 'images/animals/كلب.jpg',
        options: ['2', '3', '4', '5'],
        correctAnswer: '3',
        level: 2,
        word: 'كلب'),
    TestQuestion(
        id: 'L2_C7',
        type: QuestionType.countLetters,
        question: 'كم حرفاً في كلمة "ذئب"؟',
        imagePath: 'images/animals/ذئب.jpg',
        options: ['2', '3', '4', '5'],
        correctAnswer: '3',
        level: 2,
        word: 'ذئب'),
    TestQuestion(
        id: 'L2_C8',
        type: QuestionType.countLetters,
        question: 'كم حرفاً في كلمة "صقر"؟',
        imagePath: 'images/animals/صقر.jpg',
        options: ['2', '3', '4', '5'],
        correctAnswer: '3',
        level: 2,
        word: 'صقر'),
    TestQuestion(
        id: 'L2_C9',
        type: QuestionType.countLetters,
        question: 'كم حرفاً في كلمة "بقرة"؟',
        imagePath: 'images/animals/بقرة.jpg',
        options: ['3', '4', '5', '6'],
        correctAnswer: '4',
        level: 2,
        word: 'بقرة'),
    TestQuestion(
        id: 'L2_C10',
        type: QuestionType.countLetters,
        question: 'كم حرفاً في كلمة "حمار"؟',
        imagePath: 'images/animals/حمار.jpg',
        options: ['3', '4', '5', '6'],
        correctAnswer: '4',
        level: 2,
        word: 'حمار'),
    TestQuestion(
        id: 'L2_C11',
        type: QuestionType.countLetters,
        question: 'كم حرفاً في كلمة "خروف"؟',
        imagePath: 'images/animals/خروف.jpg',
        options: ['3', '4', '5', '6'],
        correctAnswer: '4',
        level: 2,
        word: 'خروف'),
    TestQuestion(
        id: 'L2_C12',
        type: QuestionType.countLetters,
        question: 'كم حرفاً في كلمة "أرنب"؟',
        imagePath: 'images/animals/أرنب.jpg',
        options: ['3', '4', '5', '6'],
        correctAnswer: '4',
        level: 2,
        word: 'أرنب'),
    TestQuestion(
        id: 'L2_C13',
        type: QuestionType.countLetters,
        question: 'كم حرفاً في كلمة "زرافة"؟',
        imagePath: 'images/animals/زرافة.jpg',
        options: ['4', '5', '6', '7'],
        correctAnswer: '5',
        level: 2,
        word: 'زرافة'),
    TestQuestion(
        id: 'L2_C14',
        type: QuestionType.countLetters,
        question: 'كم حرفاً في كلمة "دجاجة"؟',
        imagePath: 'images/animals/دجاجة.jpg',
        options: ['4', '5', '6', '7'],
        correctAnswer: '5',
        level: 2,
        word: 'دجاجة'),
    TestQuestion(
        id: 'L2_C15',
        type: QuestionType.countLetters,
        question: 'كم حرفاً في كلمة "ضفدع"؟',
        imagePath: 'images/animals/ضفدع.jpg',
        options: ['3', '4', '5', '6'],
        correctAnswer: '4',
        level: 2,
        word: 'ضفدع'),
  ];

  // المستوى 3: wordToImage (10 أسئلة)
  static final List<TestQuestion> level3WordToImageQuestions = [
    TestQuestion(
        id: 'L3_WI1',
        type: QuestionType.wordToImage,
        question: 'اقرأ الكلمة واختر الصورة',
        word: 'كلب',
        options: [
          'images/animals/كلب.jpg',
          'images/animals/قطة.jpg',
          'images/animals/أرنب.jpg',
          'images/animals/فأر.jpg'
        ],
        correctAnswer: 'images/animals/كلب.jpg',
        level: 3),
    TestQuestion(
        id: 'L3_WI2',
        type: QuestionType.wordToImage,
        question: 'اقرأ الكلمة واختر الصورة',
        word: 'قطة',
        options: [
          'images/animals/قطة.jpg',
          'images/animals/كلب.jpg',
          'images/animals/أسد.jpg',
          'images/animals/نمر.jpg'
        ],
        correctAnswer: 'images/animals/قطة.jpg',
        level: 3),
    TestQuestion(
        id: 'L3_WI3',
        type: QuestionType.wordToImage,
        question: 'اقرأ الكلمة واختر الصورة',
        word: 'أسد',
        options: [
          'images/animals/أسد.jpg',
          'images/animals/نمر.jpg',
          'images/animals/فهد.jpg',
          'images/animals/قطة.jpg'
        ],
        correctAnswer: 'images/animals/أسد.jpg',
        level: 3),
    TestQuestion(
        id: 'L3_WI4',
        type: QuestionType.wordToImage,
        question: 'اقرأ الكلمة واختر الصورة',
        word: 'فيل',
        options: [
          'images/animals/فيل.jpg',
          'images/animals/جمل.jpg',
          'images/animals/زرافة.jpg',
          'images/animals/حمار.jpg'
        ],
        correctAnswer: 'images/animals/فيل.jpg',
        level: 3),
    TestQuestion(
        id: 'L3_WI5',
        type: QuestionType.wordToImage,
        question: 'اقرأ الكلمة واختر الصورة',
        word: 'باب',
        options: [
          'images/objects/باب.jpg',
          'images/objects/نافذة.jpg',
          'images/objects/كرسي.jpg',
          'images/objects/طاولة.jpg'
        ],
        correctAnswer: 'images/objects/باب.jpg',
        level: 3),
    TestQuestion(
        id: 'L3_WI6',
        type: QuestionType.wordToImage,
        question: 'اقرأ الكلمة واختر الصورة',
        word: 'كرسي',
        options: [
          'images/objects/كرسي.jpg',
          'images/objects/طاولة.jpg',
          'images/objects/سرير.jpg',
          'images/objects/مكتب.jpg'
        ],
        correctAnswer: 'images/objects/كرسي.jpg',
        level: 3),
    TestQuestion(
        id: 'L3_WI7',
        type: QuestionType.wordToImage,
        question: 'اقرأ الكلمة واختر الصورة',
        word: 'قلم',
        options: [
          'images/objects/قلم رصاص.jpg',
          'images/objects/كتاب.jpg',
          'images/objects/مسطرة.jpg',
          'images/objects/مقص.jpg'
        ],
        correctAnswer: 'images/objects/قلم رصاص.jpg',
        level: 3),
    TestQuestion(
        id: 'L3_WI8',
        type: QuestionType.wordToImage,
        question: 'اقرأ الكلمة واختر الصورة',
        word: 'كتاب',
        options: [
          'images/objects/كتاب.jpg',
          'images/objects/كراسة.jpg',
          'images/objects/قلم رصاص.jpg',
          'images/objects/حقيبة.jpg'
        ],
        correctAnswer: 'images/objects/كتاب.jpg',
        level: 3),
    TestQuestion(
        id: 'L3_WI9',
        type: QuestionType.wordToImage,
        question: 'اقرأ الكلمة واختر الصورة',
        word: 'جمل',
        options: [
          'images/animals/جمل.jpg',
          'images/animals/فيل.jpg',
          'images/animals/زرافة.jpg',
          'images/animals/حمار.jpg'
        ],
        correctAnswer: 'images/animals/جمل.jpg',
        level: 3),
    TestQuestion(
        id: 'L3_WI10',
        type: QuestionType.wordToImage,
        question: 'اقرأ الكلمة واختر الصورة',
        word: 'نمر',
        options: [
          'images/animals/نمر.jpg',
          'images/animals/أسد.jpg',
          'images/animals/فهد.jpg',
          'images/animals/قطة.jpg'
        ],
        correctAnswer: 'images/animals/نمر.jpg',
        level: 3),
  ];

  // المستوى 3: imageToWord (5 أسئلة)
  static final List<TestQuestion> level3ImageToWordQuestions = [
    TestQuestion(
        id: 'L3_IW1',
        type: QuestionType.imageToWord,
        question: 'اختر الكلمة الصحيحة',
        imagePath: 'images/objects/قلم رصاص.jpg',
        options: ['قلم', 'كتاب', 'مسطرة', 'مقص'],
        correctAnswer: 'قلم',
        level: 3),
    TestQuestion(
        id: 'L3_IW2',
        type: QuestionType.imageToWord,
        question: 'اختر الكلمة الصحيحة',
        imagePath: 'images/objects/كتاب.jpg',
        options: ['كتاب', 'كراسة', 'قلم', 'حقيبة'],
        correctAnswer: 'كتاب',
        level: 3),
    TestQuestion(
        id: 'L3_IW3',
        type: QuestionType.imageToWord,
        question: 'اختر الكلمة الصحيحة',
        imagePath: 'images/objects/باب.jpg',
        options: ['باب', 'نافذة', 'حائط', 'سقف'],
        correctAnswer: 'باب',
        level: 3),
    TestQuestion(
        id: 'L3_IW4',
        type: QuestionType.imageToWord,
        question: 'اختر الكلمة الصحيحة',
        imagePath: 'images/animals/أسد.jpg',
        options: ['أسد', 'نمر', 'فهد', 'قطة'],
        correctAnswer: 'أسد',
        level: 3),
    TestQuestion(
        id: 'L3_IW5',
        type: QuestionType.imageToWord,
        question: 'اختر الكلمة الصحيحة',
        imagePath: 'images/animals/فيل.jpg',
        options: ['فيل', 'جمل', 'زرافة', 'حمار'],
        correctAnswer: 'فيل',
        level: 3),
  ];

  // المستوى 3: completeWord (5 أسئلة)
  static final List<TestQuestion> level3CompleteWordQuestions = [
    TestQuestion(
        id: 'L3_CW1',
        type: QuestionType.completeWord,
        question: 'أكمل الحرف الناقص: أ_نب',
        imagePath: 'images/animals/أرنب.jpg',
        options: ['ر', 'ز', 'س', 'ش'],
        correctAnswer: 'ر',
        level: 3,
        word: 'أرنب'),
    TestQuestion(
        id: 'L3_CW2',
        type: QuestionType.completeWord,
        question: 'أكمل الحرف الناقص: ق_ة',
        imagePath: 'images/animals/قطة.jpg',
        options: ['ط', 'ت', 'ك', 'ص'],
        correctAnswer: 'ط',
        level: 3,
        word: 'قطة'),
    TestQuestion(
        id: 'L3_CW3',
        type: QuestionType.completeWord,
        question: 'أكمل الحرف الناقص: ك_ب',
        imagePath: 'images/animals/كلب.jpg',
        options: ['ل', 'ت', 'ن', 'م'],
        correctAnswer: 'ل',
        level: 3,
        word: 'كلب'),
    TestQuestion(
        id: 'L3_CW4',
        type: QuestionType.completeWord,
        question: 'أكمل الحرف الناقص: ج_ل',
        imagePath: 'images/animals/جمل.jpg',
        options: ['م', 'ن', 'ل', 'ر'],
        correctAnswer: 'م',
        level: 3,
        word: 'جمل'),
    TestQuestion(
        id: 'L3_CW5',
        type: QuestionType.completeWord,
        question: 'أكمل الحرف الناقص: ف_ل',
        imagePath: 'images/animals/فيل.jpg',
        options: ['ي', 'و', 'ا', 'ع'],
        correctAnswer: 'ي',
        level: 3,
        word: 'فيل'),
  ];

  // اختيار 20 سؤالاً بتوزيع متساوي لأنواع الأسئلة
  static List<TestQuestion> getAllQuestions() {
    final random = Random();
    final allQuestions = <TestQuestion>[];

    // المستوى 1: 7 أسئلة audioToLetter
    final shuffledL1 = List<TestQuestion>.from(level1AudioQuestions)
      ..shuffle(random);
    allQuestions.addAll(shuffledL1.take(7));

    // المستوى 2: 4 imageToFirstLetter + 3 countLetters = 7 أسئلة
    final shuffledL2First = List<TestQuestion>.from(level2FirstLetterQuestions)
      ..shuffle(random);
    final shuffledL2Count = List<TestQuestion>.from(level2CountQuestions)
      ..shuffle(random);
    allQuestions.addAll(shuffledL2First.take(4));
    allQuestions.addAll(shuffledL2Count.take(3));

    // المستوى 3: 3 wordToImage + 2 imageToWord + 1 completeWord = 6 أسئلة
    final shuffledL3WI = List<TestQuestion>.from(level3WordToImageQuestions)
      ..shuffle(random);
    final shuffledL3IW = List<TestQuestion>.from(level3ImageToWordQuestions)
      ..shuffle(random);
    final shuffledL3CW = List<TestQuestion>.from(level3CompleteWordQuestions)
      ..shuffle(random);
    allQuestions.addAll(shuffledL3WI.take(3));
    allQuestions.addAll(shuffledL3IW.take(2));
    allQuestions.addAll(shuffledL3CW.take(1));

    // خلط خيارات كل سؤال
    return allQuestions.map((q) => q.shuffleOptions()).toList();
  }

  static String determineLevelFromScore(int score) {
    if (score <= 5)
      return 'المستوى 1 - مرحلة التمهيد';
    else if (score <= 10)
      return 'المستوى 2 - مرحلة التأسيس';
    else if (score <= 14)
      return 'المستوى 3 - مرحلة التطوير';
    else if (score <= 17)
      return 'المستوى 4 - مرحلة متقدمة';
    else
      return 'المستوى 5 - مرحلة متقدمة جداً';
  }

  static String getEncouragementMessage(int score) {
    if (score <= 5)
      return 'رائع! سنبدأ معاً من البداية لنتعلم الحروف 🌟';
    else if (score <= 10)
      return 'ممتاز! أنت تعرف الحروف، الآن سنتعلم الكلمات 📚';
    else if (score <= 14)
      return 'أحسنت! أنت قارئ جيد، سنطور مهاراتك أكثر 🎯';
    else if (score <= 17)
      return 'مذهل! مستواك متقدم، سنتحدى معاً 🚀';
    else
      return 'رائع جداً! أنت نجم القراءة ⭐';
  }
}

enum NounCase {
  nom, // 主格
  voc, // 呼格
  gen, // 属格
  dat, // 与格
  acc, // 対格
  abl, // 奪格
}

enum NounType {
  noun, // 名詞
  adjective, // 形容詞
}

enum SexType {
  f, // 男性
  m, // 女性
  n, // 中性
}

enum Numbers {
  single, // 単数
  multi, // 複数
}

enum Mode {
  indicative, // 直接
  inperative, // 命令
  subjunctive, // 接続
}

enum Form {
  active, // 能動
  passive, // 受動
}

enum Tense {
  present, // 現在
  past, // 過去
  presentPerfect, // 現在完了
  pastPerfect, // 過去完了
}

enum Person {
  first, // 一人称
  second, // 二人称
  third, // 三人称
}

enum VerbConjugateType {
  vt1, // 第一変化
  vt2, // 第二変化
  vt3, // 第三変化
  vt3i, // 第三変化i
  vt4, // 第四変化
}

enum NounConjugateType {
  nt1, // 第一変化
  nt2, // 第二変化
  nt3, // 第三変化
  nt3i, // 第三変化i
}

// --

NounCase getNounCaseFromInt(int id) {
  const values = NounCase.values;
  if (id >= 0 && id < values.length) {
    return values[id];
  } else {
    return values[0];
  }
}

NounType getNounTypeFromInt(int id) {
  const values = NounType.values;
  if (id >= 0 && id < values.length) {
    return values[id];
  } else {
    return values[0];
  }
}

SexType getSexTypeFromInt(int id) {
  const values = SexType.values;
  if (id >= 0 && id < values.length) {
    return values[id];
  } else {
    return values[0];
  }
}

Numbers getNumbersFromInt(int id) {
  const values = Numbers.values;
  if (id >= 0 && id < values.length) {
    return values[id];
  } else {
    return values[0];
  }
}

Mode getModeFromInt(int id) {
  const values = Mode.values;
  if (id >= 0 && id < values.length) {
    return values[id];
  } else {
    return values[0];
  }
}

Form getFormFromInt(int id) {
  const values = Form.values;
  if (id >= 0 && id < values.length) {
    return values[id];
  } else {
    return values[0];
  }
}

Tense getTenseFromInt(int id) {
  const values = Tense.values;
  if (id >= 0 && id < values.length) {
    return values[id];
  } else {
    return values[0];
  }
}

Person getPersonFromInt(int id) {
  const values = Person.values;
  if (id >= 0 && id < values.length) {
    return values[id];
  } else {
    return values[0];
  }
}

VerbConjugateType getVerbConjugateTypeFromInt(int id) {
  const values = VerbConjugateType.values;
  if (id >= 0 && id < values.length) {
    return values[id];
  } else {
    return values[0];
  }
}

NounConjugateType getNounConjugateTypeFromInt(int id) {
  const values = NounConjugateType.values;
  if (id >= 0 && id < values.length) {
    return values[id];
  } else {
    return values[0];
  }
}

// --

String nounCaseToString(NounCase v) {
  switch (v) {
    case NounCase.nom:
      return "主格";
    case NounCase.voc:
      return "呼格";
    case NounCase.gen:
      return "属格";
    case NounCase.dat:
      return "与格";
    case NounCase.acc:
      return "対格";
    case NounCase.abl:
      return "奪格";
  }
}

String nounTypeToString(NounType v) {
  switch (v) {
    case NounType.noun:
      return "名詞";
    case NounType.adjective:
      return "形容詞";
  }
}

String sexTypeToString(SexType v) {
  switch (v) {
    case SexType.f:
      return "男性";
    case SexType.m:
      return "女性";
    case SexType.n:
      return "中性";
  }
}

String numbersToString(Numbers v) {
  switch (v) {
    case Numbers.single:
      return "単数";
    case Numbers.multi:
      return "複数";
  }
}

String modeToString(Mode v) {
  switch (v) {
    case Mode.indicative:
      return "直接";
    case Mode.inperative:
      return "命令";
    case Mode.subjunctive:
      return "接続";
  }
}

String formToString(Form v) {
  switch (v) {
    case Form.active:
      return "能動";
    case Form.passive:
      return "受動";
  }
}

String tenseToString(Tense v) {
  switch (v) {
    case Tense.present:
      return "現在";
    case Tense.past:
      return "過去";
    case Tense.presentPerfect:
      return "現在完了";
    case Tense.pastPerfect:
      return "過去完了";
  }
}

String personToString(Person v) {
  switch (v) {
    case Person.first:
      return "一人称";
    case Person.second:
      return "二人称";
    case Person.third:
      return "三人称";
  }
}

String verbConjugateTypeToString(VerbConjugateType v) {
  switch (v) {
    case VerbConjugateType.vt1:
      return "第一変化";
    case VerbConjugateType.vt2:
      return "第二変化";
    case VerbConjugateType.vt3:
      return "第三変化";
    case VerbConjugateType.vt3i:
      return "第三変化i";
    case VerbConjugateType.vt4:
      return "第四変化";
  }
}

String nounConjugateTypeToString(NounConjugateType v) {
  switch (v) {
    case NounConjugateType.nt1:
      return "第一変化";
    case NounConjugateType.nt2:
      return "第二変化";
    case NounConjugateType.nt3:
      return "第三変化";
    case NounConjugateType.nt3i:
      return "第三変化i";
  }
}

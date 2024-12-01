## クラス図
```Mermaid
classDiagram

    class Sentence {
        int id
        String la
        String en
        List<NounComponent> nounComponents
        List<VerbComponent> verbComponents
    }
    Sentence --> NounComponent : 1-N
    Sentence --> VerbComponent : 1-N

    class NounComponent {
        int id
        Noun noun
        NounCase nounCase: 格
        Numbers num: 数
    }
    NounComponent --> Noun
    NounComponent --> NounCase
    NounComponent --> Numbers

    class VerbComponent {
        int id
        Verb verb
        Mode mode: 法
        Form form: 態
        Tense tense: 時制
        Person person: 人称
        Numbers num: 数
    }
    VerbComponent --> Verb
    VerbComponent --> Mode
    VerbComponent --> Form
    VerbComponent --> Tense
    VerbComponent --> Person
    VerbComponent --> Numbers
    
    class Noun {
        int id
        String la
        String en
        NounType nounType: 名詞・形容詞
        NounConjugateType conjugateType: 変化のタイプ
        SexType sex: 性
    }
    Noun --> NounType
    Noun --> NounConjugateType
    Noun --> SexType

    class Verb {
        int id
        String la
        String en
        VerbConjugateType conjugateType: 変化のタイプ
    }
    Verb --> VerbConjugateType

    class NounCase {
        <<enumeration>>
        nom: 主格
        voc: 呼格
        gen: 属格
        dat: 与格
        acc: 対格
        abl: 奪格
    }

    class NounType {
        <<enumeration>>
        noun: 名詞
        adjective: 形容詞
    }

    class SexType {
        <<enumeration>>
        f: 男性
        m: 女性
        n: 中性
    }

    class Numbers {
        <<enumeration>>
        single: 単数
        multi: 複数
    }

    class Mode {
        <<enumeration>>
        indicative: 直接
        inperative: 命令
        subjunctive: 接続
    }

    class Form {
        <<enumeration>>
        active: 能動
        passive: 受動
    }

    class Tense {
        <<enumeration>>
        present: 現在
        past: 過去
        presentPerfect: 現在完了
        pastPerfect: 過去完了
    }

    class Person {
        <<enumeration>>
        first: 一人称
        second: 二人称
        third: 三人称
    }

    class VerbConjugateType {
        <<enumeration>>
        vt1: 第一変化
        vt2: 第二変化
        vt3: 第三変化
        vt3i: 第三変化i
        vt4: 第四変化
    }

    class NounConjugateType {
        <<enumeration>>
        nt1: 第一変化
        nt2: 第二変化
        nt3: 第三変化
        nt3i: 第三変化i
    }

```

## DB構成
```
create table $sentenceTable (
  id integer primary key autoincrement,
  la text not null,
  en text not null,
  nounComponents text,
  verbComponents text
)

create table $nounComponentTable (
  id integer primary key autoincrement,
  nounId integer not null,
  nounCase integer not null,
  num integer not null,
  foreign key (nounId)
    references Source ($nounTable)
    on delete cascade
)

create table $verbComponentTable (
  id integer primary key autoincrement,
  verbId integer not null,
  mode integer not null,
  form integer not null,
  tense integer not null,
  person integer not null,
  num integer not null,
  foreign key (verbId)
    references Source ($verbTable)
    on delete cascade
)

create table $nounTable (
  id integer primary key autoincrement,
  la text not null,
  en text not null,
  nounType integer not null,
  conjugateType integer not null,
  sex integer not null
)

create table $verbTable (
  id integer primary key autoincrement,
  la text not null,
  en text not null,
  conjugateType integer not null
)
```
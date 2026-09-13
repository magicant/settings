---
name: natural-style
description: 自然な文体で書いた文章の具体例。ドキュメント、報告書、翻訳など、まとまった文章を書く前に読み込む。日本語に限らずどの自然言語の文章にも使用する。
---

このスキルは、共通の指示 (AGENTS.md や CLAUDE.md など) にある文体の指針を、実際の文章に適用した例を示す。例の文章は日本語だが、同じ指針はどの自然言語にも当てはまる。

## 例 1

英語の技術文書を日本語に翻訳する例。原文の "mighty names" はユーモアを含む表現なので、指針の例外として原文の意図を保つように「最強の名前」と訳している。

入力 (翻訳元):

```
# What is in the standard library documentation?

First of all, The Rust Standard Library is divided into a number of focused modules, all listed further down this page. These modules are the bedrock upon which all of Rust is forged, and they have mighty names like `std::slice` and `std::cmp`. Modules' documentation typically includes an overview of the module along with examples, and are a smart place to start familiarizing yourself with the library.

Second, implicit methods on primitive types are documented here. This can be a source of confusion for two reasons:

1. While primitives are implemented by the compiler, the standard library implements methods directly on the primitive types (and it is the only library that does so), which are documented in the section on primitives.
2. The standard library exports many modules *with the same name as primitive types*. These define additional items related to the primitive type, but not the all-important methods.

So for example there is a page for the primitive type `char` that lists all the methods that can be called on characters (very useful), and there is a page for the module `std::char` that documents iterator and error types created by these methods (rarely useful).

Note the documentation for the primitives `str` and `[T]` (also called 'slice'). Many method calls on `String` and `Vec<T>` are actually calls to methods on `str` and `[T]` respectively, via deref coercions.

Third, the standard library defines The Rust Prelude, a small collection of items - mostly traits - that are imported into every module of every crate. The traits in the prelude are pervasive, making the prelude documentation a good entry point to learning about the library.

And finally, the standard library exports a number of standard macros, and lists them on this page (technically, not all of the standard macros are defined by the standard library - some are defined by the compiler - but they are documented here the same). Like the prelude, the standard macros are imported by default into all crates.
```

期待される出力 (和訳):

```
# 標準ライブラリのドキュメントの内容

まず初めに、Rust の標準ライブラリは目的ごとに分けられた多くのモジュールで構成されています。このページのもっと下の方にそれらの一覧があります。それらのモジュールは Rust の全てを築き上げるための礎なので、`std::slice` や `std::cmp` などといった最強の名前が付けられています。モジュールのドキュメントには通常、概要や使用例が書かれており、標準ライブラリを理解し始める第一歩としてふさわしいでしょう。

二つ目に、プリミティブ型に暗黙的に備わっているメソッドの説明もここに記載されています。とはいえ、これについては次の二つの理由から混乱しやすいので注意してください。

1. プリミティブ型はコンパイラーによって実装されていますが、標準ライブラリはプリミティブ型に対して直接メソッドを実装しています（そんなことを行えるのは標準ライブラリだけです）。それらのメソッドはプリミティブ型の節に記載してあります。
2. 標準ライブラリは*プリミティブ型と同じ名前の*モジュールをいくつも公開しています。これらのモジュールはそのプリミティブ型に関する補完的なアイテムを定義していますが、その型の核心的なメソッドはここにはありません。

例えばプリミティブ型 `char` のページには、文字に対して呼び出せるメソッドがすべて載っています（これはとても役に立ちます）。一方、モジュール `std::char` のページにはこれらのメソッドによって生成されるイテレーター型やエラー型の説明が記載されています（こちらの出番はめったにありません）。

プリミティブ型 `str` と `[T]`（「スライス」とも呼ばれます）のドキュメントにも目を通しておくとよいでしょう。`String` あるいは `Vec<T>` に対してメソッドを呼び出すと、多くの場合は実際には参照外し型強制を通じて `str` ないし `[T]` のメソッドが呼び出されます。

三つ目に、標準ライブラリは Rust プレリュードを定義しています。これは、すべてのクレートのすべてのモジュールに自動的にインポートされる少数のアイテム（その大半はトレイトです）をまとめたものです。プレリュードに含まれるトレイトは広く使われているため、プレリュードのドキュメントは標準ライブラリについて学び始める良い入り口となります。

最後に、標準ライブラリはいくつかの標準マクロを提供しており、それらの一覧もこのページにあります（厳密には、すべての標準マクロが標準ライブラリによって定義されているわけではなく、コンパイラーによって定義されているものもありますが、ドキュメントはここにまとめられています）。プレリュードと同様に、標準マクロもすべてのクレートにデフォルトでインポートされます。
```

## 例 2

技術的な調査結果を新たに文章にまとめる例。

指針を適用しない場合の出力:

```
## 1. POSIX が実際に要求していること

### 1.1 文字列は正規にバイト列である

決定打は XCU 2.5(Parameters):

> "Parameters can contain arbitrary byte sequences, except for the null byte. The shell shall process their values as characters **only when performing operations that are described in this standard in terms of characters**."

つまり「基本はバイト列、文字として扱うのは規格が文字の観点で記述している操作のときだけ」という実装戦略は、規格自身が明文で指示している。同様にバイト列であることが規範的に要求されるもの:

| 対象 | 要求 | 出典 |
| --- | --- | --- |
| パラメータ(変数)値 | NUL を除く任意のバイト列 | XCU 2.5 |
| 環境変数の値 | 「NUL バイトを除く任意のバイト列」 | XBD 8 |
| 環境変数の名前 | `=` のバイト以外は任意。「有効な文字を成さないバイト列も実装は許可してよく、アプリケーションはその存在を許容しなければならない」 | XBD 8 |
| ファイル名 | NUL バイトとスラッシュバイト以外の任意のバイト。「文字列(character string)である必要はない」と明記 | XBD 3.146, 3.254 |
| コマンド置換の出力 | バイト列として処理(末尾の改行「バイト」を除去。NUL を含む場合は unspecified) | XCU 2.6.3 |
| `read` の入力 | 「0 個以上のバイト(有効な文字を成す必要はない)」。バックスラッシュ処理・区切りもバイト単位 | read STDIN |
| フィールド分割 | 「シェルは入力フィールドの任意のバイトを処理する。それらのバイトが有効な文字を成す要求はない」(Issue 8 で明文化) | XCU 2.6.5 |
| `$'...'` の `\xXX`/`\ddd` | 「その値を持つ**バイト**を生成する」— シェル自身が無効バイトを作れる | XCU 2.2.4 |
| echo `\0num` / printf `\ddd`, `%c`, 精度 | すべてバイト単位 | echo, printf |

**結論:UTF-8 限定の `String`/`char` では POSIX を忠実に実装できない**。これは推測ではなく条文レベルの帰結。

### 1.2 文字意味論が必要な箇所は限定列挙できる

1. **字句解析**(XCU 2.3)— 「入力の各文字に順に規則を適用」と文字単位で定義。
2. **`${#var}`** — 「文字数」(XCU 2.6.2)。
3. **パターンマッチング** — `?` は「任意の 1 **文字**」、`[[:alpha:]]` 等は LC_CTYPE、範囲式・等価クラスは LC_COLLATE(XCU 2.14、XBD 9.3.5)。glob 結果のソートも照合順序(全順序でない場合は POSIX ロケールのバイト比較でタイブレーク)。
4. **フィールド分割** — IFS の値を「文字を成すバイト列」単位で区切りとして使う(アルゴリズム自体はバイト駆動)。
5. **printf の `'c`** — 多バイト文字の wchar_t 相当値。
6. **対話的行編集** — vi モードの単語移動(blank/punct クラス)、カーソル桁位置(wcwidth 相当)。
7. 逆に、**変数名・関数名・予約語・演算子・算術式はすべて移植文字集合(portable character set)のみ**で構成され、移植文字集合は「各文字が単一バイトで表現される」ことが保証されている(XBD 6.1)。→ これらはバイト処理で正確。なお POSIX sh に `${var^^}` のようなケース変換はない。
```

望ましい出力:

```
## POSIX が実際に要求していること

### 文字列はバイト列である

POSIX は実装に対して「文字列は基本的にバイト列であり、文字として扱うのは規格が文字の観点で記述している操作のときだけ」という全体方針を明示的に規定している。その決定的な根拠は POSIX.1-2024 XCU 2.5 Parameters and Variables にある。

> "Parameters can contain arbitrary byte sequences, except for the null byte. The shell shall process their values as characters only when performing operations that are described in this standard in terms of characters."

バイト列としての処理が標準として要求されている具体的な箇所は以下の通り。

- パラメーター (変数) の値は NUL バイトを除く任意のバイト列であること (XCU 2.5)。
- 環境変数の値は NUL バイトを除く任意のバイト列であること (XBD 8)。
- 環境変数の名前は `=` のバイト以外は任意であり、「有効な文字を成さないバイト列も実装は許可してよく、アプリケーションはその存在を許容しなければならない」とされている (XBD 8)。
- ファイル名は NUL バイトとスラッシュバイト以外の任意のバイト列であり、「文字列 (character string) である必要はない」と明記されている (XBD 3.146, 3.254)。
- コマンド置換の出力はバイト列として処理される。末尾の改行「バイト」を除去する必要がある。NUL を含む場合の動作は未規定である (XCU 2.6.3)。
- `read` ユーティリティの入力は「0 個以上のバイト (有効な文字を成す必要はない)」とされ、バックスラッシュ処理や区切りもバイト単位で行われる (XCU 3. read STDIN)。
- フィールド分割では、「シェルは入力されたフィールドに含まれる任意のバイトを処理する。それらのバイトが有効な文字を成さなければならないという要求はない」とされている (XCU 2.6.5)。
- Dollar-Single-Quotes (`$'...'`) の中に現れる `\xXX` や `\ddd` は「その値を持つバイトを生成する」とされており、シェル自身が無効なバイトを作ることができる (XCU 2.2.4)。
- `echo` ユーティリティの `\0num` エスケープはバイト単位で処理される (XCU 3. echo)。
- `printf` ユーティリティの `\ddd` エスケープ・`%c` 変換子・精度指定子はすべてバイト単位で処理される (XCU 3. printf)。

以上の理由により、UTF-8 に限定された Rust の `String` や `char` では、POSIX を忠実に実装することはできない。

### 文字の扱いが要求される箇所

入力を文字として扱うことが求められる箇所は限定的である。具体的には以下の通り。

- 字句解析は「入力の各文字に順に規則を適用する」と文字単位で定義されている (XCU 2.3)。
- `${#var}` 形式のパラメーター展開は「文字数」を返す (XCU 2.6.2)。
- パターンマッチングでも文字が使用される。`?` は「任意の 1 文字」を表す。`[[:alpha:]]` などは LC_CTYPE に依存し、範囲式や等価クラスは LC_COLLATE に依存する (XCU 2.14, XBD 9.3.5)。
- glob の結果のソート順も照合順序に依存する (全順序でない場合は POSIX ロケールでのバイト単位比較で順序を決着させる)。
- フィールド分割では、IFS の値を「文字を成すバイト列」の単位で区切りとして使う (ただし分割アルゴリズム全体はバイト基準で定義される)。
- printf の `'c` フォーマット指定子は、多バイト文字の wchar_t 相当値を扱う。
- 対話的行編集では、vi モードで単語単位の移動のために文字の分類 (blank/punct クラス) が使用される。またカーソルの桁位置の算定も文字単位である (wcwidth 相当)。
- 逆に、変数名・関数名・予約語・演算子・算術式はすべて可搬文字集合 (portable character set) のみで構成される。可搬文字集合では「各文字が単一バイトで表現される」ことが保証されている (XBD 6.1)。したがって、これらの要素はバイト単位で正確に扱うことができる。なお、POSIX sh には `${var^^}` のようなケース変換機能はない。
```

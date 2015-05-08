<head>
 <meta http-equiv="content-type" content="application/xhtml+xml; charset=utf-8">
 <meta http-equiv="content-style-type" content="text/css">
 <meta http-equiv="Content-Script-Type" content="text/javascript">

<title>
フォーム定義を動的に変更する - Ethna - PHPウェブアプリケーションフレームワーク</title>
 <link rel="stylesheet" href="skin/ethna/ethna.css" title="ethna" type="text/css" charset="utf-8">

 <link rel="alternate" type="application/rss+xml" title="RSS" href="cmd=rss.html">

 <script type="text/javascript" src="skin/trackback.js"></script>

</head>
ここは以前の ethna.jp サイトを表示したものです。ここにあるドキュメントはバージョン2.6以降更新されません。  
最新のドキュメントは [現在のethna.jp](http://ethna.jp/) を閲覧してください。現ドキュメントが整備されるまでは、ここを閲覧してください。

<!-- ??BEGIN id:wrapper --><!-- ?? Navigator ?? ======================================================= -->

[![Ethna](image/navlogo.gif)](/)

[トップ](ethna.html "ethna (11d)") [二ュース](ethna-news.html "ethna-news (11d)") [概要](ethna-about.html "ethna-about (11d)") [ダウンロード](ethna-download.html "ethna-download (25d)") [ドキュメント](ethna-document.html "ethna-document (884d)") [コミュニティ](ethna-community.html "ethna-community (619d)") [FAQ](ethna-document-faq.html "ethna-document-faq (1240d)")

<!-- ?? Header ?? ========================================================== -->

# フォーム定義を動的に変更する 

<!-- ?? Content ?? ========================================================= -->
<!-- ??BEGIN id:main -->
<!-- ??BEGIN id:wrap_content -->
<!-- ??BEGIN id:content -->
<!-- ??BEGIN id:page_navigator -->
<!-- ??END id:PageNavigator -->
<!-- ??BEGIN id:body --> [Ethna](index.html) > [ドキュメント](ethna-document.html) > [開発マニュアル](ethna-document-dev_guide.html) > [ethna-document-dev\_guide-app](ethna-document-dev_guide-app.html) > フォーム定義を動的に変更する 
## フォーム定義を動的に変更する [](ethna-document-dev_guide-app-dynamicform.html#ec43e041 "ec43e041")

Ethna でのアクションフォームの定義は、以下のように固定の配列として定義します。つまり、クラスのメンバとして宣言するため、PHP では関数コールや変数の形でフォーム定義を動的に定義することはできません。これは PHP の言語仕様上の制限です\*1

ここでは、そうした制限を越えて、フォーム定義をsubmit後に変更する方法を示します。

    $form = array(
           'sample' => array( // 正しいフォーム定義
               'type' => VAR_TYPE_INT,
               'name' => 'sample',
               // ...
           ),
           'invalid' => array( // 間違ったフォーム定義
               'type' => $dynamic_type, // 変数は駄目
               'name' => _('invalid'), // gettext 等、動的な呼び出しは×
               // ...
           ),

- フォーム定義を動的に変更する 
  - フォーム定義を動的にしなければならない理由 
  - Ethna 2.5.0 以降でのやり方 
    - フォーム定義変更専用のヘルパメソッド 
    - フォームヘルパが絡んだ場合 
  - Ethna 2.3.5 以前のやり方 
    - どこに書くか？ 
    - フォーム定義の設定 
    - submitされた値を設定しなおす 
    - 全体のサンプルコード 
    - (参考)ActionFormのform定義を直接変更する方法 

| 書いた人 | key | ---------- | 新規作成 |
| 書いた人 | mumumu | 2009-01-28 | 最新版に追随する形で全面的に修正 |
| 書いた人 | mumumu | 2009-06-03 | フォームヘルパが絡んだ場合の記述を追加 |
| 書いた人 | DQNEO | 2010-11-11 | ActionFormのform定義を直接変更する方法を追加 |

### フォーム定義を動的にしなければならない理由 [](ethna-document-dev_guide-app-dynamicform.html#g69ae8c7 "g69ae8c7")

動的にフォーム定義を Ajax 等で動的にブラウザ側のインターフェイスを変更するようになった今にあっては、submitされた値、または データベースやセッションの値に応じて、フォーム定義を変更したいとの要求は自然に出てくるでしょう。

ひとつの例として、SELECT ボックスを複数段展開させなければいけない場合をあげてみます。都道府県を選んだ後に、市町村のSELECTボックスの値を変えなければならなくなったら、固定のフォーム定義ではうまくいかないでしょう

    都道府県: <select name="prefecture">
                <option value="1">北海道</option>
                ...
              </select>
    市町村: <select name="city">
                <option value="1">北海道なら札幌</option>
                <option value="2">神奈川なら横浜</option>
                ...
              </select>

### Ethna 2.5.0 以降でのやり方 [](ethna-document-dev_guide-app-dynamicform.html#t9f82a56 "t9f82a56")

Ethna 2.5.0 以降では、フォーム定義を動的に変更するための場所を統一するためのAPIが整備されました。フォーム定義はアクションフォームに関することなので、Ethna\_ActionForm クラスのメソッドで統一するのがスマートです。

よって、以下のようなAPI が定義されています。

#### フォーム定義変更専用のヘルパメソッド [](ethna-document-dev_guide-app-dynamicform.html#j5cff07b "j5cff07b")

Ethna 2.5.0 以降では、Ethna\_ActionForm#setFormDef\_PreHelper を使います。このメソッドを呼び出す前に、Ethna\_Session, Ethna\_Backend などがすべて初期化されるため、データベースやセッションの値に基づいてフォーム定義を設定することが可能です。

また、このメソッドが呼び出されたあと、Ethna\_ActionForm#setFormVars が呼び出されるため、上記で設定したフォーム定義に基づいて submit した値が自動設定されます。

    /**
      * フォーム定義変更用、ユーザ定義ヘルパメソッド
      *
      * Ethna_ActionForm#prepare() が実行される前に
      * ユーザが動的にフォーム定義を変更したい場合に
      * このメソッドをオーバーライドします。
      *
      * $this->backend も初期化済みのため、DBやセッション
      * の値に基づいてフォーム定義を変更することができます。
      *
      * @access public
      */
    function setFormDef_PreHelper()
    {
        // セッションや DBのオブジェクトを以下のようにして利用可能   
        $session = $this->backend->getSession();
        $db = $this->backend->getDB();
    
        // フォーム名とフォーム定義の設定
        $name = "question_1";
        $def = array (
                  'name' => $name . "の答え", // 動的なフォーム定義
                  'required' => true,
                  'form_type' => FORM_TYPE_TEXT,
                  'type' => VAR_TYPE_STRING,
                  'filter' => null,
              );
        $this->setDef($name, $def);
        
        // このメソッド呼び出しのあと、Ethna_ActionForm#setFormVars
        // が呼び出され、上記で追加した question_1 の値も
        // 自動で設定される。
    }

#### フォームヘルパが絡んだ場合 [](ethna-document-dev_guide-app-dynamicform.html#xa9c35f1 "xa9c35f1")

フォームヘルパについては、 [フォームヘルパ](ethna-document-dev_guide-view-form_helper.html "ethna-document-dev\_guide-view-form\_helper (998d)") の説明も参照してください。

少し高度な話題ですが、フォームヘルパは、Ethna\_ViewClass で現在のフォームとは別に、以下のように ethna\_action で指定されたアクションフォームを初期化します。それは、Submit されたときに初期化されたアクションフォームとは別のため、動的に値を設定したい場合は別のAPI が必要になります。

    {form ethna_action="formhelper"}
      {* [appid]Form_Formhelper というアクションフォームが初期化される *} 
    {/form}

フォームヘルパで利用するフォーム定義を動的に変更したい場合は、以下の特別なメソッドを使います。使い方は [フォーム定義変更専用のヘルパメソッド](ethna-document-dev_guide-app-dynamicform.html#j5cff07b) で説明した setFormDef\_PreHelper() と全く同じです。

    /**
      * フォーム定義変更用、ユーザ定義ヘルパメソッド
      *
      * フォームヘルパを使うときに、フォーム定義を動的に
      * 変更したい場合に、このメソッドをオーバライドします。
      *  
      * このメソッドは、以下の定義をテンプレートで行った場
      * 合に呼び出されます。
      *
      * {form ethna_action=...} (ethna_action がない場合は呼び出されません)
      * {form_input action=...} (action がない場合は呼び出されません)
      *
      * @access public
      */
    function setFormDef_ViewHelper()
    {
        // TODO: デフォルト実装は Ethna_ActionClass#prepare の直前
        // に呼び出されるものと同じ。異なる場合にオーバライドする
        $this->setFormDef_PreHelper();
    }

### Ethna 2.3.5 以前のやり方 [](ethna-document-dev_guide-app-dynamicform.html#pe0e10dd "pe0e10dd")

#### どこに書くか？ [](ethna-document-dev_guide-app-dynamicform.html#n1b84d66 "n1b84d66")

動的な定義も含めてActionFormの中で完結させたいところですが、ActionForm 内にはロジックが書けないため、データベースのインスタンスを拾うなどしてフォーム定義を動的に変更することができません。

Ethna\_ActionClass#prepare もしくは Ethna\_ActionClass#perform に処理を記述すればよいですが、フォーム値の自動検証を Ethna\_ActionClass#prepare で行うのが一般的であることを考えると、前処理を行う prepareに処理を書いたほうがスマートです。

#### フォーム定義の設定 [](ethna-document-dev_guide-app-dynamicform.html#l09cc691 "l09cc691")

まず、フォーム名とその定義がどのようなものになるかを決めます。以下の例では、フォーム定義 $def に "$name の答え" という動的な値を定義しています。

    // フォーム名とフォーム定義の設定
        $name = "question_1";
        $def = array (
                  'name' => $name . "の答え", // 動的なフォーム定義
                  'required' => true,
                  'form_type' => FORM_TYPE_TEXT,
                  'type' => VAR_TYPE_STRING
                  'filter' => null,
              );

しかしActionFormのインスタンスにこの定義を設定しない限り、このフォーム定義は使用できません。

よって以下のようにして、Ethna\_ActionForm#setDef メソッドを呼び出してフォーム定義を設定します。  
複数のフォーム定義を処理するには、この処理をループさせればよいでしょう。

    // フォーム定義をセットする
        $this->af->setDef($name, $def);

#### submitされた値を設定しなおす [](ethna-document-dev_guide-app-dynamicform.html#b73f36af "b73f36af")

Ethna\_ActionForm#setDef を呼び出しただけでは、アクションフォーム内のフォーム定義が変更されただけで、submit された値がアクションフォームに設定されたわけではありません。

よって、以下のようにして $\_POST や $\_GET 等の値をアクションフォームのインスタンスに再設定してやります。

    // submit された $_POST 等の値をアクションフォーム
        // に設定しなおす
        $this->af->setFormVars();

こうすれば、新しいフォーム定義に基づいて検証を行うことができます。

    // 新しいフォーム定義に基づいてフォーム値を検証
        if ($this->af->validate() > 0) {
            return 'index';
        }

#### 全体のサンプルコード [](ethna-document-dev_guide-app-dynamicform.html#t061dd74 "t061dd74")

上記の説明で使ったサンプルコードの全容をまとめると、以下のようになります (左側は行番号です)

    1: function prepare() {
    2:
    3: // フォーム名とフォーム定義の設定
    4: $name = "question_1";
    5: $def = array (
    6: 'name' => $name . "の答え", // 動的なフォーム定義
    7: 'required' => true,
    8: 'form_type' => FORM_TYPE_TEXT,
    9: 'type' => VAR_TYPE_STRING
    10: 'filter' => null,
    11: );
    12:
    13: // フォーム定義をセットする
    14: $this->af->setDef($name, $def);
    15:
    16: // submit された $_POST 等の値をアクションフォーム
    17: // に設定しなおす
    18: $this->af->setFormVars();
    19:    
    20: // 新しいフォーム定義に基づいてフォーム値を検証
    21: if ($this->af->validate() > 0) {
    22: return 'index';
    23: }
    24:}

#### (参考)ActionFormのform定義を直接変更する方法 [](ethna-document-dev_guide-app-dynamicform.html#s5c75bc7 "s5c75bc7")

別のやり方として、prepare内で、$this->af->formを直接変更するやり方もあります。

[http://ethna.jp/ethna-document-faq-dev\_guide\_faq.html#jee57430](ethna-document-faq-dev_guide_faq.html#jee57430)

<!-- ??END id:body -->
<!-- ??BEGIN id:summary --><!-- ??BEGIN id:note -->

* * *
\*1(クラスのメンバ変数が固定でなければならない根拠としては、PHP4では、 [http://jp.php.net/manual/ja/keyword.class.php](http://jp.php.net/manual/ja/keyword.class.php) が、PHP5 では、 [http://jp.php.net/manual/ja/language.oop5.basic.php](http://jp.php.net/manual/ja/language.oop5.basic.php) があります。  

<!-- ??END id:note -->
<!-- ??BEGIN id:trackback -->
<!-- ?? END id:trackback --><!-- ?? END id:attach -->
<!-- ?? END id:summary -->
<!-- ??END id:content -->
<!-- ?? END id:wrap_content --><!-- ??sidebar?? ========================================================== -->
<!-- ??BEGIN id:wrap_sidebar -->

<!-- ??BEGIN id:search_form -->

## 検索

<form action="http://ethna.jp/index.php?cmd=search" method="post">
            <input type="hidden" name="encode_hint" value="??">
            <input type="text" name="word" value="" size="20">
            <input type="submit" value="検索"><br>
            <input type="radio" name="type" value="AND" checked id="and_search"><label for="and_search">AND検索</label>
            <input type="radio" name="type" value="OR" id="or_search"><label for="or_search">OR検索</label>
    </form>

<!-- END id:search_form -->
<!-- ??BEGIN id:download_link -->

## ダウンロード

[![](image/minilogo.gif)Ethna-2.6.0(beta2)](ethna-download.html)

[![](image/minilogo.gif)Ethna-2.5.0(stable)](ethna-download.html)

<!-- END id:download_link -->
<!-- ??BEGIN id:download_link -->

## Quick Links

- [フォーラム(質問/要望等)](ethna-community-forum.html)
- [メーリングリスト](http://ml.ethna.jp/mailman/listinfo/users)

- [チュートリアル](ethna-document-tutorial.html)
- [開発マニュアル](ethna-document-dev_guide.html)
- [変更点一覧](ethna-document-changes.html)

- [TODO(ロードマップ)](TODO.html)
- [ロゴ](ethna-logo.html)

<!-- END id:download_link -->
<!-- ??BEGIN id:search_form -->

## Powered by GREE

 [![GREE Labs](http://labs.gree.jp/image/greelabs_logo.gif)](http://labs.gree.jp/)

<!-- END id:search_form -->
 [![SourceForge.jp](http://sourceforge.jp/sflogo.php?group_id=1343)](http://sourceforge.jp/)

<!-- ??END id:sidebar -->
<!-- ??END id:wrap_sidebar -->
<!-- ??END id:main --><!-- ?? Footer ?? ========================================================== -->
<!-- ??BEGIN id:footer -->
<!-- ??BEGIN id:copyright --> **PukiWiki 1.4.6** Copyright © 2001-2005 [PukiWiki Developers Team](http://pukiwiki.sourceforge.jp/). License is [GPL](http://www.gnu.org/licenses/gpl.html).  
 Based on "PukiWiki" 1.3 by [yu-ji](http://factage.com/yu-ji/).
<!-- ??END id:copyright -->
<!-- ??END id:footer --><!-- ?? END ?? ============================================================= -->
<!-- ??END id:wrapper -->

<head>
 <meta http-equiv="content-type" content="application/xhtml+xml; charset=utf-8">
 <meta http-equiv="content-style-type" content="text/css">
 <meta http-equiv="Content-Script-Type" content="text/javascript">

<title>
Smartyプラグインの作成 - Ethna - PHPウェブアプリケーションフレームワーク</title>
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

# Smartyプラグインの作成 

<!-- ?? Content ?? ========================================================= -->
<!-- ??BEGIN id:main -->
<!-- ??BEGIN id:wrap_content -->
<!-- ??BEGIN id:content -->
<!-- ??BEGIN id:page_navigator -->
<!-- ??END id:PageNavigator -->
<!-- ??BEGIN id:body -->
## Smartyプラグインの作成 [](ethna-document-dev-guide-make-smartyplugin.html#o338a399 "o338a399")

ここでは、Ethna 向けの Smarty プラグインの作成方法を説明します。

- Smartyプラグインの作成 
  - Smartyプラグインの種別 
  - Ethna 2.5.0 以降のやり方 
    - プラグインの作成 
    - プラグインの登録と使い方 
  - Ethna 2.3.x 以前のやり方 
    - クラスのメソッドをSmartyFunctionとして登録する方法 
    - smartyの流儀でfunction, modifierなどを登録する 

| 書いた人 | mumumu | 2009-06-21 | 新規作成 |

### Smartyプラグインの種別 [](ethna-document-dev-guide-make-smartyplugin.html#td2adc00 "td2adc00")

Smarty のプラグインには様々な種類がありますが、原理的にEthnaでは全ての種類のSmartyプラグインを使うことができます。

主に使われるのはブロックプラグイン、関数プラグイン、修正子プラグインの3種類でしょう。

### Ethna 2.5.0 以降のやり方 [](ethna-document-dev-guide-make-smartyplugin.html#vd16f435 "vd16f435")

#### プラグインの作成 [](ethna-document-dev-guide-make-smartyplugin.html#e3340a25 "e3340a25")

すべての種類の Smartyプラグインが Ethna で利用可能です。

Smartyプラグインの作成方法については、 [Smarty のマニュアル](http://www.smarty.net/manual/ja/plugins.php) をご覧下さい。

#### プラグインの登録と使い方 [](ethna-document-dev-guide-make-smartyplugin.html#i41b8e45 "i41b8e45")

app/Plugin/Smarty 以下に作成したプラグインを置いておけば、自動で Smartyプラグインの探索パスを通してあるため、ここに置いたプラグインは自動でEthnaが探してくれるようになっています。

よって、hoge プラグインを例にすると、以下のようにしてすぐに使うことができます。

    {$app.test|hoge}
    {hoge}
    {hoge}{/hoge}

### Ethna 2.3.x 以前のやり方 [](ethna-document-dev-guide-make-smartyplugin.html#s8d7cfd4 "s8d7cfd4")

#### クラスのメソッドをSmartyFunctionとして登録する方法 [](ethna-document-dev-guide-make-smartyplugin.html#u3120897 "u3120897")

以下のように配列で指定することでクラスのメソッドをsmarty\_functionとして登録することが可能です。

    179 /**
       180 * @var array smarty function定義
       181 */
       182 var $smarty_function_plugin = array(
       183 /*
       184 * TODO: ここにユーザ定義のsmarty function一覧を記述してください
       185 *
       186 * 記述例：
       187 *
       188 * 'smarty_function_foo_bar',
       189 */
       190 array('HasteSmartyPlugins', 'form_name'),
       191 array('HasteSmartyPlugins', 'form_input'),
       192 array('HasteSmartyPlugins', 'rss'),

従来はグローバルの関数名を書いた文字列を列挙するが、クラスのメソッドの場合、

    array('クラス名', 'メソッド')

とした配列を列挙する。\*1

#### smartyの流儀でfunction, modifierなどを登録する [](ethna-document-dev-guide-make-smartyplugin.html#g54e5005 "g54e5005")

smartyは特定のディレクトリにsmartyの流儀でファイルを作れば自動的にmodifierなどを見付けてくれます。上の方法は、smartyの流儀によらずにアプリで用意したクラス関数をsmarty functionに登録するための方法です。

smartyの流儀に従う場合は、App\_Controllerの中でファイルを置くディレクトリを指定します。たとえばアプリのlibディレクトリにsmartyディレクトリを用意する場合は、以下のように指定してください。

- lib/smarty/function.sample.php (smarty functionを定義したファイル)

    function smarty_function_sample($params, &$smarty)
    {
        ...
    }

- app/App\_Controller.php

    var $directory = array(
        ...
        'plugins' => array('lib/smarty'), // ファイルを置いてあるディレクトリ
        ...
    );

smartyテンプレート内で {sample foo=bar} のように書くと、smartyはlib/smartyディレクトリ内から自動的にsample関数の定義を見付けてくれます。(くわしくはSmarty自体のドキュメントを参照してください)

**注意** : この場合、$smarty\_function\_pluginのほうは指定 **しない** でください。指定すると、smartyはファイルを探さなくてもどこかに関数が定義されていると思い、「関数が見付からない」といったエラーを出すかもしれません。

<!-- ??END id:body -->
<!-- ??BEGIN id:summary --><!-- ??BEGIN id:note -->

* * *
\*1このあたりはsmartyのregister\_functionメソッドのマニュアルを参照  

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

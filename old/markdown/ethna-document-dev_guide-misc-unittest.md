<head>
 <meta http-equiv="content-type" content="application/xhtml+xml; charset=utf-8">
 <meta http-equiv="content-style-type" content="text/css">
 <meta http-equiv="Content-Script-Type" content="text/javascript">

<title>
ユニットテストを行う - Ethna - PHPウェブアプリケーションフレームワーク</title>
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

# ユニットテストを行う 

<!-- ?? Content ?? ========================================================= -->
<!-- ??BEGIN id:main -->
<!-- ??BEGIN id:wrap_content -->
<!-- ??BEGIN id:content -->
<!-- ??BEGIN id:page_navigator -->
<!-- ??END id:PageNavigator -->
<!-- ??BEGIN id:body --> [Ethna](index.html) > [ドキュメント](ethna-document.html) > [開発マニュアル](ethna-document-dev_guide.html) > [その他](ethna-document-dev_guide-misc.html) > ユニットテストを行う 

- ユニットテストを行う 
- 概要 
- テスト実行環境の作成 
  - SimpleTestのインストール 
    - PEARコマンドを使ってインストールする 
    - 直接ダウンロードしてインストールする 
  - debugフラグの設定(必須！） 
- テストケースの作成 
  - テストケースのスケルトンを生成する。 
  - テストケースの記述 
  - Ethna 2.3.5以前の、アクション・ビュー以外のテストケースの書き方 
  - Ethna\_UnitTestCase特有のメソッド 
- テスト結果表示 

## ユニットテストを行う [](ethna-document-dev_guide-misc-unittest.html#i6490c0a "i6490c0a")

* * *

| 書いた人 | sfio | | |
| 書いた人 | cockok | 2007-07-06 | テストケースの書き方追記 |
| 書いた人 | mumumu | 2008-05-07 | 2.3.x系の情報に追随 |

* * *

## 概要 [](ethna-document-dev_guide-misc-unittest.html#s989701c "s989701c")

[SimpleTest](http://simpletest.org) を使った Ethna でのユニットテストの方法です。  
Simpletest は、様々なユニットテストの実行、レポートの出力形式に対応したPHP向けのテスティングフレームワークです。

## テスト実行環境の作成 [](ethna-document-dev_guide-misc-unittest.html#rb29fb5e "rb29fb5e")

### SimpleTestのインストール [](ethna-document-dev_guide-misc-unittest.html#r84dd296 "r84dd296")

まずはSimpletestをインストールする必要があります。インストールには以下の二つの方法があります。

#### PEARコマンドを使ってインストールする [](ethna-document-dev_guide-misc-unittest.html#hceeb868 "hceeb868")

    # pear channel-discover pear.ethna.jp
    # pear update-channels
    # pear install ethna/simpletest

#### 直接ダウンロードしてインストールする [](ethna-document-dev_guide-misc-unittest.html#o93ba3c2 "o93ba3c2")

- [http://sourceforge.net/projects/simpletest](http://sourceforge.net/projects/simpletest)

### debugフラグの設定(必須！） [](ethna-document-dev_guide-misc-unittest.html#ha8e8dc0 "ha8e8dc0")

設定ファイル（etc/{app\_id}-ini.php)のdebugフラグをtrueに設定します。

    $config = array(
    
        // debug
        // (to enable ethna_info and ethna_unittest, turn this true)
    - 'debug' => false,
    + 'debug' => true,
    
    );

仮に trueに設定していないと、以下のようなメッセージが出てテストケースの実行に失敗します。(Ethna 2.3.5 以上\*1)

    Ethna cannot run Unit Test under your application setting.
    HINT: You must set {appid}/etc/{appid}-ini.php debug setting 'true'.
    
    In {appid}-ini.php, please set as follows :
    
    $config = array ( 'debug' => true, );

## テストケースの作成 [](ethna-document-dev_guide-misc-unittest.html#w3416fa4 "w3416fa4")

### テストケースのスケルトンを生成する。 [](ethna-document-dev_guide-misc-unittest.html#f3b097ad "f3b097ad")

ethnaコマンドを実行し、テストケースのスケルトンを生成します。 生成されたクラスにテストを記述していきます。

- アクション&フォーム用のテストケースのスケルトン作成\*2

    $ ethna add-action-test [アクション名]

- 以下のアクションテストスケルトンが生成されます。
  - app/action/[アクション名]Test.php
  - （クラス名は {appid}\_Action\_[アクション名]\_TestCase)

- ビュー用のテストケースのスケルトン作成

    $ ethna add-view-test [ビュー名]

- 以下のビューテストスケルトンが生成されます。  

  - app/view/[ビュー名]Test.php
  - （クラス名は {appid}\_View\_[ビュー名]\_TestCase)

- アクション・ビュー「以外」の一般的なテストケースのスケルトン作成(2.3.5以降)  
AppObjectやAppManager、その他のテスト用途に使います。

    $ ethna add-test [テストケース名]

- 以下のテストスケルトンが生成されます。  

  - app/test/[テストケースー名]Test.php
  - （クラス名は {appid}\_[テストケース名]\_TestCase)
  - {appid}\_UnitTestManagerへのテストケースの追加をする必要はありません。

### テストケースの記述 [](ethna-document-dev_guide-misc-unittest.html#j4277083 "j4277083")

上記で生成されたテストケースのクラス中に、「test」から始まるメソッドとテストを追加していきます。ethnaコマンドで生成されるクラスは [UnitTestCase](http://simpletest.org/api/SimpleTest/UnitTester/UnitTestCase.html) を継承した Ethna\_UnitTestCase を継承していますので、 [UnitTestCase](http://simpletest.org/api/SimpleTest/UnitTester/UnitTestCase.html)のメソッドを $this 経由で呼び出すことが出来ます。

    function test_actionSample()
    {
        $this->assertTrue(true);
    }

simpletest でのテストケースの書き方の詳細は、以下を参照して下さい。

- WEB+DB PRESS Vol.29
- [http://bobchin.ddo.jp/simpletest](http://bobchin.ddo.jp/simpletest)
- [http://simpletest.org/en/first\_test\_tutorial.html](http://simpletest.org/en/first_test_tutorial.html)
- [http://simpletest.org/api/](http://simpletest.org/api/)

### Ethna 2.3.5以前の、アクション・ビュー以外のテストケースの書き方 [](ethna-document-dev_guide-misc-unittest.html#pfd70e14 "pfd70e14")

2.3.5 以前で、AppObjectやAppManagerのテストケースを作成する場合は、以下のようにします。

- app/ 以下に適当なテストスクリプトを作成します。  
テストは Ethna\_UnitTestCase を継承したクラス内に記述します。

例：app/{appid}\_UserManagerTest.php

    class {appid}_UserManager_TestCase extends Ethna_UnitTestCase
    {
         ....
    }

- UnitTestManagerへのテストケースの追加  
{appid}\_UnitTestManager.php に追加したテストケースの定義を追加します\*3

    var $testcase = array(
            '{appid}_UserManager' => 'app/{appid}_UserManagerTest.php',
        );

### Ethna\_UnitTestCase特有のメソッド [](ethna-document-dev_guide-misc-unittest.html#ec11f48a "ec11f48a")

テストケースの中で、アクションフォームやアクション、ビューのインスタンスを独自に必要とすることがあります。以下のメソッドはそうした用途に使います。

- createActionClass() アクションの作成

- createActionForm() アクションフォームの作成

- createPlainActionForm() 単純なアクションフォームの作成

- createViewClass() ビューの作成

## テスト結果表示 [](ethna-document-dev_guide-misc-unittest.html#u0d31ccd "u0d31ccd")

www/unittest.phpをブラウザで表示。ローカルファイルを直接表示してもだめですよ。

<!-- ??END id:body -->
<!-- ??BEGIN id:summary --><!-- ??BEGIN id:note -->

* * *
\*1Ethna 2.3.2以前では、このフラグがtrueになっていないと、 Ethna\_UnitTestCase が 見つからない等と文句を言われます。www/unittest.php をブラウザから見た場合に画面が真っ白になった場合にも、この点を疑ったほうが良いです。  
\*2Ethna-2.1.2以前でadd-action-testすると、app/action\_cli以下にテストケースが出来てしまいます（バグです）。お手数ですがapp/action以下にファイルを移動してくださいm(\_ \_)m  
\*3アクションとビューのテストはethnaコマンドで生成した場合、{appid}\_UnitTestManagerへのテストケースの追加をする必要はありません。  

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

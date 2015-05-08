<head>
 <meta http-equiv="content-type" content="application/xhtml+xml; charset=utf-8">
 <meta http-equiv="content-style-type" content="text/css">
 <meta http-equiv="Content-Script-Type" content="text/javascript">

<title>
アプリケーションマネージャの使い方 - Ethna - PHPウェブアプリケーションフレームワーク</title>
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

# アプリケーションマネージャの使い方 

<!-- ?? Content ?? ========================================================= -->
<!-- ??BEGIN id:main -->
<!-- ??BEGIN id:wrap_content -->
<!-- ??BEGIN id:content -->
<!-- ??BEGIN id:page_navigator -->
<!-- ??END id:PageNavigator -->
<!-- ??BEGIN id:body --> [Ethna](index.html) > [ドキュメント](ethna-document.html) > [開発マニュアル](ethna-document-dev_guide.html) > [アプリケーションオブジェクト](ethna-document-dev_guide-appobj.html) > アプリケーションマネージャの使い方 
## アプリケーションマネージャの使い方 [](ethna-document-dev_guide-appobj-manager.html#m07f7286 "m07f7286")

アクションクラスに多くのロジックを書いていくと、それなりの規模のWebアプリケーションでは必ず共通の業務ロジックというのが出てきます。そうした共通のロジックをアクションクラスから分離するにはどうしたらいいでしょうか？

ここではその答えとして、アプリケーションマネージャーを紹介します。

- アプリケーションマネージャの使い方 
  - はじめに 
  - アプリケーションマネージャ の作成 
  - 共通のロジックを記述する 
  - 作成したメソッドを呼び出す 
    - Ethna 2.3.0 preview2 以降の場合 
    - Ethna 2.3.0 preview1 以前の場合 
    - アプリケーションマネージャの登録、呼び出し方法を変更した理由 
  - アプリケーションマネージャの命名規約を変更する 
  - アプリケーションオブジェクトとの連携 

| 書いた人 | 日付 | 備考 |
| halt | 2006-01-06 | 新規作成 |
| cocoiti | 2006-01-06 | ちょろっとつけたし |
| halt | 2006-06-14 | ethnaコマンドでの自動生成に変更 |
| halt | 2006-11-01 | Ethna 2.3.0 Preview2以降の挙動の変更について追記 |
| mumumu | 2009-03-04 | 中身を詳細にして書き直し |

### はじめに [](ethna-document-dev_guide-appobj-manager.html#fcaa475f "fcaa475f")

ここでは、以下のコマンドで sample プロジェクトと sample アクションを作ったものとして説明します。

    $ ethna add-project sample
    $ ethna add-action sample

### アプリケーションマネージャ の作成 [](ethna-document-dev_guide-appobj-manager.html#l19c7ea7 "l19c7ea7")

まず最初にAppManagerを作成します。例として、アプリケーションマネージャー名を 「hoge」としてみましょう。以下のように実行することで、app/Sample\_HogeManager.php が自動生成されます。 中身は以下のようになるでしょう。

    $ ethna add-app-manager hoge

と実行することで

    <?php
    /**
     * Sample_HogeManager.php
     *
     * @author {$author}
     * @package Sample
     * @version $Id: skel.app_manager.php 488 2007-12-13 22:11:18Z mumumu-org $
     */
    
    /**
     * Sample_HogeManager
     *
     * @author {$author}
     * @access public
     * @package Sample
     */
    class Sample_HogeManager extends Ethna_AppManager
    {
    }
    ?>

### 共通のロジックを記述する [](ethna-document-dev_guide-appobj-manager.html#d8bade3c "d8bade3c")

上記で生成されたアプリケーションマネージャーは、Ethna\_AppManagerクラスを継承しています。よって、Ethna\_AppManagerで定義されている以下のプロパティをそのまま使うことが出来ます。見てわかるとおり、Ethnaで使う基本的なオブジェクトが全て網羅されているので、アクションフォームから値を取得するコードや、データベースにアクセスするコードなど、どのようなロジックでも記述することができます。

    /** @var object Ethna_Backend backendオブジェクト */
        var $backend;
     
        /** @var object Ethna_Config 設定オブジェクト */
        var $config;
     
        /** @var object Ethna_DB DBオブジェクト */
        var $db;
     
        /** @var object Ethna_I18N i18nオブジェクト */
        var $i18n;
     
        /** @var object Ethna_ActionForm アクションフォームオブジェクト */
        var $action_form;
     
        /** @var object Ethna_ActionForm アクションフォームオブジェクト(省略形) */
        var $af;
     
        /** @var object Ethna_Session セッションオブジェクト */
        var $session;

ここでは、invoke というメソッドを引数無しで定義してみましょう。以下のようになります。

    class Sample_HogeManager extends Ethna_AppManager
    {
         function invoke()
         {
             echo "Hello Sample_HogeManager!";
             
             //
             // 親クラスに定義されたプロパティを使って、
             // どのようなロジックでも記述可能です。
             // 戻り値も勿論自由
             //
             //$this->af->get('hoge');
             //$this->session->get('hoge');
             //$this->af->setApp('hoge', 'fuga');
             //$db = $this->backend->getDB();
    
             return;
         }
    }

### 作成したメソッドを呼び出す [](ethna-document-dev_guide-appobj-manager.html#g5f9502d "g5f9502d")

では、これをアクションクラスから呼び出してみましょう。やり方はバージョンによって異なります。

#### Ethna 2.3.0 preview2 以降の場合 [](ethna-document-dev_guide-appobj-manager.html#s7943a3c "s7943a3c")

Ethna\_Backend クラスのgetManagerメソッドに、作成したマネージャー名を指定することで、アプリケーションマネージャのインスタンスを取得することができます。

取得したインスタンスから、メソッドを呼び出してやるだけです。 以下のように sampleアクションクラスに 追記してみましょう。「Hello Sample\_HogeManager!」が表示されるはずです。

    class Sample_Action_Sample extends Sample_ActionClass
    {
        function perform()
        {
            $hoge = $this->backend->getManager('hoge');
            $hoge->invoke();
            return 'index';
        }
    }

#### Ethna 2.3.0 preview1 以前の場合 [](ethna-document-dev_guide-appobj-manager.html#v35a8312 "v35a8312")

まず、作成したアプリケーションマネージャをコントローラーが呼び出せるように登録する必要があります。

    app/Sample_Controller.php

で、上で作ったクラス(この場合はSample\_HogeManager.php)をrequireし、コントローラーのファイルの中にある、

    var $manager

の配列の中に以下を追加します。

    'Test' => 'hoge',

配列のキーとして指定している Test は、各アクションクラス内で呼び出す時の名称。配列の値として指定している hoge は ethna add-app-managerコマンドで指定したアプリケーションマネージャーの名前です。

このように指定することで、アクションクラスの $this->Test に、Sample\_HogeManager のインスタンスが自動的にロードされます。

早速試してみましょう。sampleアクションクラスのperformメソッドに以下を追記して、実行してみてください。「Hello Sample\_HogeManager!」が表示されるはずです。

    class Sample_Action_Sample extends Sample_ActionClass
    {
        function perform()
        {
            $this->Test->invoke();
            return 'index';
        }
    }

#### アプリケーションマネージャの登録、呼び出し方法を変更した理由 [](ethna-document-dev_guide-appobj-manager.html#y9120283 "y9120283")

既に述べた通り Ethna 2.3.0 preview1 以前では、コントローラーにマネージャーを登録し、自動ロードさせるやり方でした。しかし、数が多くなったときに登録が大変なことと、ロードのコストがかかるという理由から、Ethna 2.3.0 preview2 以降では、明示的に必要なもののみを取得するやり方に変更されています。

各Action毎に毎回手動で呼び出すのが面倒な場合、 app/[APPID]\_ActionClass.php などのベースの関数のコンストラクタの中などで呼び出すようにすると良いでしょう。

### アプリケーションマネージャの命名規約を変更する [](ethna-document-dev_guide-appobj-manager.html#jd29cdea "jd29cdea")

    このセクションの記述は、Ethna 2.5.0 preview3以降に当てはまります

アプリケーションマネージャーのクラス名は、デフォルトでは以下のようになります。

    [アプリケーションID]_[マネージャー名のはじめを大文字にしたもの]Manager

この名前は、Ethna\_Controller#getManagerClassName をオーバライドすることで変更することが出来ます。命名規約が変わったとしても、既に述べた呼び出し方は変化ありません。

    /**
        * マネージャクラス名を取得する
        *
        * @access public
        * @param string $name マネージャキー
        * @return string マネージャクラス名
        */
       function getManagerClassName($name)
       {
           // アプリケーションIDと、渡された名前のはじめを大文字にして、
           // 組み合わせたものが返される
           return sprintf('%s_%sManager', $this->getAppId(), ucfirst($name));
       }

### アプリケーションオブジェクトとの連携 [](ethna-document-dev_guide-appobj-manager.html#kdedf476 "kdedf476")

Ethna には、 [アプリケーションオブジェクト](ethna-document-dev_guide-appobj-overview.html) と呼ばれるORマッピングの機能があります。

アプリケーションマネージャクラスには、アプリケーションオブジェクトを使ってデータベースを検索するメソッドが複数用意されています。それを使ってデータベースを記述するロジックも実行することが出来ます。

詳細は、 [アプリケーションマネージャのAPIドキュメント](doc/Ethna/Ethna_AppManager.html) を御覧下さい。

<!-- ??END id:body -->
<!-- ??BEGIN id:summary --><!-- ??END id:note -->
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

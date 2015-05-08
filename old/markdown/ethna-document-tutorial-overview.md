<head>
 <meta http-equiv="content-type" content="application/xhtml+xml; charset=utf-8">
 <meta http-equiv="content-style-type" content="text/css">
 <meta http-equiv="Content-Script-Type" content="text/javascript">

<title>
動作概要 - Ethna - PHPウェブアプリケーションフレームワーク</title>
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

# 動作概要 

<!-- ?? Content ?? ========================================================= -->
<!-- ??BEGIN id:main -->
<!-- ??BEGIN id:wrap_content -->
<!-- ??BEGIN id:content -->
<!-- ??BEGIN id:page_navigator -->
<!-- ??END id:PageNavigator -->
<!-- ??BEGIN id:body --> [Ethna](index.html) > [ドキュメント](ethna-document.html) > [チュートリアル](ethna-document-tutorial.html) > 動作概要 
## 動作概要 [](ethna-document-tutorial-overview.html#mcac7366 "mcac7366")

Ethnaは(当初) [Struts](http://struts.apache.org/)の構造を模倣して作られました。そのため、基本的な動作はStrutsに類似しています。また代表的なPHPフレームワークの一つである、Mojaviにも良く似ています。

### (1) 非常に大雑把な動作イメージ [](ethna-document-tutorial-overview.html#f85106f4 "f85106f4")

とても大雑把には、Ethnaの動作イメージは以下の図のようになっています。

 ![ethna-fig1.png](http://ethna.jp/image/ethna-fig1.png "ethna-fig1.png")

1. クライアントはControllerクラスにアクセスします
2. Controllerクラスは、クライアントのリクエストに対応する処理が定義されているAction Class(という名前の)オブジェクトを生成し、実行します  
Action Classオブジェクトは処理(例えば、ログインやデータベースの更新等)を実行し、結果をControllerオブジェクトに返します
3. ControllerオブジェクトはAction Classが返した結果に対応するビューオブジェクトを生成します
4. ビューオブジェクトはHTMLをクライアントに対して表示します

つまり、Ethnaを使ってアプリケーションを作る場合は

1. Controllerがどんなリクエスト(例えば「ログインする」とか「日記を表示する」とか)を受け付けるか(= 「アクション」)を定義して
2. 1.で定義したアクションが実際に何をするか、というコードを書いて
3. その結果どんな画面が表示されるか、を書く

という流れになります。よくあるMVC的フレームワークと同様の動きです。

### (2) 多少大雑把な動作イメージ [](ethna-document-tutorial-overview.html#o8973652 "o8973652")

(1)の図はあまりに抽象的ですので、次にもう少しだけ具体的な動作イメージを以下に記述します。

 ![ethna-fig2.png](http://ethna.jp/image/ethna-fig2.png "ethna-fig2.png")

1. クライアントはアプリケーションのエントリポイントとなるスクリプト(index.php)にアクセスします  
2. index.phpは以下のようなスクリプトで、Controllerを生成、実行します

    <?php
    include_once('/path/to/project/app/sample_controller.php');
    Sample_Controller::main('Sample_Controller', 'index');
    ?>

3. ControllerはAction Formというオブジェクトを生成します。このオブジェクトにはクライアントから送信されたフォーム値等のコンテナです
4. Controllerはクライアントから送信されたフォーム値に基づいて実行するアクションを決定し、対応するAction Classを生成、実行します。なお、デフォルトでは"action\_"で始まるフォーム値がある場合に、それ以降の文字列がアクション名となります。つまり  

    index.php?action_login=true

なら  

    login

というアクションになります
5. Action ClassはAction Formを利用して、クライアントから送信されたフォーム値や、ビューに表示する変数値を設定します
6. Action Classは処理が終了すると、遷移先の名前をコントローラに返します
7. ControllerはAction Classからの戻り値(遷移先)に応じてビューオブジェクトを生成します
8. ビューオブジェクトは、Action Formからテンプレートファイルで利用する変数値を取得します
9. ビューオブジェクトがHTMLを表示します

以上で、何となくはイメージを掴めていただけたと思います。その他の細かい点については、実際にアプリケーションを構築しながら把握するほうが早いと思うので、次節 [アプリケーション構築手順(1)](ethna-document-tutorial-practice1.html "ethna-document-tutorial-practice1 (23d)")をご覧下さい。

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

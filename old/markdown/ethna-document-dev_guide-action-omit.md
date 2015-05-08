<head>
 <meta http-equiv="content-type" content="application/xhtml+xml; charset=utf-8">
 <meta http-equiv="content-style-type" content="text/css">
 <meta http-equiv="Content-Script-Type" content="text/javascript">

<title>
アクション定義を省略する - Ethna - PHPウェブアプリケーションフレームワーク</title>
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

# アクション定義を省略する 

<!-- ?? Content ?? ========================================================= -->
<!-- ??BEGIN id:main -->
<!-- ??BEGIN id:wrap_content -->
<!-- ??BEGIN id:content -->
<!-- ??BEGIN id:page_navigator -->
<!-- ??END id:PageNavigator -->
<!-- ??BEGIN id:body --> [Ethna](index.html) > [ドキュメント](ethna-document.html) > [開発マニュアル](ethna-document-dev_guide.html) > [アクション定義](ethna-document-dev_guide-action.html) > アクション定義を省略する 

- アクション定義を省略する 
  - アクション名の決定方法 
  - アクション定義の省略方法 
  - 補足 

## アクション定義を省略する [](ethna-document-dev_guide-action-omit.html#jaa88555 "jaa88555")

アクションを定義する場合、_厳密には_コントローラの$actionメンバ変数に以下のようなエントリを追加する必要があります。

    'some_action' => array(
      'form_name' => 'Sample_Form_SomeAction',
      'form_path' => 'Some/Action.php',
      'class_name' => 'Sample_Action_SomeAction',
      'class_path' => 'Some/Action.php',
    ),

しかし、1アクション毎にこれらのエントリを定義するのはあまりに煩雑なので、実際には以下のようにアクション定義を省略することが出来ます。

    'some_action' => array(),

さらに、これさえも面倒な場合はコントローラへのアクション定義そのものを省略することも可能です(Mojavi方式\*1)。

    // 何もなし

ここでは、コントローラのアクション名決定方法と、アクション定義が省略された場合のアクションスクリプト名、アクションクラス名等の決め方について記述します。

### アクション名の決定方法 [](ethna-document-dev_guide-action-omit.html#j8c2d96f "j8c2d96f")

Ethnaフレームワークのアクションは以下の手順で決定されます。実は結構複雑ですが、割とどうでも良いことなので読み飛ばして頂いても構いません。

1. クライアントから送信されたフォーム値を解析してアクション名を決定する\*2
2. アクション名に対応するアクション定義(コントローラの$actionメンバのエントリ)を取得する
3. アクションスクリプトを読み込む
  1. アクション定義に'class\_path'属性が存在すればそのファイルをインクルード
  2. アクション名から決定されるデフォルトのアクションスクリプト\*3が存在すればそのファイルをインクルード
  3. どちらも存在しなければactionディレクトリ以下の全てのファイルをインクルード
  4. (アクションフォームについても同様)
4. アクション定義に'class\_name'属性が存在しない場合、デフォルトのアクションクラス名を設定\*4
5. 4.で決定されたアクションクラスが定義されていれば正しいアクション名とみなす  
アクションクラスが定義されていない場合、$fallback\_action\_nameをアクション名とみなしてアクションを実行する(($fallback\_action\_nameについては [未定義のアクションが指定された場合に特定のアクションを実行する](ethna-document-dev_guide-app-fallbackentrypoint.html "ethna-document-dev\_guide-app-fallbackentrypoint (1240d)")を参照してください))

### アクション定義の省略方法 [](ethna-document-dev_guide-action-omit.html#jd48d0d1 "jd48d0d1")

アクション名の決定方法はなかなか複雑ですが、アクション定義の省略方法は簡単です。要するに

1. アクション名に対応するアクションスクリプトを作成する
2. 1.で作成したファイルにアクション名に対応するアクションクラスを定義する

とう2つの手順だけでOKです。

アクション名が"some\_action\_name"だとすると、アクション定義省略時にインクルードされるアクションスクリプトは

    Some/Action/Name.php

となります("\_" -> "/"+先頭1文字を大文字)。

また、アクションクラス名は

    {$アプリケーションID}_Action_SomeActionName

そしてアクションフォーム名は

    {$アプリケーションID}_Form_SomeActionName

となりますので、これらの命名規則に従ってファイルを作成し、クラスを定義しておけばアクション定義を記述しなくても所定のアクションが実行されます。

### 補足 [](ethna-document-dev_guide-action-omit.html#j51cc6b2 "j51cc6b2")

なお、これらの命名規則はアプリケーションによって好みの形に変更することが出来ます。詳細は下記をご覧下さい。

_see also:_ [アクションクラスの命名規則を変更する](ethna-document-dev_guide-action-namingconvention.html "ethna-document-dev\_guide-action-namingconvention (1240d)")

また、定義した命名規則に従っていちいちファイルを作成するのが面倒な場合は、binディレクトリに生成されるgenerate\_action\_script.phpを利用することで、アクションスクリプトのスケルトンを生成することが出来ます。

_see also:_ [アクションスクリプトのスケルトンを生成する](ethna-document-dev_guide-action-skelton.html "ethna-document-dev\_guide-action-skelton (1240d)")

<!-- ??END id:body -->
<!-- ??BEGIN id:summary --><!-- ??BEGIN id:note -->

* * *
\*1勝手に命名  
\*2アクション名の決定方法については [アクション名の決定方法を変更する](ethna-document-dev_guide-action-formname.html "ethna-document-dev\_guide-action-formname (1026d)")を参照してください  
\*3デフォルトのアクションスクリプトの決定方法については [アクションクラスの命名規則を変更する](ethna-document-dev_guide-action-namingconvention.html "ethna-document-dev\_guide-action-namingconvention (1240d)")を参照してください  
\*4デフォルトのアクションスクリプトの決定方法については [アクションクラスの命名規則を変更する](ethna-document-dev_guide-action-namingconvention.html "ethna-document-dev\_guide-action-namingconvention (1240d)")を参照してください  

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

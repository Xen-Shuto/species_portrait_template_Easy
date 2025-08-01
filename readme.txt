------------------------------------------------------------------------
--  StellarisポートレートMOD作成用テンプレート（Easy版）
--  作った人：Xen-Shuto
--  更新履歴：00.00.001：2024/08/20：新規作成
--          ：00.00.002：2025/02/16：都市外観名称、艦船外観名称等に悪影響があったため、内部のディレクトリ名、ファイル名を変更。
--          ：00.00.003：2025/06/07：対応バージョンをv4.x.xに修正
--          ：00.00.004：2025/06/08：portrait_setsのspecies_classを修正
--          ：00.00.005：2025/07/28：名称リストに対応
--          ：00.00.006：20yy/mm/dd：
--
--  タブは８文字
------------------------------------------------------------------------
・はじめに
　画像や用意したが、面倒なファイルの編集を極力したくない方向け

・できること
　・静止画ポートレートMODの作成

・できないこと
　・上記以外
　　アニメーションポートレートMODの作成
　　名称リストとの連動
　　その他、起源やイベントの追加など

・必要なもの
　・テキストエディタ
　　notepad（メモ帳）ではダメ！
　　文字コード指定の出来るテキストエディタが必要
　　編集するファイルはテキストだが、全てUTF-8 BOM無し（ローカライズのみBOM有り）なので
　　と思っていたが、メモ帳でも ANSI(SJIS)、UTF-8 BOM有り/無しの保存ができる模様

　・ポートレート用の画像
　　最低でも１枚は用意すること
　　※画像生成AIで作成した画像をサンプル画像として添付しています。

　・画像編集ソフト
　　DDS(DirectDraw surface)形式とPSD（Photoshopドキュメント）形式が取り扱えて、
　　背景が透過できる物（この２形式が取り扱えるなら、背景の透過はできるはず）
　　作者はPaint.netを使用した

　・その他
　　・作者の環境では雛型のままでポートレートを追加してプレイできることは確認済みなので、
　　　追加できないぞと言われても困る
　　・画像は自分で用意すること

　・謝辞
　　MOD作成ガイドのコメント欄で反応下さった方々、おかげで公開する踏ん切りがつきました。
　　特に参考情報としてご自身が管理されているGitHubを教えて下さったのFatalErrorJP様、
　　大変参考になりました。また、コードの添削ありがとうございました。
　　ローカライズ定義のコメントを一部使わせて頂いてます。

------------------------------------------------------------------------
--  フォルダ構成
------------------------------------------------------------------------
species_portrait_template
│  config.txt								：MODコピーツール用設定ファイル
│  copy_script.vbs							：MODコピーツール
│  readme.adoc								：主に更新履歴
│  readme.txt								：このファイル
│  template.psd							：ポートレート画像のテンプレ（位置確認用）
│
├─MOD									：MOD作成フォルダ
│
└─MOD_BASE								：MODの作成元【このフォルダ配下のファイルは触らないこと】
    │  mod_portrait_hinagata.mod					：PC用MOD定義
    │
    └─portrait_hinagata						：ポートレートMOD本体
        │  descriptor.mod						：ランチャー用MOD定義
        │
        ├─common
        │  ├─name_lists						：名称リスト定義
        │  │      00_hinagata_name_lists_01_bio.txt			：　有機生命体用定義
        │  │      00_hinagata_name_lists_02_robotics.tx	t	：　機械知性用定義
        │  │      00_hinagata_name_lists_03_lithoid.txt		：　岩石種族用定義
        │  │
        │  ├─portrait_categories					：種族選択画面表示用定義
        │  │      00_hinagata_portrait_categories_01_bio.txt		：　有機生命体用定義
        │  │      00_hinagata_portrait_categories_02_robotics.txt	：　機械知性用定義
        │  │      00_hinagata_portrait_categories_03_lithoid.txt	：　岩石種族用定義
        │  │
        │  ├─portrait_sets						：種族ポートレート定義
        │  │      00_hinagata_portrait_sets_01_bio.txt		：　有機生命体用定義
        │  │      00_hinagata_portrait_sets_02_robotics.txt		：　機械知性用定義
        │  │      00_hinagata_portrait_sets_03_lithoid.txt		：　岩石種族用定義
        │  │
        │  ├─species_classes						：種族定義
        │  │      00_hinagata_species_classes_01_bio.txt		：　有機生命体用定義
        │  │      00_hinagata_species_classes_02_robotics.txt		：　機械知性用定義
        │  │      00_hinagata_species_classes_03_lithoid.txt		：　岩石種族用定義
        │  │
        │  └─species_names						：名称リスト
        │          00_hinagata_species_names_01_bio.txt		：　有機生命体用定義
        │          00_hinagata_species_names_02_robotics.txt		：　機械知性用定義
        │          00_hinagata_species_names_03_lithoid.txt		：　岩石種族用定義
        │
        ├─gfx
        │  ├─models							：ポートレート画像格納フォルダ
        │  │  ├─hinagata_01_bio					：有機生命体用ポートレート画像
        │  │  │      hinagata_bio_sample001.dds			：　テスト画像[役人/男性]	※役職でわける必要は無い
        │  │  │      hinagata_bio_sample002.dds			：　テスト画像[役人/女性]
        │  │  │      hinagata_bio_sample101.dds			：　テスト画像[科学者/男性]
        │  │  │      hinagata_bio_sample102.dds			：　テスト画像[科学者/女性]
        │  │  │      hinagata_bio_sample201.dds			：　テスト画像[司令官/男性]
        │  │  │      hinagata_bio_sample202.dds			：　テスト画像[司令官/女性]
        │  │  │      hinagata_bio_sample301.dds			：　テスト画像[使節/男性]
        │  │  │      hinagata_bio_sample302.dds			：　テスト画像[使節/女性]
        │  │  │      hinagata_bio_sample901.dds			：　テスト画像[汎用/男性]
        │  │  │      hinagata_bio_sample902.dds			：　テスト画像[汎用/女性]
        │  │  │
        │  │  ├─hinagata_02_robotics				：機械知性用ポートレート画像
        │  │  │      hinagata_robo_sample001.dds			：　テスト画像[役人/男性]	※役職でわける必要は無い
        │  │  │      hinagata_robo_sample002.dds			：　テスト画像[役人/女性]
        │  │  │      hinagata_robo_sample101.dds			：　テスト画像[科学者/男性]
        │  │  │      hinagata_robo_sample102.dds			：　テスト画像[科学者/女性]
        │  │  │      hinagata_robo_sample201.dds			：　テスト画像[司令官/男性]
        │  │  │      hinagata_robo_sample202.dds			：　テスト画像[司令官/女性]
        │  │  │      hinagata_robo_sample301.dds			：　テスト画像[使節/男性]
        │  │  │      hinagata_robo_sample302.dds			：　テスト画像[使節/女性]
        │  │  │      hinagata_robo_sample901.dds			：　テスト画像[汎用/男性]
        │  │  │      hinagata_robo_sample902.dds			：　テスト画像[汎用/女性]
        │  │  │
        │  │  └─hinagata_03_lithoid					：岩石種族用ポートレート画像
        │  │          hinagata_lit_sample001.dds			：　テスト画像[役人/男性]	※役職でわける必要は無い
        │  │          hinagata_lit_sample002.dds			：　テスト画像[役人/女性]
        │  │          hinagata_lit_sample101.dds			：　テスト画像[科学者/男性]
        │  │          hinagata_lit_sample102.dds			：　テスト画像[科学者/女性]
        │  │          hinagata_lit_sample201.dds			：　テスト画像[司令官/男性]
        │  │          hinagata_lit_sample202.dds			：　テスト画像[司令官/女性]
        │  │          hinagata_lit_sample301.dds			：　テスト画像[使節/男性]
        │  │          hinagata_lit_sample302.dds			：　テスト画像[使節/女性]
        │  │          hinagata_lit_sample901.dds			：　テスト画像[汎用/男性]
        │  │          hinagata_lit_sample902.dds			：　テスト画像[汎用/女性]
        │  │
        │  └─portraits
        │      └─portraits						：ポートレート定義
        │              00_hinagata_portraits_01_bio.txt		：　有機生命体用定義
        │              00_hinagata_portraits_02_robotics.txt		：　機械知性用定義
        │              00_hinagata_portraits_03_lithoid.txt		：　岩石種族用定義
        │
        └─localisation						：ローカライズ定義（言語ごと）
            └─japanese						：日本語用定義（他には英/葡/仏/独/波/露/西/韓/中がある）
                │  hinagata_l_japanese.yml				：　共通の定義
                │  hinagata_l_japanese_01_bio.yml			：　有機生命体用定義
                │  hinagata_l_japanese_02_robotics.yml			：　機械知性用定義
                │  hinagata_l_japanese_03_lithoid.yml			：　岩石種族用定義
                │  
                └─name_lists						：名称リストを自分で定義する時用のフォルダ

------------------------------------------------------------------------
--  使い方
------------------------------------------------------------------------
１）MODコピーツール用設定ファイルの編集
　・config.txtをテキストエディタで開き、中身の記述に従って編集してください。

２）MODコピーツールの実行
　・copy_script.vbsをダブルクリックして実行してください。
　　MODフォルダの中に、設定ファイルの内容に従って編集されたポートレートMODが作成されます。


【以降のファイル編集は、全てMOD作成フォルダ内のファイルに対して行うこと】


３）MOD定義の編集
　・MODの名称、バージョンを設定し、UTF-8 BOM無しで保存する
********
	version="0.0.1"			：このMODのバージョン（お好きな値で）
	tags={
		"Species"		：ここはMODの追加時に設定したタグなので、特に変える必要は無い
	}
	name="ポートレートMOD雛型"	：たぶんワークショップに表示されるMODの名前（わかり易い名前に変更する）
	supported_version="v3.*.*"	：MODが対応するゲームのバージョン（多少違っても問題ない。25/2/16時点ではv3.14）
	path="mod/portrait_hinagata"	：MODのパス（コピーツールで編集済み）
********

４）ランチャー用MOD定義の編集
　・MODの名称、バージョンを設定し、UTF-8 BOM無しで保存する
********
	version="0.0.1"			：このMODのバージョン（お好きな値で）
	tags={
		"Species"		：ここはMODの追加時に設定したタグなので、特に変える必要は無い
	}
	name="ポートレートMOD雛型"	：ランチャーに表示されるMODの名前（わかり易い名前に変更する）
	supported_version="v3.*.*"	：MODが対応するゲームのバージョン（多少違っても問題ない。25/2/16時点ではv3.14）
********

５）ローカライズ定義の編集
　・種族グループ名の日本語を設定し、UTF-8 BOM有りで保存する。
　※変更しない場合、種族グループ名は「雛型」となる。

６）画像の用意
　・Paint.Netがあると良い。
　・画像サイズは360x360であること。
　・同梱しているtemplate.psdで表示範囲を確認しながら、サイズと配置を決める。
　　上左右は枠内に収めると見栄えが良い。下ははみ出して配置すること。
　・背景を透過する。
　・DDS(DirectDraw surface)形式で保存する。
　・作成したDDS形式の画像をポートレート画像格納フォルダに配置する。

７）ポートレート定義（portraits）の編集
　・使用する画像ファイルの指定を行う
　　portrait000 = {texturefile = "gfx/models/xxxxx/gazou.dds"}　を、作成した画像に合わせて
　　必要な数だけ記述する
　　「=」の左側は識別子、右側が画像ファイルのパス（gfxフォルダから始まる相対パス）
　　※「portrait000」は以降で使用する画像識別子（全体を通して重複しないこと）
　　※「xxxxx」は「hinagata」から変更した種族名の英字（コピーツールで編集済み）
　　※「gazou.dds」は実際の画像ファイル名
　・各設定で使用したいポートレートを識別子で記述する
　　portraitsの中にあるtxtを見てもらえば、たぶんわかると思う・・・

８）不要フォルダ／ファイルの削除
　・使用しない種族用のフォルダ／ファイルを削除する。
　　※例えば有機生命体用のみを使用する場合、機械知性用、岩石種族用のフォルダ／ファイルを削除する。

９）MODの配置と動作確認
　・MOD格納用フォルダにMOD定義とポートレートMODフォルダを配置する。
　・Stellarisを起動し、ランチャー左側の「インストール済みのすべてのMOD」を選択、
　　作成したMODが表示されているか確認する。
　　表示されていない場合、MODの再ロードを試みる。
　・プレイセットに作成したMODを追加する。
　・MODを追加したプレイセットでStellarisを起動する。
　・ニューゲーム→新規作成と選択し、以下を確認する
　　　・外見に、このMODで追加したい種族が表示されていること。
　　　・外見選択後、ポートレートの一覧が表示されていること。
　　　・統治者の外見にて、統治者の外見を変更してみて一通りポートレートが表示できていること。
　・上記が問題無ければゲームを開始する
　・各種画面でポートレートが想定通りに表示されていること。
　　　・政府、艦船、一覧等・・・

以上

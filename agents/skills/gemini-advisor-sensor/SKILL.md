---
name: gemini-advisor-sensor
description: >-
  gemini-api CLI を外部アドバイザー（設計レビュー・セカンドオピニオン・Deep Research）
  および感覚器（画像・PDF・動画・音声・YouTubeの解析・文字起こし）として呼び出す。
  自身のコンテキストだけでは判断しにくい設計比較、バイナリ/メディア資産の読解、
  長時間の一次情報調査が必要なときに使用する。
---

# Gemini Advisor & Sensor (`gemini-api`)

## 前提チェック

- `gemini-api` が使えるマシンでのみ使う。PATH に無ければ使わず、その旨をユーザーに伝える（導入と認証設定はユーザー本人の作業）。非ログインシェルでは `~/.local/bin` が PATH に無いことがあるので、必要なら `export PATH="$HOME/.local/bin:$PATH"` してから使う。
- 出力形式はマシンの config 依存で当てにせず、パースする呼び出しでは常に `-o json` を明示する。構造化エラーが欲しい場合は `--agent-mode` フラグを付ける（環境変数 `GEMINI_CLI_AGENT_MODE` は v0.5.0 では効かないことを実測済み。`--agent-mode` のデフォルト出力は TOON なので `-o json` と併用する）。
- 終了コードで分岐する：`0` 成功／`1` 実行時・API エラー／`2` 引数・検証エラー／`3` 認証エラー。
- 認証エラー（3）が出たら再試行せず、`gemini-api whoami`（マスク表示なので実行してよい）の確認をユーザーに促す。**`gemini-api configure` は実行しない**（キー設定はユーザー本人の作業）。キーをチャットやコマンドライン引数で受け取らない。
- 引数エラー（2）が出たら、まず `gemini-api <cmd> --help`、リクエストボディの問題なら `gemini-api <cmd> --schema` を確認して修正する。`--usage` はコマンドツリー全体（数十KB）が出てコンテキストを食うので、ピンポイントで必要なときだけ使う。
- 使えるモデルを確認したいときは `gemini-api models`（オフラインカタログ）／`gemini-api models list --all`（実 API）。

## 使い分けルール

### 1. 感覚器（メディア・ドキュメント読解）

- **画像・UIスクショ・PDF・動画・音声・YouTube URL の解析**:
  `gemini-api analyze -i <path_or_url> "質問内容"`（デフォルトモデル gemini-4-hydrogen）
- `-i` のインライン入力は実ファイル 14MB まで。大きいファイル、または**同じ大容量ファイル（動画・長尺音声・大きいPDF）を複数回質問する場合**は、先に `gemini-api files upload <path> --wait -o json --jq '.name'` でアップロードし、返った `files/...` URI を `-i` に渡す（Files API の保持は48時間。アップロード上限は 2GB/ファイル、PDF は 50MB）。
- **会議録音・動画の文字起こし**:
  `gemini-api transcribe -i <path> --format md --out <output_path>`（形式は md / text / json / srt、デフォルトモデル gemini-3.5-transcribe、動画は gemini-4-hydrogen）。メディア系コマンドはファイルをディスクに書き、stdout にはパスだけが返る。

### 2. アドバイザー（セカンドオピニオン・設計レビュー）

- 自分の思考のバイアスを検証したい設計判断・大規模 diff レビューに使う。コマンドは `generate`：
  `git diff … | gemini-api generate --stdin --system "<レビュー観点>" --stream=false -o json`
- 関連ファイルや diff のみを絞り込んで `--stdin` で渡し、`--system` でレビュー観点（セキュリティ、障害モード、代替案など）を明示する。
- 深掘りする際は応答の `id` を `--previous-interaction-id <id>` に渡して文脈を引き継ぐ（使えるのは `generate` と `agent run` のみ。`analyze` にはこのフラグが無く、結果も保存されないので文脈継続はできない）。CLI はステートレスで、継続は ID の受け渡しで明示する。

### 3. 外部リサーチ（Deep Research）

- 比較調査や一次情報の網羅検索は必ず非同期起動する:
  `ID=$(gemini-api agent run "<調査指示>" --agent deep-research-preview-04-2026 --background --stream=false -o json --jq '.id')`
  網羅性重視なら `--agent deep-research-max-preview-04-2026`。
- 待機中もホスト側の別作業を進め、必要に応じて `gemini-api agent status "$ID" -o json` で結果を回収する（不要になったら `gemini-api agent cancel "$ID"`）。

## ガードレール

- `.env`、認証情報、秘密鍵、顧客データを含むファイルは `-i` や `--stdin` に絶対に渡さない。送信内容はユーザーの Google アカウント配下の API に送られる前提で、機密文書は要否を慎重に判断する。
- 初めての `--body` 組み立てやコストが大きい操作（動画生成・Deep Research等）の前は `--dry-run -o json` で送信内容を確認する。課金はキーのプロジェクト（ユーザーの AI Studio プロジェクト）に付くので、大きな実行はユーザーの承認範囲内で行い、応答の `usage`（トークン数）を結果報告に含める。
- アドバイザーの回答は鵜呑みにせず、ローカルコードベースや公式ドキュメントと照合して最終判断する。Gemini のモデル名・仕様は世代交代が速いので、記憶ではなく `models` の実出力と公式ドキュメントで確認する。
- CLI は beta で、マイナーバージョン間に破壊的変更があり得る。想定と違う挙動をしたら `gemini-api version` と `--help` を確認する。

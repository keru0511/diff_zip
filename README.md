# diff_zip
gitのコミットハッシュ値やリポジトリから差分を取得して、
zipに固めます。

利用方法
cloneするかダウンロードして解凍してください。

コマンドラインで動作します。
引数に以下を渡してください。

sh git_diff.sh [差分を取得したいディレクトリ(絶対参照 or 相対参照)] [対象のリポジトリ、もしくはコミットハッシュ値] [比較したいリポジトリ、もしくはコミットハッシュ値]

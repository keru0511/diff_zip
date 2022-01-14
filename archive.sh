function git_diff_archive {
	# ディレクトリの移動
	echo "$2に移動します。"
	cd $2
	create_dir=$(echo "$(pwd)" | sed -e 's/.*\/\([^\/]*\)$/\1/')
	create_dir="${create_dir}_$(date "+%Y%m%d_%H-%M-%S")"
	mkdir $dir_name/diff_file/$create_dir
	# 変数定義
	local diff=""
	local h="HEAD"
	diff="${4}..${3}"
	h=$3
	file_name=$4
	diff="git diff --diff-filter=d --name-only ${diff}"
	is_diff=$(${diff})
	is_diff=${#is_diff}
	if [ $is_diff -eq 0 ]; then
		echo "差分がありません。"
		echo "出力を中断します。"
		exit 0
	fi
	echo "${diff}の差分を出力しています。"
	git archive --format=zip $h $(eval $diff) -o $dir_name/diff_file/$create_dir/$h.zip
	branch_all=$(git branch --contains ${3})
	branch=$(echo $branch_all | cut --delim=" " -f 1)
	git checkout $branch

	# 入れ替えて比較
	# 変数定義
	local diff=""
	local h="HEAD"
	diff="${3}..${4}"
	h=$4
	file_name=$3
	diff="git diff --diff-filter=d --name-only ${diff}"
	is_diff=$(${diff})
	is_diff=${#is_diff}
	if [ $is_diff -eq 0 ]; then
		echo "差分がありません。"
		echo "出力を中断します。"
		exit 0
	fi
	echo "${diff}の差分を出力しています。"
	git archive --format=zip $h $(eval $diff) -o $dir_name/diff_file/$create_dir/$h.zip
}
# この関数でディレクトリ名を取得したい
function get_dir_name {
	dir_name=$(
		cd $(dirname ${0})
		pwd
	)
}
# $1=案件ディレクトリ
# $2=比較対象1
# $3=比較対象2
if [ $# -eq 0 ]; then
	echo "案件の指定をしてください。"
	exit 0
fi
if [ $# -ne 3 ]; then
	echo "比較対象を選択してください。"
	exit 0
fi
get_dir_name $0
git_diff_archive $dir_name $1 $2 $3

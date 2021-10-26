function git_diff_archive {
	# ディレクトリの移動
	echo "$2の差分出力を行います。"
	cd $2
	# 変数定義
	local diff=""
	local h="HEAD"
	# 引数が２つの場合は、HEADと比較
	# ３つの場合は、後ろ２つで比較
	if [ $# -eq 3 ]; then
		if expr "$3" : '[0-9]*$' >/dev/null; then
			diff="HEAD~${3} HEAD"
		else
			diff="${3} HEAD"
		fi
	elif [ $# -eq 4 ]; then
		diff="${4} ${3}"
		h=$3
	fi
	if [ "$diff" != "" ]; then
		diff="git diff --diff-filter=d --name-only ${diff}"
	fi
	git archive --format=zip --prefix=new/ $h `eval $diff` -o $dir_name/new.zip
	branch_all=$(git branch --contains ${3})
	branch=`echo $branch_all | cut --delim=" " -f 1`
	git checkout $branch

	# 入れ替えて比較
	if [ $# -eq 3 ]; then
		if expr "$3" : '[0-9]*$' >/dev/null; then
			diff="HEAD HEAD~${3}"
		else
			diff="HEAD ${3}"
		fi
	elif [ $# -eq 4 ]; then
		diff="${3} ${4}"
		h=$4
	fi
	if [ "$diff" != "" ]; then
		diff="git diff --diff-filter=d --name-only ${diff}"
	fi
	git archive --format=zip --prefix=old/ $h `eval $diff` -o $dir_name/old.zip
}
# この関数でディレクトリ名を取得したい
function get_dir_name {
	dir_name=$(cd $(dirname ${0});pwd)
}
# $1=案件ディレクトリ
# $2=比較対象1
# $3=比較対象2
if [ $# -eq 0 ]; then
	echo "案件の指定をしてください"
	exit 0
fi
get_dir_name $0
git_diff_archive $dir_name $1 $2 $3
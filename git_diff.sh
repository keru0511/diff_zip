function git_diff_archive {
	# 変数定義
	local diff=""
	local h="HEAD"
	# 引数が２つの場合は、HEADと比較
	# ３つの場合は、後ろ２つで比較
	if [ $# -eq 2 ]; then
		if expr "$2" : '[0-9]*$' >/dev/null; then
			diff="HEAD~${2} HEAD"
		else
			diff="${2} HEAD"
		fi
	elif [ $# -eq 3 ]; then
		diff="${3} ${2}"
		h=$2
	fi
	if [ "$diff" != "" ]; then
		diff="git diff --diff-filter=d --name-only ${diff}"
	fi
	# ディレクトリの移動
	cd $1
	git archive --format=zip --prefix=new/ $h `eval $diff` -o ../diff_zip/new.zip
	branch_all=$(git branch --contains ${2})
	branch=`echo $branch_all | cut --delim=" " -f 1`
	git checkout $branch

	# 入れ替えて比較
	if [ $# -eq 2 ]; then
		if expr "$2" : '[0-9]*$' >/dev/null; then
			diff="HEAD HEAD~${2}"
		else
			diff="HEAD ${2}"
		fi
	elif [ $# -eq 3 ]; then
		diff="${2} ${3}"
		h=$3
	fi
	if [ "$diff" != "" ]; then
		diff="git diff --diff-filter=d --name-only ${diff}"
	fi
	git archive --format=zip --prefix=old/ $h `eval $diff` -o ../diff_zip/old.zip
}
# $1=案件ディレクトリ
# $2=比較対象1
# $3=比較対象2
if [ $# -eq 0 ]; then
	echo "案件の指定をしてください"
	exit 0
fi
git_diff_archive $1 $2 $3
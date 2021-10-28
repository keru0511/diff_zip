function git_diff_archive {
	# ディレクトリの移動
	echo "$2の差分出力を行います。"
	cd $2
	create_dir=`echo "$(pwd)" | sed -e 's/.*\/\([^\/]*\)$/\1/'`
	create_dir="${create_dir}_$(date "+%Y%m%d_%H-%M-%S")"
	mkdir $dir_name/diff_file/$create_dir
	# 変数定義
	local diff=""
	local h="HEAD"
	# 引数が２つの場合は、HEADと比較
	# ３つの場合は、後ろ２つで比較
	if [ $# -eq 3 ]; then
		if expr "$3" : '[0-9]*$' >/dev/null; then
			diff="HEAD..${3}"
			file_name="HEAD"
		else
			diff="${3}..HEAD"
			file_name=$3
		fi
	elif [ $# -eq 4 ]; then
		diff="${4}..${3}"
		h=$3
		file_name=$4
	fi
	if [ "$diff" != "" ]; then
		diff="git diff --diff-filter=d --name-only ${diff}"
	fi
	echo "${diff}の差分を出力しています。"
	echo "git archive --format=zip --prefix=${file_name}/ ${h} `eval ${diff}` -o ${dir_name}/diff_file/${create_dir}/${file_name}.zip"
	git archive --format=zip --prefix=$file_name/ $h `eval $diff` -o $dir_name/diff_file/$create_dir/$file_name.zip
	branch_all=$(git branch --contains ${3})
	branch=`echo $branch_all | cut --delim=" " -f 1`
	git checkout $branch

	# 入れ替えて比較
	if [ $# -eq 3 ]; then
		if expr "$3" : '[0-9]*$' >/dev/null; then
			diff="${3}..HEAD"
			file_name="HEAD"
		else
			diff="HEAD..${3}"
			file_name=$3
		fi
	elif [ $# -eq 4 ]; then
		diff="${3}..${4}"
		h=$4
		file_name=$3
	fi
	if [ "$diff" != "" ]; then
		diff="git diff --diff-filter=d --name-only ${diff}"
	fi
	echo "${diff}の差分を出力しています。"
	echo "git archive --format=zip --prefix=${file_name}/ ${h} `eval ${diff}` -o ${dir_name}/diff_file/${create_dir}/${file_name}.zip"
	git archive --format=zip --prefix=$file_name/ $h `eval $diff` -o $dir_name/diff_file/$create_dir/$file_name.zip
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
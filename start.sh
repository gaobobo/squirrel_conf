#!/bin/sh

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/Rime"
TARGET_DIR="$HOME/Library/Rime"

mkdir -p "$TARGET_DIR"

existing_files=""

for source_path in "$SOURCE_DIR"/*; do
	[ -e "$source_path" ] || continue
	[ -f "$source_path" ] || continue

	file_name="$(basename "$source_path")"
	target_path="$TARGET_DIR/$file_name"

	if [ -e "$target_path" ] || [ -L "$target_path" ]; then
		existing_files="$existing_files\n$file_name"
	fi
done

if [ -n "$existing_files" ]; then
	echo "目标文件已经存在"
	printf '%b\n' "$existing_files" | sed '/^$/d' | sed 's/^/- /'
	exit 1
fi

for source_path in "$SOURCE_DIR"/*; do
	[ -e "$source_path" ] || continue
	[ -f "$source_path" ] || continue

	file_name="$(basename "$source_path")"
	target_path="$TARGET_DIR/$file_name"

	if [ -e "$target_path" ] || [ -L "$target_path" ]; then
		continue
	fi

	ln -s "$source_path" "$target_path"
	echo "已创建软连接: $file_name"
done



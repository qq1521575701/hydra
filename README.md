  ### 安装zmap 克隆项目

	apt update && apt install zmap && apt install git && git clone https://github.com/qq1521575701/hydra.git

  ### zmap扫描ssh服务

	zmap -p 22 0.0.0.0/0 -N 10000 -o 22.txt

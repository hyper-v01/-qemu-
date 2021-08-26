#!/bin/ksh
#By Hyper-V Manager
#三连？拿来吧你
function Error  #心脏骤停的出错
{  #Errors
	if (( $1 == 0 )); then
		if (( $Install_qemu_img == 1 )); then  #qemu-img
			if (( $Install_qemu_x86 == 1 )); then	#qemu-system-x86
				if (( $Install_qemu_arm == 1 )); then	#qemu-system-arm
					export Qemu_install="qemu-utils qemu-system-x86-64 qemu-system-arm"
				else
					export Qemu_install="qemu-utils qemu-system-x86-64"
				fi
				export Qemu_install="qemu-utils qemu-system-x86-64"
			else
				export Qemu_install="qemu-utils"
			fi
			export Qemu_install="qemu-utils"
		else
			export Qemu_install=''
		fi
		if test -z $Qemu_install; then
			echo "Qemu所有程序已就位"
			sleep 1s
			return
		else
			echo "Error($1) : 你似乎缺少了 $Qemu_install 的某个"
			echo ""
			echo "是否现在安装?"
			echo "[yes][Yes][no][No][y][Y][n][N]    默认(yes)"
			while read install
			do
				YES_NO $install
				if (( $? == 0 )); then
					exit
				else
					if (( $? == 1 )); then
						if (( $Install_qemu_img == 1 )); then  #qemu-img
							if (( $Install_qemu_x86 == 1 )); then	#qemu-system-x86
								if (( $Install_qemu_arm == 1 )); then	#qemu-system-arm
									sudo apt install qemu-utils qemu-system-x86-64 qemu-system-arm
								else
									sudo apt install qemu-utils qemu-system-x86-64
								fi
								sudo apt install qemu-utils qemu-system-x86-64
							else
								sudo apt install qemu-utils
							fi
							sudo apt install qemu-utils
						fi
					fi
				fi
			done
		fi
	else 
		if (( $1 == 1)); then
			echo "Error($1) : 请输入正确的单位"
			return
		else
			if (( $1 == 2 )); then
				echo "Error($1) : 磁盘空间太小了"
				return
			else
				if (( $1 == 3 )); then
					echo "Error($1) : 你打错了磁盘格式"
					return
				else 
					if (( $1 == 4 )); then
						echo "Error($1) : 你选择了一个Invalid的架构"
						return
					else
						if (( $1 == 5 )); then
							echo "Error($1) : 写个好点的名字吧"
							return
						else 
							if (( $1 == 6 )); then
								echo "Error($1) : 你选择了一个Invalid的型号"
								return
							else
								if (( $1 == 7 )); then
									echo "Error($1) : 端口超出范围"
									return
								else
									if (( $1 == 8 )); then
										echo "Error($1) : 你写的内存8太行"
										return
									else
										if (( $1 == 9 )); then
											echo "Error($1) : 写个正确的数字吧"
											return
										else
											if (( $1 == 10 )); then
												echo "Error($1) : 你写的内存8太行"
												return
											fi
										fi
									fi	
								fi 
							fi
						fi
					fi
				fi
			fi
		fi
	fi
}
function install_qemu
{
export Install_qemu_img=0
export Install_qemu_x86=0
export Install_qemu_arm=0
	if whence -qp qemu-img; then
		export Install_qemu_img=0
		sleep 1s
		echo "qemu-utils"
	else
		export Install_qemu_arm=1
	fi
	if whence -qp qemu-system-x86_64; then
		export Install_qemu_x86=0
		sleep 1s
		echo "qemu-system-x86"
	else
		export Install_qemu_x86=1
	fi
	if whence -qp qemu-system-arm; then
		export Install_qemu_arm=0
		sleep 1s
		echo "qemu-system-arm"
	else
		export Install_qemu_arm=1
	Error 0
}
function YES_NO		#对“是否”的处理
{
    if test -z $1; then
	    return 1
	        echo "yes"
    else
	    if [ $1 = 'yes' ]; then
		    return 1
	    	echo "yes"
	    else
	    	if [ $1 = 'Yes' ]; then
	    		return 1
	    		echo "yes"
	    	else 
	    		if [ $1 = 'Y' ]; then
	    			return 1
	    			echo "yes"
	    		else
	    			if [ $1 = 'y' ]; then
	    				return 1
		    			echo "yes"
		    		else
		    			if [ $1 = 'no' ]; then
		    				return 0
		    				echo "no"
		    			else
		    				if [ $1 = 'No' ]; then
		    					return 0
		    					echo "no"
			    			else
			    				if [ $1 = 'n' ]; then
				    				return 0
				    				echo "no"
				    			else
				    				if [ $1 = 'N' ]; then
				    					return 0
				    					echo "no"
									else
										return 1
										echo "yes"
				    				fi
				    			fi
				    		fi
					    fi
		    		fi
			    fi
	    	fi
	    fi
    fi
}
function disk_local		#本地磁盘专用函数
{
	echo "你的虚拟磁盘文件在哪里?"
	echo "[位置][没有的可以写None],你的终端在 $(pwd)   默认($(pwd))"
	while	read disk_path
	do
		if test -z $disk_path; then
			echo "写个正确的磁盘位置吧"
			echo ""
			echo "你的虚拟磁盘文件在哪里?"
			echo "[位置][没有的可以写None],你的终端在 $(pwd)   默认($(pwd))"
		else
			if [ $disk_path = 'None' ]; then
				break
				return 0
			else
				export file5=$(ls $disk_path)
				if test -z $file5; then
					echo "$disk_path 这里似乎没有任何文件"
					echo ""
					echo "你的虚拟磁盘文件在哪里?"
					echo "[位置][没有的可以写None],你的终端在 $(pwd)   默认($(pwd))"
				else
					for d in $disk_path/*.img *.vhd *.qcow *.qcow2 *.vdi *.vmdk
					do
						ls $d
						if (( $? != 0 )); then
							echo "$disk_path 这里似乎没有任何一个磁盘文件"
							echo ""
							echo "你的虚拟磁盘文件在哪里?"
							echo "[位置][没有的可以写None],你的终端在 $(pwd)   默认($(pwd))"
						else
							if (( $? == 0 )); then
								export disk_file=$(ls $d)
								break
							fi
						fi
					done
					if (( $? == 0 )); then
						break
					fi
				fi
			fi
		fi
	done
	echo "你要用哪一个磁盘文件?"
	for d in $disk_path/*.img *.vhd *.qcow *.qcow2 *.vdi *.vmdk;do echo $(ls $d);done
	while read disk_file1
	do
		ls $disk_path/$disk_file1
		if (( $? == 0 )); then
			export RealDisk=$disk_path/$disk_file1
			export enable_disk=1
			disk_model
			break
		fi
	done

}
function choose_arch	#选架构
{  #choose an arch?
  

	echo "选哪个?（目前还没完工，Arm选项暂时不可用）"
	echo "[1]X86_64   [2]Arm"
while read choose
do

	if (( $choose == 1 )); then
		export Arch="qemu-system-x86_64"
		echo "你选择了 $Arch"
		break
	else
		if (( $choose == 2 ));then
			export Arch="qemu-system-arm"
			echo "你选择了 $Arch"
			break
		else
			Error 4

		fi
	fi
done
}
function disks		#掌柜的，来个磁盘，新的
{  #Disk?
	echo "你需要创建一个新的磁盘还是使用原有的?"
	echo "[yes][Yes][y][Y][no][No][n][N][local] 默认(yes)"
	read disk
	if [ $disk = 'local' ]; then
		disk_local
		if (( $? == 1 )); then
			export enable_disk=1
			export RealDisk1="-drive if=none,file=$RealDisk,id=hd0"
		else
			if (( $? == 0 )); then
				export enable_disk=0
				export RealDisk1=''
			fi
		fi
	else
		YES_NO $disk
	fi
	export disk_nee=$?
}
function disks_spaces	#要多大？
{ 

		echo "你需要多大的空间?"
		echo "{['Number']['B'/'KB'/'MB'/'GB']}"
while read space
	do
		export Unit=$(echo $space | tr -cd '[B,KB,MB,GB]')
		export RealSpace=$(echo $space | tr -cd '[0-9]')
		if [ $Unit = 'KB' ]; then
			if (( $RealSpace <= 0 )); then
				Error 2
			else
				break
			fi
		else
			if [ $Unit = 'B' ]; then
				if (( $RealSpace <= 0 )); then
					Error 2
				else
					break
				fi
			else
				if [ $Unit = 'MB' ]; then
					if (( $RealSpace <= 0 )); then
						Error 2
					else
						break
					fi
				else 
					if [ $Unit = 'GB' ]; then
						if (( $RealSpace <= 0 )); then
							Error 2
						else
							break
						fi
					else
						Error 1
					fi
				fi
			fi
		fi
	done
}
function space_process	#彳亍，15GB，三十块
{     #Unit
	if [ $Unit = 'KB' ]; then
		export RealUnit='K'
	else
		if [ $Unit = 'MB' ]; then
			export RealUnit='M'
		else
			if [ $Unit = 'GB' ]; then
				export RealUnit='G'
			fi
		fi
	fi

}
function disk_create1  	#磁盘其他
{	

	echo "你的磁盘叫什么名字?"
while read name
do
	if test -z $name; then
		Error 5
	else
		break
	fi
done
	echo "选个格式吧?" #format
	echo "'raw','qcow2','qcow','vpc'  默认(raw)"
	read disk_format
if test -z $disk_format; then
	export disk_format='raw'
	echo "raw"
else
	if [ $disk_format = 'raw' ]; then
		export Format=$disk_format
		echo "你选择了 $Format"
	else
		if [ $disk_format = 'qcow2' ]; then
			export Format=$disk_format
			echo "你选择了 $Format"
		else
			if [ $disk_format = 'qcow' ]; then
				export Format=$disk_format
                       "你选择了 $Format"
			else 
				if [ $disk_format = 'vpc' ]; then
					export Format=$disk_format
                	"你选择了 $Format"
				else
					Error 3
				fi
			fi
		fi
	fi
fi
}
function disk_model
{
	echo "磁盘的型号?"
	echo "[virtio][scsi]  默认(virtio)"
	while read model
	do
		if test -z $model; then
			export DISK2="-device virtio-blk-pci,drive=hd0,bus=pci.0"
			export model='virtio'
			echo "你选择了 $model"
			break
		else
			if [ $model = 'virtio' ]; then
			export DISK2="-device virtio-blk-pci,drive=hd0,bus=pci.0"
			echo "你选择了 $model"
			break
			else
		      	 	if	[ $model = 'scsi' ]; then
						export DISK2="-device ahci,id=ahci -device ide-drive,drive=hd0,bus=ahci.0"
						echo "你选择了 $model"
						break
					else
						Error 6
	     		  	fi
			fi
		fi
	done
}
function create_img		#出来吧qemu-img
{
	echo "你是想现在创建磁盘还是弄一个创建磁盘的脚本?"
	echo "[1]创建磁盘   [2]创建脚本  默认(1)"
	while read disk_create
	do
		if test -z $disk_create; then
			echo $create_img
			$create_img
			export enable_disk_model=1
			break
		else
			if (( $disk_create == 1 )); then
				echo $create_img
				$create_img
				export enable_disk_model=1
				break
			else
				if (( $disk_create == 2 )); then
					echo $create_img
					touch create-img.sh $(pwd)/
					echo $create_img > $(pwd)/create-img.sh
					break
				else
					echo $create_img
					$create_img
					export enable_disk_model=1
					break
				fi
			fi
		fi
	done
}
function CPU_GPU_VNC_MEM		#CPU显卡屏幕内存大乱炖
{
	echo "你需要什么型号的CPU?"
	echo "[Haswell][core2duo][SandyBridge][IvyBridge][qemu64]   默认(qemu64)"
while	read cpu
do
		if test -z $cpu; then
			export cpu='qemu64'
			echo "你选择了 $cpu"
			break
		else
			if [ $cpu = 'core2duo' ]; then
				export cpu='core2duo'
				echo "你选择了 $cpu"
				break
			else
				if [ $cpu = 'SandyBridge' ]; then
					export cpu='SandyBridge'
					echo "你选择了 $cpu"
					break
				else
					if [ $cpu = 'IvyBridge' ]; then
						export cpu='IvyBridge'
						echo "你选择了 $cpu"
						break
					else
						if [ $cpu = 'Haswell' ]; then
							export cpu='Haswell'
							echo "你选择了 $cpu"
							break
						else
							if [ $cpu = 'qemu64' ]; then
								export cpu='qemu64'
								echo "你选择了 $cpu"
								break
							else
								Error 6
							fi
						fi
					fi
				fi
			fi
		fi
done
echo "写个核心数?"
echo "[数字][1-16]   默认(4)"
while read cores
do
	export cores=$(echo $cores|tr -cd '[0-9]')
	if test -z $cores; then
		echo "default 4"
		export RealCores=4
		break
	else
		if (( $cores >= 17 )); then
			echo "Error : 好家伙《线程撕裂者》"
		else
			if (( $cores < 1 )); then
				echo "Error : 好家伙，图灵直呼内行"
			else
				export RealCores=$cores
				echo "$cores cores"
				break
			fi
		fi
	fi
done
	echo "选个显卡?"
	echo "[cirrus][std][vmware][virtio][qxl]   默认(cirrus)"
while read gpu
do
	if test -z $gpu; then
		export gpu='cirrus'
		echo "你选择了 $gpu"
		break
	else
		if [ $gpu = 'cirrus' ]; then
			export gpu='cirrus'
			echo "你选择了 $gpu"
			break
		else
			if [ $gpu = 'std' ]; then
				export gpu='std'
				echo "你选择了 $gpu"
				break
			else
				if [ $gpu = 'vmware' ]; then
					export gpu='vmware'
					echo "你选择了 $gpu"
					break
				else
					if [ $gpu = 'virtio' ]; then
						export gpu='virtio'
						echo "你选择了 $gpu"
						break
					else
						if [ $gpu = 'qxl' ]; then
							export gpu='qxl'
							echo "你选择了 $gpu"
							break
						fi
					fi
				fi
			fi
		fi
	fi
done
echo "图形显示方式?"
echo "[VNC][SDL][None]  默认(VNC)"
while read display
do
	if test -z $display; then
		VNC_server
		export enable_vnc=1
		export enable_sdl=0
		break
	else
		if [ $display = 'VNC' ]; then
			VNC_server
			export enable_vnc=1
			export enable_sdl=0
			break
		else
			if [ $display = 'SDL' ]; then
				export qemu_display="-display sdl"
				export enable_sdl=1
				export enable_vnc=0
				break
			else
				if [ $display = 'None' ]; then
					echo " "
					export enable_vnc=0
					export enable_sdl=0
					break
				fi
			fi
		fi
	fi
done
export MEMINFO=$(head -1 /proc/meminfo|tr -cd '[0-9]')
export MEMINFO_A=$(expr $MEMINFO / 1024)
echo "给你的虚拟机写一个内存，还有，你现在的内存只有 $MEMINFO_A MiB，别给我耍花样"
echo "[数字]最好高于64MiB"
while read mem
do
	export mem=$(echo $mem|tr -cd '[0-9]')
	if test -z $mem; then
		Error 8
	else
		if (( $mem >= $MEMINFO_A )); then
			Error 8
		else
			if (( $mem <= 64 )); then
				Error 8
			else
				export MEMORY=$mem
				echo "行， $MEMORY MiB，就这么多"
				export RMEMORY=$MEMORY
				break
			fi
		fi
	fi
done
}
function VNC_server		#VNC服务器
{
echo "写一下VNC端口？"
echo "[数字 1-254]"
while read port
do
	export port=$(echo $port|tr -cd '[0-9]')
	if (( $port <= 0 )); then
		Error 7
	else
		if (( $port >= 255 )); then
			Error 7
		else
			if test -z $port; then
				Error 7
			else
				echo "选择了 host:$port"
				echo "你现在可以用VNC查看器链接这个地址: "
				echo "1.你的IP地址s:$port   2.(本地) localhost:$port or 127.0.0.1:$port"
				break
			fi
		fi
	fi
done
}
function cdrom		#光盘。
{
	echo "你需要光盘吗?"
	echo "[yes][Yes][y][Y][no][No][n][N]   默认(yes)"
	read cdrom_nee
	YES_NO $cdrom_nee
if (( $? == 1 )); then
	export path0=$(pwd)
	echo "你的光盘映像在哪里?"
	echo "[位置][没有的可以写None],你的终端在 $path0   默认($path0)"
while	read path1
do
	if test -z $path1; then
		echo "交白卷？"
		echo ""
		echo "你的光盘映像在哪里?"
		echo "[位置][没有的可以写None],你的终端在 $path0   默认($path0)"
	else
		if [ $path1 = 'None' ]; then
			return 0
		fi
		export file0=$(ls $path1)
		if test -z $file0; then
			echo "There are no any files in $path1"
			echo ""
			echo "你的光盘映像在哪里?"
			echo "[位置][没有的可以写None],你的终端在 $path0   默认($path0)"
		else
			for c in $path1/*.iso *.img
			do
				ls $c
				if (( $? == 2 )); then
					echo "There are no any cdrom files in $path1"
					echo ""
					echo "你的光盘映像在哪里?"
					echo "[位置][没有的可以写None],你的终端在 $path0   默认($path0)"
				else
					if (( $? == 0 )); then
						export files0=$(ls $c)
						break
					fi
				fi
			done
			if (( $? == 0 )); then
				break
			fi
		fi
	fi
done
echo "你需要用哪个映像?"
ls $c
while read image
do
	ls $path1/$image
	if (( $? == 0 )); then
		export RealImage=$path1/$image
		break
		return 1
	fi
done
else
	return 0
fi
}
function floppy		#软盘
{
	echo "你需要一个软驱吗?"
	echo "[yes][Yes][y][Y][no][No][n][N]   默认(yes)"
	read floppy_nee
	YES_NO $floppy_nee
if (( $? == 1 )); then	
	export path2=$(pwd)
	echo "你的软盘映像文件在哪里?"
	echo "[位置][没有的可以写None],你的终端在 $path2   默认($path2)"
while	read path3
do
	if test -z $path3; then
		echo "写个正确的地址吧"
		echo ""
		echo "你的软盘映像文件在哪里?"
		echo "[位置][没有的可以写None],你的终端在 $path2   默认($path2)"
	else
		if [ $path3 = 'None' ]; then
			return 0
		fi
		export file1=$(ls $path3)
		if test -z $file1; then
			echo "$path3 这里似乎没有任何一个文件"
			echo ""
			echo "你的软盘映像文件在哪里?"
			echo "[位置][没有的可以写None],你的终端在 $path2   默认($path2)"
		else
			for f in $path3/*.ima *.img *.vfd
			do
				ls $f
				if (( $? == 2 )); then
					echo "$path3 这里似乎没有任何一个映像文件"
					echo ""
					echo "你的软盘映像文件在哪里?"
					echo "[位置][没有的可以写None],你的终端在 $path2   默认($path2)"
				else
					if (( $? == 0 )); then	
						export files1=$(ls $f)
						break
					fi
				fi
			done
			if (( $? == 0 )); then
				break
			fi
		fi
	fi
done
echo "你想用哪一个映像文件?"
ls $f
while read floppy
do
	ls $path3/$floppy
	if (( $? == 0 )); then
		export RealFloppy=$path3/$floppy
		break
		return 1
	fi
done
else
	return 0
fi
}
function bios		#bios
{
	echo "你需要追加一个外部BIOS文件吗?"
	echo "[yes][Yes][y][Y][no][No][n][N]   默认(yes)"
	read bios_nee
	YES_NO $bios_nee
if (( $? == 1 )); then	
	export path4=$(pwd)
	echo "你的BIOS固件在哪里?"
	echo "[目录][没有的可以写None]你的终端在 $path4   默认(None)"
	while	read path5
	do
		if test -z $path5; then
			break
			return 0
		else
			if [ $path5 = 'None' ]; then
				break
				return 0
			else
				export file2=$(ls $path5)
				if test -z $path5; then
					echo "$path5 这里似乎没有任何一个文件"
					echo ""
					echo "你的BIOS固件在哪里?"
					echo "[目录][没有的可以写None]你的终端在 $path4   默认(None)"
				else
					for b in $path5/*.bin
					do
						ls $b
						if (( $? == 2 )); then
							echo "$path5 这里似乎没有任何一个BIOS固件"
							echo ""
							echo "你的BIOS固件在哪里?"
							echo "[目录][没有的可以写None]你的终端在 $path4   默认(None)"
						else
							if (( $? == 0 )); then
								export files2=$(ls $b)
								break
							fi
						fi
					done
					if (( $? == 0 )); then
						break
					fi
				fi
			fi
		fi
	done
		echo "你要用哪一个BIOS固件?"
		ls $b
		while read bios
		do
			ls $path5/$bios
			if (( $? == 0 )); then
				export RealBios=$path5/$bios
				break
				return 1
			fi
		done
else
	if (( $? == 0 )); then
		echo "好吧，你还是会用回默认的BIOS"
		return 0
	fi
fi
}
function enable_network		#网好卡，好网卡
{
	echo "你需要网卡吗?"
	read network_nee
	YES_NO $network_nee
		if (( $? == 0 )); then
			echo ""
			return 0
		else
			if (( $? == 1 )); then
				echo "哪一个型号?"
				echo "[virtio][rtl8139][e1000][pcnet][i82551]    default(rtl8139)"
				while read network_model
				do
					if test -z $network_model; then
						export network='rtl8139'
						echo "你选择了 $network"
						export RealNetwork="-netdev user,id=eth0 -net nic,model=$network,netdev=eth0"	
						return 1
					else
						if [ $network_model = 'virtio' ]; then
							export network='virtio'
							echo "你选择了 $network"
							export RealNetwork="-netdev user,id=eth0 -net nic,model=$network,netdev=eth0"
							return 1
						else
							if [ $network_model = 'rtl8139' ]; then
								export network='rtl8139'
								echo "你选择了 $network"
								export RealNetwork="-netdev user,id=eth0 -net nic,model=$network,netdev=eth0"
								return 1
							else
								if [ $network_model = 'e1000' ]; then
									export network='e1000'
									echo "你选择了 $network"
									export RealNetwork="-netdev user,id=eth0 -net nic,model=$network,netdev=eth0"
									return 1
								else
									if [ $network_model = 'pcnet' ]; then
										export network='pcnet'
										echo "你选择了 $network"
										export RealNetwork="-netdev user,id=eth0 -net nic,model=$network,netdev=eth0"
										return 1
									else
										if [ $network_model = 'i82551' ]; then
											export network='i82551'
											echo "你选择了 $network"
											export RealNetwork="-netdev user,id=eth0 -net nic,model=$network,netdev=eth0"
											return 1
										else
											Error 6
										fi
									fi
								fi
							fi
						fi
					fi
				done
			fi
		fi

}
function kernel_initrd		#内核？
{
	echo "你需要从内核文件启动吗?"
	echo "[yes][Yes][y][Y][no][No][n][N]  默认(yes)"
	read kernel_nee
	YES_NO $kernel_nee
	if (( $? == 1 )); then
		echo "你需要追加initrd吗?"
		echo "[yes][Yes][y][Y][no][No][n][N]  默认(yes)"
		read initrd_nee
		YES_NO $initrd_nee
		if (( $? == 1 )); then
			echo "你的内核文件在哪里?"
			echo "[位置]  你的终端在 $(pwd)   默认($(pwd))"
			while	read kernel_dire
			do
				if test -z $kernel_dire; then
				echo "写个正确的位置吧"
				echo ""
				echo "你的内核文件在哪里?"
				echo "[位置]  你的终端在 $(pwd)   默认($(pwd))"
				else
					export file3=$(ls $kernel_dire)
					if test -z $kernel_dire; then
					echo "$kernel_dire 这里似乎没有任何文件"
					echo ""
					echo "你的内核文件在哪里?"
					echo "[位置]  你的终端在 $(pwd)   默认($(pwd))"
					else
						for k in $kernel_dire/*vmlinuz*
						do
							ls $k
							if (( $? == 2 )); then
								echo "$kernel_dire 这里似乎没有任何内核文件"
								echo ""
								echo "你的内核文件在哪里?"
								echo "[位置]  你的终端在 $(pwd)   默认($(pwd))"
							else
								if (( $? == 0 )); then
									export files3=$(ls $k)
									break
								fi
							fi
						done
						if (( $? == 0 )); then
							break
						fi
					fi
				fi
			done
			echo "你会选择哪个内核文件?"
			for vm in $kernel_dire/*vmlinuz*; do echo $(ls $vm);done
			while read kernel
			do
				echo "$(ls $kernel_dire/$kernel)"
				if (( $? == 0 )); then
					export RealVmlinuz=$kernel_dire/$kernel
					export enable_kernel=1
					break
				fi
			done
			
				echo "你的initrd文件呢?"
				echo "[位置]  你的终端在 $(pwd)   默认($(pwd))"
			while	read initrd_dire
			do
				if test -z $initrd_dire; then
				echo "写一个正确的位置吧"
				echo ""
				echo "你的initrd文件呢?"
				echo "[位置]  你的终端在 $(pwd)   默认($(pwd))"
				else
					export file4=$(ls $initrd_dire)
					if test -z $initrd_dire; then
					echo "$initrd_dire 这里似乎没有任何文件"
					echo ""
					echo "你的initrd文件呢?"
					echo "[位置]  你的终端在 $(pwd)   默认($(pwd))"
					else
						for i in $initrd_dire/*initrd*
						do
							ls $i
							if (( $? == 2 )); then
								echo "$initrd_dire 这里似乎没有任何内核文件"
								echo ""
								echo "你的initrd文件呢?"
								echo "[位置]  你的终端在 $(pwd)   默认($(pwd))"
							else
								if (( $? == 0 )); then
									export files4=$(ls $i)
									break
								fi
							fi
						done
						if (( $? == 0 )); then
							break
						fi
					fi
				fi
			done
			echo "你会用哪个initrd文件?"
			for rd in $initrd_dire/*initrd*; do echo "$(ls $rd)"; done
			while read initrd
			do
				ls $initrd_dire/$initrd
				if (( $? == 0 )); then
					export RealInitrd=$initrd_dire/$initrd
					export enable_initrd=1
					break
				fi
			done
		else
			if (( $? == 0 )); then
				echo "你的内核文件在哪里?"
				echo "[位置]  你的终端在 $(pwd)   默认($(pwd))"
				while	read kernel_dire
				do
					if test -z $kernel_dire; then
					echo "Please enter correct directory"
					echo ""
					echo "你的内核文件在哪里?"
					echo "[位置]  你的终端在 $(pwd)   默认($(pwd))"
					else
						export file3=$(ls $kernel_dire)
						if test -z $kernel_dire; then
						echo "There are no any files in $kernel_dire"
						echo ""
						echo "你的内核文件在哪里?"
						echo "[位置]  你的终端在 $(pwd)   默认($(pwd))"
						else
							for k in $kernel_dire/*vmlinuz*
							do
								ls $k
								if (( $? == 2 )); then
									echo "There are no any kernel files in $kernel_dire"
									echo ""
									echo "你的内核文件在哪里?"
									echo "[位置]  你的终端在 $(pwd)   默认($(pwd))"
								else
									if (( $? == 0 )); then
										export files3=$(ls $k)
										break
									fi
								fi
							done
							if (( $? == 0 )); then
								break
							fi
						fi
					fi
				done
				echo "你会使用哪个内核文件?"
				for kn in $kernel_dire/*vmlinuz*; do echo "$(ls $kn)";done
				while read kernel
				do
					ls $kernel_dire/$kernel
					if (( $? == 0 )); then
						export RealVmlinuz=$kernel_dire/$kernel
						export enable_initrd=0
						export enable_kernel=1
						break
					fi
				done
			fi
		fi
	else
		export enable_kernel=0
		export enable_initrd=0
	fi
}
function boot		#启动优先级
{
	echo "启动项"
	echo "[a,b : 软盘[c : 硬盘][d : 光盘]"
while read boot_options
do
	if [ $boot_options = 'a' ]; then
		export qemu_boot='-boot a'
		break
	else
		if [ $boot_options = 'b' ]; then
			export qemu_boot='-boot b'
			break
		else
			if [ $boot_options = 'c' ]; then
				export qemu_boot='-boot c'
				break
			else
				if [ $boot_options = 'd' ]; then
					export qemu_boot='-boot d'
					break
				else
					if test -z $boot_options; then
						echo "写个正确的启动项吧"
						echo ""
						echo "启动项"
						echo "[a,b : 软盘[c : 硬盘][d : 光盘]"
					else
						echo "写个正确的启动项吧"
					fi
				fi
			fi
		fi
	fi
done
}
function monitor
{
	echo "你需要追加-monitor参数吗?"
	echo "[yes][Yes][no][No][y][Y][n][N]  默认(yes)"
	read enable_monitor
	YES_NO $enable_monitor
	if (( $? == 1 )); then
		echo "选择本地monitor还是telnet?"
		echo "[telnet][stdio]  默认(stdio)"
		while read form_monitor
		do
			if test -z $form_monitor; then
				echo "本地控制台"
				export RealMonitor="-monitor stdio"
				break
			else
				if [ $form_monitor = 'stdio' ]; then
					echo "本地控制台"
					export RealMonitor="-monitor $form_monitor"
					break
				else
					if [ $form_monitor = 'telnet' ]; then
						telnet
						export RealMonitor="-monitor telnet::$telnet_port,server,nowait"
						break
					else
						echo "请写一个正确的参数"
					fi
				fi
			fi
		done
	else
		export RealMonitor=''
	fi
}
function telnet
{
	echo "输入端口?"
	echo "[数字]1-255   默认(16)"
	while read telnet_port
	do
		export telnet_port=(echo $telnet_port|tr -cd '[0-9]')
		if (( $telnet_port < 1 )); then
			Error 7
		else
			if (( $telnet_port > 255 )); then
				Error 7
			else
				if test -z $telnet_port; then
					export telnet_port=16
					echo "你选择了端口 $telnet_port"
					break
				else
					echo "你选择了端口 $telnet_port"
					break
				fi
			fi
		fi
	done
echo "你现在可以打开新的终端通过此命令连接到控制台"
echo "telnet 127.0.0.1 $telnet_port"
}
function All_process			#后期处理
{
	if ls /etc/apt; then
		install_qemu
		choose_arch
		export RealArch=$Arch
		disks
		if (( $enable_disk == 1 )); then
			export RealDisk2="-drive if=none,file=$RealDisk,id=hd0"
		else
			export RealDisk2=''
		fi
		if (( $disk_nee == 1 )); then
			disks_spaces
			space_process
			disk_other
			export create_img="qemu-img create -f $disk_format $name.img $RealSpace$RealUnit"
			create_img
		fi
		cdrom
		if (( $? == 0 )); then
			export RealImage1=''
		else
			export RealImage1="-cdrom $RealImage"
		fi
		floppy
		if (( $? == 0 )); then
			export RealFloppy=''
		else
			export RealFloppy1="-fda $RealFloppy"
		fi
		bios
		if (( $? == 0 )); then
			export RealBios1=''
		else
			export RealBios1="-bios $RealBios"
		fi
		kernel_initrd
		if (( $enable_kernel == 0 )); then
			export RealVmlinuz1=''
		else
			export RealVmlinuz1="-kernel $RealVmlinuz"
		fi
		if (( $enable_initrd == 0 )); then
			export RealInitrd1=''
		else
			export RealInitrd1="-initrd $RealInitrd"
		fi
		enable_network
		if (( $? == 0 )); then
			export RealNetwork1=''
		else
			export RealNetwork1=$RealNetwork
		fi
		CPU_GPU_VNC_MEM
		export RealCPU="-cpu $cpu"
		export RealCores1="-smp $RealCores"
		export RealVGA="-vga $gpu"
		if (( $enable_vnc == 1 )); then
			export port=$port
			export RealDSP="-vnc :$port"
		else
			if (( $enable_sdl == 1 )); then
				export RealDSP='-display sdl'
			else
				export RealDSP=''
			fi
		fi
		boot
		monitor
	else
		echo "该脚本目前只能在Debian及基于Debian的操作系统使用"
		echo ""
		echo "按任意键退出"
		read -n1 -p "" EX_CD
		exit
	fi
}
echo "这是Qemu脚本生成器1.0 For Linux"
echo "使用shell编写"
sleep 1s
echo "作者：hyper-v管理器"
sleep 1s
echo "给个关注可否？"
sleep 1s
echo "请稍等"
sleep 3s
All_process
export Realmem="-m $RMEMORY"
echo "$Arch $qemu_boot $Realmem $RealBios1 $RealDisk2 $DISK2 $RealImage1 $RealFloppy1 $RealInitrd1 $RealVmlinuz1  $RealMonitor $RealDSP $RealNetwork1 $RealCPU $RealVGA $RealCores1"
export ALL="$Arch $qemu_boot $RealBios1 $Realmem $RealDisk2 $DISK2 $RealImage1 $RealFloppy1 $RealInitrd1 $RealVmlinuz1 $RealMonitor $RealDSP $RealNetwork1 $RealCPU $RealVGA $RealCores1"
echo "给你的脚本文件起个名字吧"
while read filename
do
	if test -z $filename; then
		echo "名字不能为空"
		echo ""
		sleep 1s
		echo "给你的脚本文件起个名字吧"
	else
		export NAME=$filename
		echo "请稍等"
		sleep 2s
		break
	fi
done
echo $ALL > $NAME.sh

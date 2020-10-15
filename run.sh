#/bin/bash

if [ x"$1" = x ]; then
    echo no param!
	exit
fi

let num=$1

if [ $num -lt 1 ]; then
    echo etcd node could not less than 1!
	exit
fi

if [ $num -gt 253 ]; then
    echo could not set 253 nodes,please!
	exit
fi

if [ $(($num % 2)) = 0 ]; then
    num=$(($num - 1))
fi

if [ $num -gt 1 ]; then
    echo start $num nodes...
else
    echo start $num node...
fi

clusters=""
for i in $(seq 1 $num); do
    rm -rf /tmp/etcd${i}-data.tmp && mkdir -p /tmp/etcd${i}-data.tmp && chmod 700 /tmp/etcd${i}-data.tmp
	clusters=$clusters"etcd${i}=http://192.168.28.${i}:2380,"
done
clusters=${clusters%?}

for i in $(seq 1 $num); do
docker run -d \
--network mynetwork \
--ip 192.168.28.${i} \
--mount type=bind,source=/tmp/etcd${i}-data.tmp,destination=/etcd-data \
--name etcd${i} \
huanghanyi/etcdv3.4.13:latest \
/usr/local/bin/etcd \
--name etcd${i} \
--data-dir /etcd-data \
--listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001 \
--advertise-client-urls http://192.168.28.${i}:2379,http://192.168.28.${i}:4001 \
--listen-peer-urls http://0.0.0.0:2380 \
--initial-advertise-peer-urls http://192.168.28.${i}:2380 \
--initial-cluster ${clusters} \
--initial-cluster-token etcd-cluster \
--initial-cluster-state new \
--log-level warn \
--logger zap \
--log-outputs stderr
done

if [ $# -lt 6 ]; then
	./Scripts/build.sh
	exit
fi
echo "./Scripts/build.sh -b rzv2l  $1 $2 $3 $4 $5 $6 $7"
./Scripts/build.sh -b rzv2l  $1 $2 $3 $4 $5 $6 $7
echo "./Scripts/build.sh -b rzv2l -e $1 $2 $3 $4 $5 $6 $7"
./Scripts/build.sh -b rzv2l -e $1 $2 $3 $4 $5 $6 $7
echo "./Scripts/build.sh -b rzv2l -e -i $1 $2 $3 $5 $6 $7"
./Scripts/build.sh -b -i rzv2l -e -i $1 $2 $3 $4 $5 $6 $7
#./Scripts/build.sh -b test $1 $2 $3 $4 $5 $6 $7 -a tfl

#echo "./Scripts/build.sh -b rzboard -i $1 $2 $3 $4 $5 $6 $7"
#./Scripts/build.sh -b rzboard -i $1 $2 $3 $4 $5 $6 $7

#echo "./Scripts/build.sh -b rzbaord -e -i $1 $2 $3 $4 $5 $6 $7"
#./Scripts/build.sh -b rzboard -e -i $1 $2 $3 $4 $5 $6 $7

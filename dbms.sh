#!bin/bash
select choice in Create_Database Show_Databases Use_Database Rename_Database Drop_Database Create_Table Drop_Table Insert_To_Table Update_Table Delete_From_Table Select_From_Table_By Select_All

do
case $choice in
Create_Database)
{
	shopt -s extglob
	read -p "Enter Database Name :"
	mkdir $REPLY
}
;;
Show_Databases)
{
	ls -l| grep "^d"
}
;;
Use_Database)
{
	shopt -s extglob
	read -p "Enter Database Name :"
	cd $REPLY
}
;;
Rename_Database)
{
	shopt -s extglob
	read -p "Enter Database Name To Use :"
	set -x
	olddb=$REPLY
	shopt -s extglob
	read -p "Enter New Database Name :"
	newdb=$REPLY
	set +x
	mv $olddb $newdb
}
;;
Drop_Database)
{
	shopt -s extglob
	read -p "Enter Database Name To DELETE :"
	rm -r $REPLY
}
;;
Create_Table)
{
	shopt -s extglob
	read -p "Enter Name of Table?"
	tableName=$REPLY
	touch $tableName
	shopt -s extglob
	read -p "Enter Number of Columns?"
	numCols=$REPLY
	for(( i=0; i<$numCols ;i++ ))
	do
		shopt -s extglob
		read -p "Enter name of column :"
		colName=$REPLY
		shopt -s extglob
		read -p "Enter Type (int or string):"
		colType=$REPLY
		if((i==$numCols-1))
		then
		echo  "$colName:$colType">>$tableName
		else
		echo -n "$colName:$colType:">>$tableName
		fi

	done
}
;;
Drop_Table)
{
	shopt -s extglob
	read -p "Enter Table Name To DELETE :"
	rm -r $REPLY
}
;;
Insert_To_Table)
{
	shopt -s extglob
	read -p "Enter Table Name : "
	table=$REPLY
	numOfFields=$(awk -F: 'END{print NF}' $table)
	echo $numOfFields
	arr=($(awk -F: '{ for ( i = 1 ; i <= NF; i++){ if (NR==1) print $i; } }' $table));

	for (( i = 0; i < ${#arr[@]}; i++ ));
	  do
	 if ((i%2==0))
	 then
		echo "Enter "${arr[i]}" : ";
		read
		echo -n $REPLY":">>$table
	else
			if((i==${#arr[@]}-1))
			then
				echo " :">>$table
			else
				echo -n " :">>$table
			fi
	 fi
	 done
}
;;
Update_Table) echo Update Table.
;;
Delete_From_Table)
{
	echo Delete Table.
}
;;
Select_From_Table_By)
{
	shopt -s extglob
	read -p "Enter Table Name : "
	table=$REPLY
	arr=($(awk -F: '{ for ( i = 1 ; i <= NF; i++){ if (NR==1) print $i; } }' $table));
	echo 'you can select by :'
	echo 'all'
	for (( i = 0; i < ${#arr[@]}; i++ ));
	  do
	 if ((i%2==0))
	 then
		 echo ${arr[i]}
	 fi
	 done
	 shopt -s extglob
 	 read -p "Enter selection value you want to select by : "
 	 selection=$REPLY
	 data=$(sed -n '/'$selection'/p' $table)
	 echo $data
}
;;

Select_All)
shopt -s extglob
read -p "Enter Table Name : "
table=$REPLY
data=$(awk -F: '{print $0}' $table)
echo $data

 ;;
*) echo $REPLY is not one of the choices.
;;
esac
done

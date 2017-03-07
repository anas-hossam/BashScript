#!bin/bash

select choice in Create_Database Use_Database Rename_Database Drop_Database Create_Table Drop_Table Insert_To_Table Update_Table Delete_From_Table Select_From_Table
do
case $choice in
Create_Database)
{
	shopt -s extglob
	read -p "Enter Database Name :"
	mkdir $REPLY
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
	read -p "Enter Name of Table: "
	tableName=$REPLY
	touch $tableName
	shopt -s extglob
	read -p "Enter Number of Columns: "
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
Update_Table)
{
	#echo Update Table.
	shopt -s extglob
	read -p "Enter Table Name : "
	table=$REPLY
	read -p "Update Where ID : "
	id=$REPLY
	numOfFields=$(awk -F: '{if (NR==1) print NF;}' $table)
  numOfRow=$(awk -v n=${id} 'BEGIN{FS=":"; RS="\n";}{if ($1==n){ print NR;}}' $table)
	oldValue=$(awk -v n=${id} 'BEGIN{FS=":"; RS="\n";}{if ($1==n){ print $3;}}' $table)
	lines=$(awk -v n=${id} 'BEGIN{FS=":"; RS="\n";}{if ($1==n){ print $0;}}' $table)
	#echo $lines
  read -p "Enter New Value of '$oldValue' : "
	newValue=$REPLY
$(sed -i "s/$oldValue/$newValue/g" "$table")
echo $(sed -n "${numOfRow}p" $table)
}
;;
Delete_From_Table)
{
	shopt -s extglob
	read -p "Enter Table Name : "
	table=$REPLY
	read -p "Delete Where ID : "
	id=$REPLY
	numOfRow=$(awk -v n=${id} 'BEGIN{FS=":"; RS="\n";}{if ($1==n){ print NR;}}' $table)
  $(sed -i "${numOfRow}d" "$table")
}
;;
Select_From_Table)
{
	echo select
}
;;
*) echo $REPLY is not one of the choices.
;;
esac
done

#!bin/bash
# function take table and field name return field number
function getFieldNumber
{
	arr=($(awk -F: '{ for ( i = 1 ; i <= NF; i++){ if (NR==1) print $i; } }' $1));
	for (( i = 0; i < ${#arr[@]}; i++ ));
	  do
		if [[ $2 == *"${arr[i]}"* ]]
		then
		return $(( $i+1 ))
		fi
	  done
}
# Integer Validation Function
function validInt
{
	re='^[0-9]+$'
if ! [[ $1 =~ $re ]]
 then
   return 0
fi
return 1
}
# String Validation Function
function validString
{
	re='^[A-Za-z]+[0-9]*$'
if ! [[ $1 =~ $re ]]
 then
   return 0
fi
return 1
}
select choice in Show_Databases Create_Database Use_Database Rename_Database Drop_Database Create_Table Drop_Table Insert_To_Table Update_Table Delete_From_Table Select_Where Select_From_Table_By Select_All
do
case $choice in
Show_Databases)
{
	ls -l | grep "^d"
}
;;
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
	#set -x
	olddb=$REPLY
	shopt -s extglob
	read -p "Enter New Database Name :"
	newdb=$REPLY
	#set +x
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
	read -p "Enter PK of Table: "
	pk=$REPLY
	for(( i=0; i<$numCols ;i++ ))
	do
		shopt -s extglob
		read -p "Enter name of column :"
		colName=$REPLY
		if [[ $pk == *"$colName"* ]]
		then
			colName=$colName"_PK"
		fi
		shopt -s extglob
		read -p "Enter Type (int or string) : "
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
	arr=($(awk -F: '{ for ( i = 1 ; i <= NF; i++){ if (NR==1) print $i; } }' $table));
	for (( i = 0; i < ${#arr[@]}; i++ ));
	  do
	 if ((i%2==0))
	 then
		echo "Enter "${arr[i]}" : ";
		read
	fieldName=$REPLY
	# check if integer value valid
	if [[ ${arr[i+1]} == *"int"* ]]
	then
		validInt $fieldName
		res=$?
		while(( res == 0 ))
		do
			echo "error : not a number, Try Again :"
			read
		  fieldName=$REPLY
	  	validInt $fieldName
		  res=$?
	done
	fi
	# check if string value valid
	if [[ ${arr[i+1]} == *"string"* ]]
	then
		validString $fieldName
		res=$?
		while(( res == 0 ))
		do
			echo "error : not a string, Try Again :"
			read
		  fieldName=$REPLY
		  validString $fieldName
		  res=$?
	done
	fi
		echo -n $fieldName":">>$table
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
Select_Where)
{
	shopt -s extglob
	read -p "Enter Table Name : "
	table=$REPLY
	arr=($(awk -F: '{ for ( i = 1 ; i <= NF; i++){ if (NR==1) print $i; } }' $table));
	echo 'you can select by :'
	#echo 'all'
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
	 data=$(sed -n "/$selection/p" $table)
	 echo $data
}
;;
Select_From_Table_By)
{
	shopt -s extglob
	read -p "Enter Table Name : "
	table=$REPLY
	arr=($(awk -F: '{ for ( i = 1 ; i <= NF; i++){ if (NR==1) print $i; } }' $table));
	echo 'you can select by :'
	#echo 'all'
	for (( i = 0; i < ${#arr[@]}; i++ ));
	  do
	 if ((i%2==0))
	 then
		 echo ${arr[i]}
	 fi
	 done
	 shopt -s extglob
 	 read -p "Enter Column name you want to select by : "
 	 selection=$REPLY
	 getFieldNumber $table $selection
	 fieldIndex=$?
	 #echo $fieldIndex
   data=$(awk -v n=${fieldIndex} 'BEGIN{ FS=":";RS="\n"; }{ print $n; }' $table);
	 for (( i = 0; i < ${#data[@]}; i++ ));
	  do
	    echo ${data[i]}
	  done
}
;;
Select_All)
shopt -s extglob
read -p "Enter Table Name : "
table=$REPLY
data=$(awk -F: '{if(NR != 1) print $0;}' $table)
echo $data
;;
*) echo $REPLY is not one of the choices.
;;
esac
done

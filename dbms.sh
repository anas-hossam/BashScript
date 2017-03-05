#!bin/bash

select choice in Create_Database Rename_Database Drop_Database Create_Table Drop_Table Update_Table Delete_From_Table Select_From_Table 
do
case $choice in
Create_Database) 
{
	shopt -s extglob
	read -p "Enter Database Name :"
	mkdir $REPLY
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
Create_Table) echo Create Table.
;;
Drop_Table) echo Drop Table.
;;
Update_Table) echo Update Table.
;;
Delete_From_Table) echo Delete From Table.
;;
Select_From_Table) echo Select From Table.
;;
*) echo $REPLY is not one of the choices.
;;
esac
done

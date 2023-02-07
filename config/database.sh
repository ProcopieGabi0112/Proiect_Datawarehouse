# custom scripts ON dw_manager.start up
# echo "====> checking for custom scripts ON dw_manager.startup..."
# if [ ! "$(ls -A /home/oracle/setup/*.sql)" ]
# then
#     echo "/home/oracle/setup is empty!"
# else
#     echo "/home/oracle/setup is not empty"
# for filename in /home/oracle/setup/*.sql; do
#     echo "Executing file $filename..."
#     sqlplus / as sysdba 2>&1 <<EOF
#           @$filename;
#           exit;
# EOF
# done
# fi
#!/bin/sh
file="index-data-back"
if [ ! -f "$file" ]
then
    echo "$file not found in this directly and create it with default value '-1,-1'"
	echo "-1,-1,-1" >> $file
fi


sourceDBUrl="jdbc:oracle:thin:amdb_260@localhost:1521/xe"
sourceDBUser="amdb_260"
sourceDBPass="amdb_260"
sourceDBDriver="oracle.jdbc.OracleDriver"

destDBUrl="jdbc:oracle:thin:amdb_200@localhost:1521/xe"
destDBUser="amdb_200"
destDBPass="amdb_200"
destDBDriver="oracle.jdbc.OracleDriver"

java -jar db-sync-tool-reverse-2.6.0-jar-with-dependencies.jar \
$sourceDBUrl  $sourceDBUser  $sourceDBPass  $sourceDBDriver  $destDBUrl  $destDBUser  $destDBPass  $destDBDriver


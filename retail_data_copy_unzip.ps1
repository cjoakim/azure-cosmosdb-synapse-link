
# Copy the generated retail_dataset.zip file to the app-specific Xxx\data\ directories
# and unzip it there.
# Chris Joakim, Microsoft

$zipfile="DatasetGeneration\data\retail\retail_dataset.zip"
$basename="retail_dataset.zip"

echo '==='
echo 'creating data directories ...'
new-item -itemtype directory -force -path "DotnetSqlConsoleApp\data\"     | Out-Null
new-item -itemtype directory -force -path "JavaMongoConsoleApp\app\data\" | Out-Null
new-item -itemtype directory -force -path "JavaSqlConsoleApp\app\data\"   | Out-Null
new-item -itemtype directory -force -path "PythonMongoConsoleApp\data\"   | Out-Null
new-item -itemtype directory -force -path "PythonSqlConsoleApp\data\"     | Out-Null

echo '==='
echo 'listing zipfile contents ...'
jar tvf $zipfile

echo '==='
echo 'copying zip file to target ConsoleApp directories ...'
Copy-Item -Path $zipfile -Destination "DotnetSqlConsoleApp\data\"
Copy-Item -Path $zipfile -Destination "JavaMongoConsoleApp\app\data\"
Copy-Item -Path $zipfile -Destination "JavaSqlConsoleApp\app\data\"
Copy-Item -Path $zipfile -Destination "PythonMongoConsoleApp\data\"
Copy-Item -Path $zipfile -Destination "PythonSqlConsoleApp\data\"

echo '==='
echo 'unzipping in DotnetSqlConsoleApp ...'
cd "DotnetSqlConsoleApp\data\"
pwd
jar xvf $basename
cd ../..

echo '==='
echo 'unzipping in JavaMongoConsoleApp ...'
cd "JavaMongoConsoleApp\app\data\"
pwd
jar xvf $basename
cd ..\..\..

echo '==='
echo 'unzipping in JavaSqlConsoleApp ...'
cd "JavaSqlConsoleApp\app\data\"
pwd
jar xvf $basename
cd ..\..\..

echo '==='
echo 'unzipping in PythonMongoConsoleApp ...'
cd "PythonMongoConsoleApp\data\"
pwd
jar xvf $basename
cd ..\..
 
echo '==='
echo 'unzipping in PythonSqlConsoleApp ...'
cd "PythonSqlConsoleApp\data\"
pwd
jar xvf $basename
cd ..\..

echo 'done'

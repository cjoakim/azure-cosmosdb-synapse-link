
# Copy the generated retail dataset zip file to the Xxx\data\ directories
# and jar xvf it there.
# Chris Joakim, Microsoft

$zipfile="DatasetGeneration\data\retail\retail_dataset.zip"
$basename="retail_dataset.zip"

echo '==='
echo 'creating data directories ...'
new-item -itemtype directory -force -path "DotnetConsoleApp\data\"   | Out-Null
new-item -itemtype directory -force -path "JavaConsoleApp\app\data\" | Out-Null
new-item -itemtype directory -force -path "PythonConsoleApp\data\"   | Out-Null

echo '==='
echo 'listing zipfile contents ...'
jar tvf $zipfile

echo '==='
echo 'copying zip file to target ConsoleApp directories ...'
Copy-Item -Path $zipfile -Destination "DotnetConsoleApp\data\"
Copy-Item -Path $zipfile -Destination "JavaConsoleApp\app\data\"
Copy-Item -Path $zipfile -Destination "PythonConsoleApp\data\"

echo '==='
echo 'unzipping in DotnetConsoleApp ...'
cd "DotnetConsoleApp\data\"
pwd
jar xvf $basename
cd ../..

echo '==='
echo 'unzipping in JavaConsoleApp ...'
cd "JavaConsoleApp\app\data\"
pwd
jar xvf $basename
cd ..\..\..

echo '==='
echo 'unzipping in PythonConsoleApp ...'
cd "PythonConsoleApp\data\"
pwd
jar xvf $basename
cd ..\..
 
echo 'done'
